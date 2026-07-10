# Android Changelog

## [1.0.0] - 2026-07-10

### Added
- Initial Android application release
- Jetpack Compose UI with Material Design 3
- Real-time audit execution and console output
- Port discovery and service detection
- Vulnerability findings with severity levels
- Remediation recommendations
- Retrofit API client for Flask backend communication
- MVVM architecture with coroutines
- Tab-based results view (Console/Ports/Findings)
- Metrics dashboard with severity breakdown
- Navigation rail with Scan/Reports/Settings tabs
- Dark glassmorphic theme matching web dashboard

### Features
- Live console streaming from backend
- Automatic JSON parsing of audit reports
- Service discovery visualization
- Security findings display with color-coded severity
- Responsive UI for various screen sizes
- Error handling and retry logic

### Technical
- Kotlin + Jetpack Compose
- Android API 24 minimum, API 34 target
- Retrofit + OkHttp for networking
- Coroutines + Flow for async operations
- Gson for JSON serialization

## Roadmap

### v1.1.0
- [ ] Historical audit reports storage
- [ ] Export reports (PDF/JSON/CSV)
- [ ] Workflow YAML file upload
- [ ] Settings screen with API URL configuration
- [ ] Multi-target scanning
- [ ] Scheduled audits

### v1.2.0
- [ ] User authentication
- [ ] Multi-device sync
- [ ] Offline mode with local data
- [ ] Custom audit profiles
- [ ] Vulnerability database integration

### v2.0.0
- [ ] Penetration testing framework integration
- [ ] Custom payload support
- [ ] Advanced filtering and search
- [ ] Network mapping visualization
- [ ] Real-time threat alerts
