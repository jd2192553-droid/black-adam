# Development Guide

## Architecture Overview

### MVVM Pattern

```
Composable (UI)
    ↓
ViewModel (State Management)
    ↓
Repository (Business Logic)
    ↓
API Service (Network Calls)
```

### File Organization

```
com.aegis.pentest/
├── MainActivity.kt              # App entry point
├── data/
│   ├── api/
│   │   ├── AegisApiService.kt  # API endpoints
│   │   └── RetrofitClient.kt   # HTTP client setup
│   ├── models/
│   │   └── AuditModels.kt      # Data classes
│   └── repository/
│       └── AuditRepository.kt   # Data access layer
└── ui/
    ├── screens/
    │   ├── MainScreen.kt
    │   ├── ScanScreen.kt
    │   ├── ReportsScreen.kt
    │   └── SettingsScreen.kt
    ├── components/
    │   ├── NavigationRail.kt
    │   ├── ConfigCard.kt
    │   ├── MetricsCard.kt
    │   └── ResultsCard.kt
    ├── theme/
    │   ├── Theme.kt
    │   ├── Color.kt
    │   └── Type.kt
    └── viewmodel/
        └── AuditViewModel.kt
```

## Key Components

### 1. AuditViewModel

Manages audit execution state and results:

```kotlin
class AuditViewModel : ViewModel() {
    // Publishes audit state
    val uiState: StateFlow<AuditUiState>
    
    // Streams console logs
    val consoleLogs: StateFlow<List<String>>
    
    // Holds parsed report
    val auditReport: StateFlow<AuditReport?>
    
    // Triggers audit
    fun runAudit(target: String)
}
```

### 2. AuditRepository

Handles API communication:

```kotlin
class AuditRepository {
    // Returns Flow of audit results
    fun runAudit(target: String): Flow<AuditResult>
}
```

### 3. RetrofitClient

Configures HTTP client:

```kotlin
object RetrofitClient {
    const val BASE_URL = "http://localhost:8000"
    
    val apiService: AegisApiService
        // Configured with logging, timeouts, etc.
}
```

## Data Models

### AuditRequest
```kotlin
data class AuditRequest(
    val target: String
)
```

### AuditReport
```kotlin
data class AuditReport(
    val target: String,
    val ports: List<Port>,
    val findings: List<Finding>,
    val summary: Summary
)
```

### Port
```kotlin
data class Port(
    val port: Int,
    val service: String,
    val version: String,
    val status: String
)
```

### Finding
```kotlin
data class Finding(
    val id: String,
    val severity: String,
    val title: String,
    val description: String,
    val remediation: String
)
```

## Composable Hierarchy

```
MainScreen
├── NavigationRail
├── ScanScreen
│   ├── ConfigCard
│   ├── MetricsCard (conditional)
│   └── ResultsCard
│       ├── ConsoleTab
│       ├── PortsTab
│       │   └── PortItem (repeated)
│       └── FindingsTab
│           └── FindingItem (repeated)
├── ReportsScreen
└── SettingsScreen
```

## State Flow

### Starting an Audit

1. User enters target → triggers `viewModel.runAudit(target)`
2. ViewModel calls `repository.runAudit(target)`
3. Repository emits `Loading` → UI shows loading state
4. API streams response lines:
   - Regular lines → `ConsoleOutput` emitted
   - `REPORT_JSON:` line → parsed to `ReportReceived`
5. UI updates in real-time

### Console Output Handling

```kotlin
// Repository parses streaming response
for (line in lines) {
    if (line.startsWith("REPORT_JSON:")) {
        // Parse JSON report
        emit(AuditResult.ReportReceived(report))
    } else if (line.isNotEmpty()) {
        // Stream log line
        emit(AuditResult.ConsoleOutput(line))
    }
}
```

## UI Development

### Creating a New Screen

1. Create screen file in `ui/screens/`:
```kotlin
@Composable
fun NewScreen() {
    Column(modifier = Modifier.fillMaxSize()) {
        // Screen content
    }
}
```

