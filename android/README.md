# Aegis Android App

Android port of the Aegis Security Audit Dashboard. A powerful mobile application for conducting automated security audits, port scanning, and vulnerability analysis.

## Features

- 🎯 **Target Configuration**: Enter IP addresses or hostnames for security scanning
- 📊 **Live Console**: Real-time streaming audit output
- 🔌 **Port Discovery**: View discovered services and open ports
- 🛡️ **Vulnerability Analysis**: Detailed findings with severity levels (Critical/High/Medium/Low)
- 💡 **Remediation Guidance**: Security recommendations for each finding
- 📈 **Audit Metrics**: Visual summary of discovered issues

## Project Structure

```
android/
├── app/
│   ├── src/
│   │   └── main/
│   │       ├── java/com/aegis/pentest/
│   │       │   ├── MainActivity.kt                    # App entry point
│   │       │   ├── data/
│   │       │   │   ├── api/
│   │       │   │   │   ├── AegisApiService.kt        # Retrofit API interface
│   │       │   │   │   └── RetrofitClient.kt         # HTTP client configuration
│   │       │   │   ├── models/
│   │       │   │   │   └── AuditModels.kt            # Data classes
│   │       │   │   └── repository/
│   │       │   │       └── AuditRepository.kt        # Repository pattern
│   │       │   └── ui/
│   │       │       ├── screens/
│   │       │       │   ├── MainScreen.kt             # Main container
│   │       │       │   ├── ScanScreen.kt             # Scan execution
│   │       │       │   ├── ReportsScreen.kt          # Reports (future)
│   │       │       │   └── SettingsScreen.kt         # Settings (future)
│   │       │       ├── components/
│   │       │       │   ├── NavigationRail.kt         # Side navigation
│   │       │       │   ├── ConfigCard.kt             # Target configuration
│   │       │       │   ├── MetricsCard.kt            # Summary metrics
│   │       │       │   └── ResultsCard.kt            # Results tabs
│   │       │       ├── theme/
│   │       │       │   ├── Theme.kt                  # Material theme
│   │       │       │   ├── Color.kt                  # Color definitions
│   │       │       │   └── Type.kt                   # Typography
│   │       │       └── viewmodel/
│   │       │           └── AuditViewModel.kt         # State management
│   │       ├── res/
│   │       └── AndroidManifest.xml
│   ├── build.gradle                                  # App-level build config
│   └── proguard-rules.pro                            # Obfuscation rules
├── build.gradle                                      # Project-level build config
├── settings.gradle                                   # Gradle settings
└── gradle.properties                                 # Gradle properties
```

## Tech Stack

- **Language**: Kotlin
- **UI Framework**: Jetpack Compose (Material Design 3)
- **Architecture**: MVVM + Repository Pattern
- **Networking**: Retrofit + OkHttp
- **JSON**: Gson
- **Concurrency**: Coroutines + Flow
- **API Target**: Python Flask backend (localhost:8000)

## Setup & Installation

### Prerequisites

- Android Studio Flamingo or later
- Android SDK 34 (target)
- Android SDK 24+ (minimum)
- JDK 11+

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/jd2192553-droid/black-adam.git
   cd black-adam/android
   ```

2. **Open in Android Studio**
   - File → Open → Select `android/` folder

3. **Configure API Endpoint**
   - Edit `app/src/main/java/com/aegis/pentest/data/api/RetrofitClient.kt`
   - Update `BASE_URL` if your backend is not on `localhost:8000`

4. **Build & Run**
   ```bash
   ./gradlew build
   ./gradlew installDebug
   ```
   Or use Android Studio's Run button (Shift + F10)

## API Connection

The app connects to the Flask backend at `http://localhost:8000`.

### Running Backend Locally

```bash
cd ../api
pip install -r requirements.txt
python api.py
```

### On Android Emulator

To connect to a backend running on your development machine:

```kotlin
// In RetrofitClient.kt
private const val BASE_URL = "http://10.0.2.2:8000"  // Maps to host machine
```

## Usage

1. **Enter Target**
   - Navigate to Scan tab
   - Enter IP address or hostname (e.g., `192.168.1.1`, `example.com`)

2. **Start Audit**
   - Click "Start Security Audit" button
   - Monitor progress in Live Console tab

3. **View Results**
   - **Live Console**: Real-time audit logs
   - **Services & Ports**: Discovered open ports and services
   - **Findings**: Security vulnerabilities with remediation guidance

## Architecture

### Data Flow

```
UI (Composable)
    ↓
ViewModel (AuditViewModel)
    ↓
Repository (AuditRepository)
    ↓
API Service (AegisApiService)
    ↓
Backend (Flask API)
```

### State Management

- **UiState**: Tracks audit status (Idle, Running, Success, Error)
- **ConsoleLogs**: Streaming console output
- **AuditReport**: Parsed audit results

## Building

### Debug Build
```bash
./gradlew assembleDebug
```

### Release Build
```bash
./gradlew assembleRelease
```

Generated APK: `app/build/outputs/apk/`

## Testing

```bash
# Unit tests
./gradlew test

# Instrumented tests (on device/emulator)
./gradlew connectedAndroidTest
```

## Future Enhancements

- [ ] Reports screen with historical audit data
- [ ] Settings screen for API configuration
- [ ] Workflow YAML file upload support
- [ ] Export audit reports (PDF/JSON)
- [ ] Authentication/authorization
- [ ] Offline capability
- [ ] Dark/Light theme toggle
- [ ] Multi-language support

## Permissions

- `INTERNET`: Network communication with API
- `READ_EXTERNAL_STORAGE`: Upload workflow files
- `WRITE_EXTERNAL_STORAGE`: Export reports

## Troubleshooting

### Connection Failed
- Ensure backend is running: `python api.py`
- Check API URL in `RetrofitClient.kt`
- On emulator, use `10.0.2.2` instead of `localhost`

### Build Errors
- Clean: `./gradlew clean`
- Rebuild: `./gradlew build`
- Invalidate caches: Android Studio → File → Invalidate Caches

### No Results Displayed
- Check Logcat for errors
- Verify JSON response format matches models
- Ensure backend returns `REPORT_JSON:` line

## Contributing

Pull requests welcome! Please ensure:
- Code follows Kotlin style guidelines
- Tests pass
- New features have documentation

## License

MIT License

## Author

jd2192553-droid
