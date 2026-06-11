#!/bin/bash
set -e

SDK_DIR="${SDK_DIR:-${ANDROID_HOME:-${ANDROID_SDK_ROOT:-/opt/android-sdk}}}"

if [ ! -d "$SDK_DIR" ]; then
    echo "Error: Android SDK not found at $SDK_DIR."
    echo "Please install android-sdk and android-sdk-build-tools."
    exit 1
fi

BUILD_TOOLS_DIR=$(ls -d $SDK_DIR/build-tools/* 2>/dev/null | sort -V | tail -n 1)
ANDROID_JAR=$(ls -d $SDK_DIR/platforms/android-* 2>/dev/null | sort -V | tail -n 1)/android.jar

if [ -z "$BUILD_TOOLS_DIR" ] || [ ! -f "$ANDROID_JAR" ]; then
    echo "Error: Could not find build-tools or android.jar inside $SDK_DIR."
    exit 1
fi

export PATH="$BUILD_TOOLS_DIR:$PATH"

echo "Using build-tools from: $BUILD_TOOLS_DIR"
echo "Using android.jar: $ANDROID_JAR"

OUT_DIR="out"
KEYSTORE="out/testkey.keystore"
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

# Read version from module.prop
MODULE_VER=$(grep '^version=' module_template/module.prop | cut -d= -f2)
ZIP_NAME="StatusbarFixObsidian-v${MODULE_VER}.zip"

# Generate local test signing key
if [ ! -f "$KEYSTORE" ]; then
    keytool -genkeypair -v \
        -keystore "$KEYSTORE" \
        -alias androiddebugkey \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000 \
        -storepass android \
        -keypass android \
        -dname "CN=moloo4ni, O=GitLab, C=US"
fi

# Clean output directories inside the module skeleton
rm -rf module_template/system/product/overlay/*

for TARGET in "android" "systemui"; do
    echo "Building overlay for target: $TARGET"
    
    COMPILED_RES="out/compiled_$TARGET"
    UNSIGNED_APK="out/unsigned_$TARGET.apk"
    ALIGNED_APK="out/aligned_$TARGET.apk"
    
    if [ "$TARGET" = "android" ]; then
        FOLDER_NAME="StatusbarFixObsidianAndroid"
    else
        FOLDER_NAME="StatusbarFixObsidianSystemUI"
    fi
    
    TARGET_DIR="module_template/system/product/overlay/$FOLDER_NAME"
    mkdir -p "$COMPILED_RES"
    mkdir -p "$TARGET_DIR"
    
    # Compile resources with aapt2
    aapt2 compile --dir "src/$TARGET/res" -o "$COMPILED_RES/"
    
    # Link RRO package
    aapt2 link -o "$UNSIGNED_APK" \
        -I "$ANDROID_JAR" \
        --manifest "src/$TARGET/AndroidManifest.xml" \
        -R "$COMPILED_RES"/*.flat \
        --no-resource-removal \
        --auto-add-overlay
        
    # Align APK
    zipalign -f -p 4 "$UNSIGNED_APK" "$ALIGNED_APK"
    
    # Sign APK
    apksigner sign --ks "$KEYSTORE" \
        --ks-key-alias androiddebugkey \
        --ks-pass pass:android \
        --key-pass pass:android \
        --out "$TARGET_DIR/$FOLDER_NAME.apk" \
        "$ALIGNED_APK"
done

# Zip the Magisk/KSU/APatch module
cd module_template
zip -r "../out/$ZIP_NAME" ./* > /dev/null
cd ..

echo "Build complete: out/$ZIP_NAME"
