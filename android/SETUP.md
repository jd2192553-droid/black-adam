# Android Setup Guide

## Prerequisites

### System Requirements
- Windows, macOS, or Linux
- 8GB+ RAM recommended
- 20GB+ free disk space

### Software
- Android Studio 2023.1.1 (Flamingo) or later
- Android SDK 34
- Android SDK Platform-Tools 34.0+
- JDK 11 or later (included with Android Studio)

## Installation Steps

### 1. Download Android Studio

https://developer.android.com/studio

### 2. Install Android SDK

1. Open Android Studio
2. SDK Manager → SDK Platforms
3. Install:
   - Android 14 (API 34)
   - Android 5.0 (API 24) - minimum
4. SDK Tools tab:
   - Android SDK Build-Tools 34
   - Android SDK Platform-Tools
   - Android Emulator

### 3. Clone Repository

```bash
git clone https://github.com/jd2192553-droid/black-adam.git
cd black-adam/android
```

### 4. Open in Android Studio

1. Android Studio → Open
2. Select `black-adam/android` folder
3. Wait for Gradle sync to complete

### 5. Configure Backend Connection

**For Local Development (on Physical Device)**

Edit `app/src/main/java/com/aegis/pentest/data/api/RetrofitClient.kt`:

```kotlin
private const val BASE_URL = "http://192.168.1.X:8000"  // Your PC's IP
```

**For Emulator**

```kotlin
private const val BASE_URL = "http://10.0.2.2:8000"  // Host machine
```

### 6. Start Backend

```bash
cd ../api
pip install -r requirements.txt
python api.py
```

Should output:
```
 * Running on http://0.0.0.0:8000
```

### 7. Build & Run App

**Option A: Physical Device**

1. Enable Developer Mode
   - Settings → About → Tap Build Number 7 times
   - Settings → Developer Options → Enable USB Debugging
2. Connect via USB
3. Android Studio → Run (Shift + F10)

**Option B: Emulator**

1. Android Studio → Device Manager → Create Virtual Device
2. Select Pixel 7 (or similar)
3. Android 14 (API 34)
4. Finish
5. Android Studio → Run (Shift + F10)

## Gradle Commands

```bash
# Build APK
./gradlew assembleDebug

# Install on device
./gradlew installDebug

# Run tests
./gradlew test

# Clean build
./gradlew clean build

# Check dependencies
./gradlew dependencies
```

## Troubleshooting

### Issue: "Gradle sync failed"

**Solution:**
```bash
./gradlew clean
# Then: Build → Rebuild Project in Android Studio
```

### Issue: "Cannot connect to backend"

1. Verify backend is running: `curl http://localhost:8000`
2. Check correct BASE_URL in RetrofitClient.kt
3. For emulator: use `10.0.2.2` not `localhost`
4. Check firewall settings

### Issue: "Build fails - dependency not found"

```bash
./gradlew --refresh-dependencies build
```

### Issue: "Emulator won't start"

1. Ensure at least 4GB RAM allocated to emulator
2. Enable Hardware Acceleration if available
3. Update Android Emulator in SDK Manager

### Issue: "Device not recognized"

**Windows:**
```bash
adb kill-server
adb start-server
```

**macOS/Linux:**
```bash
sudo adb kill-server
adb start-server
```

## Project Structure Reference

```
android/
├── app/
│   ├── src/main/
│   │   ├── java/com/aegis/pentest/
│   │   │   ├── MainActivity.kt
│   │   │   ├── data/
│   │   │   │   ├── api/
│   │   │   │   ├── models/
│   │   │   │   └── repository/
│   │   │   └── ui/
│   │   │       ├── screens/
│   │   │       ├── components/
│   │   │       ├── theme/
│   │   │       └── viewmodel/
│   │   └── res/
│   │       ├── values/strings.xml
│   │       ├── values/colors.xml
│   │       └── values/themes.xml
│   ├── build.gradle
│   └── proguard-rules.pro
├── build.gradle
├── settings.gradle
└── gradle.properties
```

## Next Steps

1. Read the main [README.md](README.md)
2. Check [API Integration Guide](../api/README.md)
3. Review Jetpack Compose documentation: https://developer.android.com/compose
4. Start developing!
