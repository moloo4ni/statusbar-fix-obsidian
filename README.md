# Redmi Note 14 Pro 4G (obsidian) Status Bar & QS Height Fix

This repository contains a Magisk / KernelSU / APatch module that corrects the status bar height, lock screen layout, and Quick Settings (QS) offsets specifically for the Redmi Note 14 Pro 4G (codename: obsidian) running LineageOS 23.0 GSI or other Android 13+ GSIs.

## Features

- **Dual RRO Targets:** Separated resource overlays targeting both the Android Framework (`android`) and SystemUI (`com.android.systemui`).
- **Notch Killer:** Overrides the physical SVG display cutout path (`config_mainBuiltInDisplayCutout`) to empty, removing system-enforced minimum height constraints. This allows the status bar and QS panel to shrink to a clean 36dp.
- **AMOLED Burn-In Protection:** Enables native SystemUI pixel-shifting (`config_statusBarBurnInProtection`), which subtly moves status bar icons (clock, battery, signals) every 60 seconds.
- **Priority Overrides:** Uses `values-port` resource directories to guarantee the system prioritizes these overrides over default GSI portrait configurations.
- **GSI Conflict Resolution:** The included background `service.sh` script automatically disables conflicting built-in GSI overlays and resets runtime `treble_app` properties upon boot.

## Installation

1. Go to the **Releases** section of this repository and download the latest zip archive.
2. Flash the zip file using Magisk, KernelSU, or APatch.
3. Open the **Phh Treble Settings** app on your device, navigate to **Misc features**, and reset the following parameters to `-1` (or clear them):
   - `Set rounded corners diameter`
   - `Set forced/faked rounded corners diameter`
   - `Set status bar top padding`
   - `Set status bar start padding`
   - `Set status bar end padding`
4. Reboot your device to apply the changes cleanly.

## Local Building

Before compiling, check the `SDK_DIR` variable in the `build.sh` script. By default, it is set to `/opt/android-sdk`. If your Android SDK is installed in a different directory (such as `~/Android/Sdk`), edit that line to point to your actual SDK path.

Install the required package dependencies for your distribution:

### Arch Linux

```bash
sudo pacman -S jdk-openjdk zip android-tools
yay -S android-sdk android-sdk-build-tools android-platform
```

### Ubuntu / Debian / Linux Mint

```bash
sudo apt update
sudo apt install openjdk-17-jdk zip apksigner zipalign aapt2
```
*Note: Make sure to install the Android platform SDK through Android Studio or cmdline-tools, and point `SDK_DIR` in `build.sh` to your local SDK folder (usually `~/Android/Sdk`).*

### Fedora

```bash
sudo dnf install java-17-openjdk-devel zip apksigner zipalign aapt2
```
*Note: Make sure to install the Android platform SDK, and point `SDK_DIR` in `build.sh` to your local SDK folder (usually `~/Android/Sdk` or `/usr/lib/android-sdk`).*

### Compilation

After configuring the dependencies, make the build script executable and run it:

```bash
chmod +x build.sh
./build.sh
```
The compiled ready-to-flash module will be outputted to the `out/` directory.

## CI/CD

This repository is configured with GitHub Actions. Pushing a tag starting with `v` (e.g., `v1.2`) will automatically trigger the build pipeline, compile both RRO packages, generate the flashable zip archive, and publish a new GitHub Release.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
