# Build, Test & Deploy Guide

## Overview

This guide covers building, testing, and deploying the Aegis Android app.

## Quick Commands

### Build
```bash
./build.sh          # Complete build pipeline
./gradlew build     # Standard Gradle build
./gradlew assembleDebug
./gradlew assembleRelease
```

### Test
```bash
./test.sh                      # Complete test pipeline
./gradlew test                 # Unit tests only
./gradlew connectedAndroidTest # Instrumented tests (requires device)
./gradlew lint                 # Code quality checks
```

### Deploy
```bash
./deploy.sh        # Interactive deployment menu
adb install -r app/build/outputs/apk/debug/app-debug.apk
adb shell am start -n com.aegis.pentest/.MainActivity
```

---

## Build Pipeline

### Step 1: Clean
```bash
./gradlew clean
```
Removes all build artifacts.

### Step 2: Unit Tests
```bash
./gradlew test
```
Runs unit tests in `src/test/`:
- `AuditModelsTest.kt` - Data model tests
- `AuditRequestTest.kt` - Request model tests

### Step 3: Debug Build
```bash
./gradlew assembleDebug
```
Builds debug APK: `app/build/outputs/apk/debug/app-debug.apk`

### Step 4: Release Build
```bash
./gradlew assembleRelease
```
Builds unsigned release APK: `app/build/outputs/apk/release/app-release-unsigned.apk`

### Full Build Script
```bash
bash build.sh
```
Runs all steps and generates reports.

---

## Testing

### Unit Tests
```bash
./gradlew test
```

Test files location:
```
app/src/test/java/com/aegis/pentest/
├── AuditModelsTest.kt
└── AuditRequestTest.kt
```

Running specific test:
```bash
./gradlew test --tests com.aegis.pentest.AuditModelsTest
```

### Instrumented Tests
Requires device or emulator:
```bash
# Start emulator first, then:
./gradlew connectedAndroidTest
```

Instrumented test files:
```
app/src/androidTest/java/com/aegis/pentest/
└── ExampleInstrumentedTest.kt
```

### Lint Checks
```bash
./gradlew lint
```
Report: `app/build/reports/lint-results-debug.html`

### Complete Test Suite
```bash
bash test.sh
```

---

## Deployment

### To Physical Device

1. **Enable USB Debugging**
   - Settings → Developer Options → Enable USB Debugging
   - Connect via USB

2. **Install APK**
   ```bash
   adb install -r app/build/outputs/apk/debug/app-debug.apk
   ```

3. **Launch App**
   ```bash
   adb shell am start -n com.aegis.pentest/.MainActivity
   ```

### To Android Emulator

1. **Start Emulator**
   - Android Studio → Device Manager → Launch virtual device

2. **Install APK**
   ```bash
   adb install -r app/build/outputs/apk/debug/app-debug.apk
   ```

3. **Launch App**
   ```bash
   adb shell am start -n com.aegis.pentest/.MainActivity
   ```

### Interactive Deployment
```bash
bash deploy.sh
```
Menu options:
1. Install to physical device
2. Install to emulator
3. Generate Play Store release
4. Generate distribution APK

### To Google Play Store

1. **Sign Release APK**
   ```bash
   jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \
     -keystore keystore.jks \
     app/build/outputs/apk/release/app-release-unsigned.apk key-alias
   ```

2. **Align APK**
   ```bash
   zipalign -v 4 app-release-unsigned.apk app-release.apk
   ```

3. **Upload to Google Play Console**
   - Create release
   - Upload APK
   - Configure store listing
   - Submit for review

### Build App Bundle (Recommended for Play Store)
```bash
./gradlew bundleRelease
```
Bundle location: `app/build/outputs/bundle/release/app-release.aab`

---

## CI/CD Integration

### GitHub Actions

Create `.github/workflows/android.yml`:

```yaml
name: Android Build & Test

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up JDK 11
        uses: actions/setup-java@v3
        with:
          java-version: '11'
      
      - name: Build
        run: cd android && ./gradlew build
      
      - name: Test
        run: cd android && ./gradlew test
      
      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: apk
          path: android/app/build/outputs/apk/
```

---

## Build Troubleshooting

### "Gradle sync failed"
```bash
./gradlew clean
./gradlew build --refresh-dependencies
```

### "Cannot find Android SDK"
- Set ANDROID_HOME environment variable
- Create `local.properties` with SDK path

### "Build takes too long"
```bash
# Enable parallel builds
echo "org.gradle.parallel=true" >> gradle.properties
echo "org.gradle.caching=true" >> gradle.properties
```

### "Out of memory during build"
```bash
echo "org.gradle.jvmargs=-Xmx4096m" >> gradle.properties
```

### "APK installation fails"
```bash
# Uninstall previous version
adb uninstall com.aegis.pentest

# Install debug APK
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

---

## Performance Optimization

### Faster Builds
```gradle
// app/build.gradle
android {
    packagingOptions {
        exclude 'META-INF/proguard/androidx-*.pro'
    }
}
```

### ProGuard/R8 Optimization (Release)
```gradle
buildTypes {
    release {
        minifyEnabled true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

---

## Monitoring Builds

### Build Scan
```bash
./gradlew build --scan
```

### Verbose Output
```bash
./gradlew build --debug
```

### Dependency Tree
```bash
./gradlew dependencies
```

---

## Next Steps

1. Run `./build.sh` to build the app
2. Run `./test.sh` to test it
3. Run `./deploy.sh` to deploy it
4. Monitor app in Logcat for debugging
5. Submit to Play Store for production release

---

## Resources

- [Android Build System](https://developer.android.com/build)
- [Gradle Documentation](https://gradle.org/)
- [Google Play Console](https://play.google.com/console)
- [App Signing](https://developer.android.com/studio/publish/app-signing)
