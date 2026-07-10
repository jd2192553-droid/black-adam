# Aegis Android App - Quick Start

## 🚀 One-Minute Setup

### Prerequisites
- Android Studio (Flamingo or later)
- Android SDK 34
- JDK 11+

### Quick Start

```bash
# 1. Clone & navigate
git clone https://github.com/jd2192553-droid/black-adam.git
cd black-adam/android

# 2. Open in Android Studio
# File → Open → Select this android/ folder

# 3. Wait for Gradle sync

# 4. Run
# Click green Play button (Shift+F10)
```

### Configure Backend

Edit `app/src/main/java/com/aegis/pentest/data/api/RetrofitClient.kt`:

```kotlin
private const val BASE_URL = "http://10.0.2.2:8000"  // Emulator
// OR
private const val BASE_URL = "http://192.168.1.X:8000"  // Physical device
```

### Start Backend

```bash
cd ../api
pip install -r requirements.txt
python api.py
```

## 📚 Full Documentation

- **[README.md](README.md)** - Complete project overview
- **[SETUP.md](SETUP.md)** - Detailed setup instructions
- **[DEVELOPMENT.md](DEVELOPMENT.md)** - Architecture & development guide
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - How to contribute

## 🎯 Key Features

- ⚡ Real-time audit execution
- 🔍 Port discovery & service detection
- 🛡️ Vulnerability analysis with remediation
- 📊 Visual metrics dashboard
- 🎨 Dark glassmorphic UI (Compose + Material 3)

## 🏗️ Architecture

```
Composable UI
    ↓
ViewModel (State Management)
    ↓
Repository (Business Logic)
    ↓
Retrofit API Service
    ↓
Flask Backend
```

## 🛠️ Build Commands

```bash
# Debug build
./gradlew assembleDebug

# Release build
./gradlew assembleRelease

# Run tests
./gradlew test

# Clean
./gradlew clean
```

## 🐛 Troubleshooting

**Can't connect to backend?**
- Check BASE_URL in RetrofitClient.kt
- Ensure backend is running: `python api.py`
- Verify firewall allows connections

**Gradle sync fails?**
```bash
./gradlew clean
# Then rebuild in Android Studio
```

**Device not recognized?**
```bash
# Windows:
adb kill-server && adb start-server

# macOS/Linux:
sudo adb kill-server && adb start-server
```

## 📱 Screenshots

### Scan Screen
- Target input field
- Real-time console output
- Port discovery table
- Vulnerability findings with severity badges

### Results Tabs
1. **Live Console** - Streaming audit logs
2. **Services & Ports** - Discovered services
3. **Findings** - Vulnerabilities with remediation

## 🔗 Links

- [Android Developers](https://developer.android.com/)
- [Jetpack Compose Docs](https://developer.android.com/compose)
- [Retrofit Documentation](https://square.github.io/retrofit/)
- [Material Design 3](https://m3.material.io/)

## 📝 License

MIT License

## 👤 Author

jd2192553-droid

---

**Have questions?** Check the full documentation in the README files or open an issue on GitHub.
