#!/system/bin/sh
# Wait for boot to complete
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 1
done

# 1. Clear conflicting treble_app system properties
setprop persist.sys.phh.rounded_corners_padding ""
setprop persist.sys.phh.status_bar_padding_top ""
setprop persist.sys.phh.status_bar_padding_start ""
setprop persist.sys.phh.status_bar_padding_end ""

# 2. Reset dynamic secure settings that override static RROs
settings delete secure sysui_rounded_content_padding || true
settings delete secure sysui_rounded_size || true

# 3. Automatically find and disable conflicting GSI/PHH/Treble overlays
for overlay in $(cmd overlay list | grep -E '^\[x\]' | awk '{print $2}'); do
    if echo "$overlay" | grep -qE "treble|phh"; then
        if echo "$overlay" | grep -qE "systemui|statusbar|notch"; then
            cmd overlay disable "$overlay" || true
        fi
    fi
done

# 4. Force enable our custom overlays
cmd overlay enable com.moloo4ni.statusbar.fix.obsidian.android || true
cmd overlay enable com.moloo4ni.statusbar.fix.obsidian.systemui || true
