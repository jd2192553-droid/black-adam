# Contributing to Aegis Android

Thank you for your interest in contributing! Here's how you can help.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/black-adam.git`
3. Create a feature branch: `git checkout -b feature/your-feature`
4. Set up development environment (see SETUP.md)

## Development Workflow

### Code Style

- Follow [Kotlin style guide](https://kotlinlang.org/docs/coding-conventions.html)
- Use meaningful variable names
- Add comments for complex logic
- Keep functions focused and testable

### Commit Messages

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `style:` Formatting
- `refactor:` Code restructure
- `test:` Tests
- `chore:` Build/dependency updates

**Example:**
```
feat(ui): add dark mode toggle

Implement theme switching in settings screen
with persistent user preference storage.

Closes #42
```

## Pull Request Process

1. Update README.md if needed
2. Add tests for new features
3. Ensure all tests pass: `./gradlew test connectedAndroidTest`
4. Update CHANGELOG.md
5. Request review
6. Address feedback

### PR Title Format

```
[TYPE] Short description

- Bullet point 1
- Bullet point 2
```

**Example:**
```
[FEATURE] Add custom API URL configuration

- Add settings screen with API URL input
- Validate URL format before saving
- Show connection status indicator
- Add unit tests for URL validation
```

## Adding Features

### New Screen

1. Create screen file: `ui/screens/NewScreen.kt`
2. Add to MainScreen navigation
3. Create corresponding ViewModel if needed
4. Add tests

### New API Endpoint

1. Add method to `AegisApiService.kt`
2. Create data models if needed
3. Add to `AuditRepository.kt`
4. Update ViewModel
5. Add UI

### Bug Fixes

1. Identify root cause
2. Write test that reproduces bug
3. Fix implementation
4. Verify test passes
5. Submit PR

## Testing

### Unit Tests

```bash
./gradlew test
```

### UI Tests

```bash
./gradlew connectedAndroidTest
```

### Manual Testing

1. Build debug APK
2. Install on device/emulator
3. Test feature thoroughly
4. Check edge cases

## Documentation

- Update README.md for major features
- Add inline code comments
- Update DEVELOPMENT.md for architecture changes
- Add examples in SETUP.md if applicable

## Reporting Bugs

### Issue Template

```
## Description
Clear description of the bug.

## Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

## Expected Behavior
What should happen.

## Actual Behavior
What actually happened.

## Environment
- Android version: 
- Device: 
- App version: 
- Backend version: 

## Logs
```
Paste relevant logcat output
```
```

## Suggesting Features

### Feature Template

```
## Feature Request
Brief description of the feature.

## Use Case
Why is this feature needed?

## Proposed Solution
How should it work?

## Alternative Solutions
Other approaches considered.

## Additional Context
Any screenshots or examples.
```

## Code Review

Reviewers will check:
- Code quality and style
- Test coverage
- Documentation
- Performance impact
- Security concerns
- Compatibility

## Community Guidelines

- Be respectful and inclusive
- Assume good intent
- Provide constructive feedback
- Help others when possible
- No spam or promotional content

## Questions?

Open an issue or discussion if you have questions about contributing.

Thank you for making Aegis better! 🙏
