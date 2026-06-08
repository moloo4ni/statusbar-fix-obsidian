# Redmi Note 14 Pro 4G (obsidian) Status Bar Fix

This repository contains a Magisk / KernelSU / APatch module that corrects the status bar height, lock screen layout, and Quick Settings (QS) offsets specifically for the Redmi Note 14 Pro 4G (codename: obsidian) running LineageOS 23.0 GSI or other Android 13+ GSIs.

## Features
- **Dual RRO Targets:** Separated overlays targeting both the Android Framework (`android`) and SystemUI (`com.android.systemui`).
- **Launcher Padding Fix:** Globally adjusts window insets to align app and launcher headers.
- **Quick Settings Alignment:** Resolves overlapping and icon cut-offs in the notification shade by defining proper QQS and QS panel values.
- **Priority Overrides:** Uses `values-port` resource qualifiers to guarantee the system prioritizes these overrides over default ROM values in portrait orientation.

## Installation
1. Go to the **Releases** section of this repository and download the latest zip archive.
2. Open your root manager (Magisk, KernelSU, or APatch).
3. Flash the zip file.
4. Reboot the device.

## Local Building
If you wish to compile the module from source on Arch Linux:
1. Ensure you have the required dependencies:
   ```bash
   sudo pacman -S jdk-openjdk zip android-tools
   yay -S android-sdk android-sdk-build-tools android-platform