2. Add navigation in `MainScreen.kt`:
```kotlin
when (selectedTab) {
    0 -> ScanScreen(viewModel)
    1 -> ReportsScreen()
    2 -> SettingsScreen()
    3 -> NewScreen()  // Add here
}
```

### Creating a Component

1. Create component file in `ui/components/`:
```kotlin
@Composable
fun MyComponent(
    param1: String,
    onAction: () -> Unit
) {
    // Component layout
}
```

2. Use in screens or other components

## Networking

### Making API Calls

```kotlin
// In Repository
val response = apiService.runAudit(request)
if (response.isSuccessful) {
    val body = response.body()?.string()
    // Process response
}
```

### Handling Errors

```kotlin
try {
    emit(AuditResult.Loading)
    // Make API call
} catch (e: Exception) {
    emit(AuditResult.Error(e.message ?: "Unknown error"))
}
```

### Timeouts

Configured in `RetrofitClient.kt`:
```kotlin
connectTimeout(30, TimeUnit.SECONDS)
readTimeout(60, TimeUnit.SECONDS)
writeTimeout(60, TimeUnit.SECONDS)
```

## Testing

### Unit Tests

Create in `src/test/java/`:

```kotlin
class AuditViewModelTest {
    @Test
    fun testRunAudit() {
        // Test ViewModel logic
    }
}
```

### Instrumented Tests

Create in `src/androidTest/java/`:

```kotlin
class MainScreenTest {
    @get:Rule
    val composeTestRule = createComposeRule()
    
    @Test
    fun testMainScreen() {
        composeTestRule.setContent {
            MainScreen()
        }
        // Test UI
    }
}
```

## Theme Customization

### Colors

Edit `ui/theme/Color.kt`:

```kotlin
val DarkBg = Color(0xFF070A13)
val AccentGreen = Color(0xFF10B981)
// Add/modify colors
```

### Typography

Edit `ui/theme/Type.kt`:

```kotlin
val Typography = Typography(
    bodyLarge = TextStyle(...),
    // Modify styles
)
```

## Performance Tips

1. **Lazy Loading**: Use `LazyColumn` for long lists
```kotlin
LazyColumn {
    items(findings) { finding ->
        FindingItem(finding)
    }
}
```

2. **Memoization**: Use `remember` to cache values
```kotlin
val total = remember(report) { 
    report.summary.critical + report.summary.high 
}
```

3. **State Optimization**: Only update when necessary
```kotlin
val uiState by viewModel.uiState.collectAsStateWithLifecycle()
```

## Common Tasks

### Add New API Endpoint

1. Add method to `AegisApiService.kt`:
```kotlin
@POST("/new-endpoint")
suspend fun newEndpoint(@Body request: Request): Response<Response>
```

2. Use in `AuditRepository.kt`

### Update Models

1. Edit `AuditModels.kt`
2. Gson will automatically map JSON to data classes

### Change API URL

Edit `RetrofitClient.kt`:
```kotlin
private const val BASE_URL = "http://new-url:port"
```

## Debugging

### Logcat

View logs in Android Studio:
- Logcat tab at bottom
- Filter by app name: `com.aegis.pentest`

### Network Logging

Enable in `RetrofitClient.kt`:
```kotlin
val loggingInterceptor = HttpLoggingInterceptor().apply {
    level = HttpLoggingInterceptor.Level.BODY  // Full request/response
}
```

### Debug Mode

Run in debug:
- Android Studio → Run → Debug 'app' (Shift + F9)
- Set breakpoints by clicking line numbers

## Resources

- [Jetpack Compose Documentation](https://developer.android.com/compose)
- [Kotlin Coroutines](https://kotlinlang.org/docs/coroutines-overview.html)
- [Retrofit Documentation](https://square.github.io/retrofit/)
- [Material Design 3](https://m3.material.io/)
- [Android Developers](https://developer.android.com/)
