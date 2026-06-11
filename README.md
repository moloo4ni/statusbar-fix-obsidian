# Redmi Note 14 Pro 4G (obsidian) Status Bar & QS Height Fix

[![GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](LICENSE)

[English](#english) | [Русский](#russian)

---

<a name="english"></a>
## English

Magisk / KernelSU / APatch module that corrects the status bar height, lock screen layout, and Quick Settings (QS) offsets on the Redmi Note 14 Pro 4G (codename: obsidian) running LineageOS GSI or other Android 13+ GSIs.

### Features

- **Dual RRO overlays** -- independent resource overlays for Android Framework (`android`) and SystemUI (`com.android.systemui`).
- **Notch killer** -- overrides the SVG display cutout path to empty, removing system-enforced minimum height constraints. Status bar and QS panel shrink to a clean 36 dp.
- **AMOLED burn-in protection** -- enables native SystemUI pixel-shifting (`config_statusBarBurnInProtection`). Status bar icons (clock, battery, signals) shift slightly every 60 seconds.
- **Priority overrides** -- uses `values-port` resource directories so the system prioritises these overrides over default GSI portrait values.
- **GSI conflict resolution** -- the included `service.sh` automatically disables conflicting built-in GSI overlays and resets Phh Treble runtime properties on every boot.

### Installation

1. Download the latest zip from the [Releases](https://github.com/moloo4ni/statusbar-fix-obsidian/releases) page.
2. Flash it in Magisk, KernelSU, or APatch.
3. Open **Phh Treble Settings** -> **Misc features** and reset these parameters to `-1` (or clear them):
   - `Set rounded corners diameter`
   - `Set forced/faked rounded corners diameter`
   - `Set status bar top padding`
   - `Set status bar start padding`
   - `Set status bar end padding`
4. Reboot.

### Building from source

`build.sh` auto-detects the Android SDK via `$ANDROID_HOME`, `$ANDROID_SDK_ROOT`, or falls back to `/opt/android-sdk`. You can override it:

```bash
SDK_DIR=~/Android/Sdk ./build.sh
```

The version is read from `module_template/module.prop`, so the output zip always matches the declared module version.

#### Dependencies

| Distro | Command |
|--------|---------|
| Arch Linux | `sudo pacman -S jdk-openjdk zip android-tools`<br>`yay -S android-sdk android-sdk-build-tools android-platform` |
| Ubuntu / Debian | `sudo apt install openjdk-17-jdk zip apksigner zipalign aapt2` |
| Fedora | `sudo dnf install java-17-openjdk-devel zip apksigner zipalign aapt2` |

#### Compile

```bash
chmod +x build.sh
./build.sh
```

The flashable zip appears in `out/`.

### Module structure

```
src/
  android/res/        Framework RRO (dimens, cutout config)
  systemui/res/       SystemUI RRO (dimens, burn-in config)
module_template/
  module.prop         Module metadata
  service.sh          Boot-time conflict cleanup
  system/product/overlay/   Compiled RRO APKs (populated by build.sh)
```

### CI/CD

Pushing a `v*` tag triggers GitHub Actions, which builds the module and publishes a release with the zip attached.

### License

[GNU General Public License v3.0](LICENSE)

---

<a name="russian"></a>
## Русский

Модуль для Magisk / KernelSU / APatch, исправляющий высоту строки состояния (status bar), отступы панели быстрых настроек (Quick Settings) и экрана блокировки на Redmi Note 14 Pro 4G (obsidian) под управлением LineageOS GSI или других Android 13+ GSI.

### Возможности

- **Два RRO-оверлея** -- независимое изменение ресурсов Android Framework (`android`) и SystemUI (`com.android.systemui`).
- **Notch Killer** -- обнуляет SVG-путь выреза камеры, убирая системные ограничения минимальной высоты. Статусбар и шторка сжимаются до 36 dp.
- **Защита AMOLED от выгорания** -- включает встроенный механизм pixel-shifting в SystemUI (`config_statusBarBurnInProtection`). Иконки (часы, сеть, батарея) незаметно смещаются каждые 60 секунд.
- **Приоритет в портретной ориентации** -- ресурсы в `values-port` переопределяют стандартные GSI-значения в портретном режиме.
- **Автоматическое разрешение конфликтов** -- скрипт `service.sh` отключает конфликтующие оверлеи GSI и сбрасывает runtime-свойства Phh Treble при каждой загрузке.

### Установка

1. Скачайте последний zip-архив из [Releases](https://github.com/moloo4ni/statusbar-fix-obsidian/releases).
2. Установите через Magisk, KernelSU или APatch.
3. Откройте **Phh Treble Settings** -> **Misc features** и сбросьте параметры (значение `-1` или очистить):
   - `Set rounded corners diameter`
   - `Set forced/faked rounded corners diameter`
   - `Set status bar top padding`
   - `Set status bar start padding`
   - `Set status bar end padding`
4. Перезагрузите устройство.

### Сборка из исходников

`build.sh` автоматически определяет Android SDK через `$ANDROID_HOME`, `$ANDROID_SDK_ROOT` или использует `/opt/android-sdk` по умолчанию. Можно явно указать путь:

```bash
SDK_DIR=~/Android/Sdk ./build.sh
```

Версия модуля читается из `module_template/module.prop` -- имя zip-архива всегда соответствует версии.

#### Зависимости

| Дистрибутив | Команда |
|-------------|---------|
| Arch Linux | `sudo pacman -S jdk-openjdk zip android-tools`<br>`yay -S android-sdk android-sdk-build-tools android-platform` |
| Ubuntu / Debian | `sudo apt install openjdk-17-jdk zip apksigner zipalign aapt2` |
| Fedora | `sudo dnf install java-17-openjdk-devel zip apksigner zipalign aapt2` |

#### Компиляция

```bash
chmod +x build.sh
./build.sh
```

Готовый zip-файл появится в папке `out/`.

### Структура модуля

```
src/
  android/res/        RRO для фреймворка (dimens, конфиг выреза)
  systemui/res/       RRO для SystemUI (dimens, защита экрана)
module_template/
  module.prop         Метаданные модуля
  service.sh          Сброс конфликтов при загрузке
  system/product/overlay/   Скомпилированные RRO-APK (создаются build.sh)
```

### CI/CD

При пуше тега вида `v*` GitHub Actions автоматически собирает модуль и публикует релиз с zip-архивом.

### Лицензия

[GNU General Public License v3.0](LICENSE)
