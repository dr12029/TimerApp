# Timer App - Quick Reference

## Project Structure Overview

```
TimerApp/
│
├── lib/
│   ├── main.dart                    # App entry & theming
│   ├── models/
│   │   └── timer_alert.dart         # Alert data structure
│   ├── providers/
│   │   └── timer_provider.dart      # Timer logic & state
│   ├── screens/
│   │   ├── timer_screen.dart        # Main UI
│   │   └── settings_screen.dart     # Settings page
│   └── widgets/
│       ├── circular_timer.dart      # Animated circle
│       ├── time_picker.dart         # Time input
│       └── alerts_list.dart         # Alert management
│
├── android/                         # Android config
├── assets/sounds/                   # Audio files
└── pubspec.yaml                     # Dependencies

```

## Key Files to Customize

### Colors & Theme
**File:** `lib/main.dart`
```dart
// Line 31 & 47: Change primary color
seedColor: Colors.blue,  // Change to any color
```

### Timer Settings
**File:** `lib/providers/timer_provider.dart`
```dart
// Line 14: Default timer duration
Duration _totalDuration = const Duration(minutes: 10);

// Line 153: Vibration pattern
pattern: [0, 500, 200, 500],  // Customize vibration
```

### UI Text
**File:** `lib/screens/timer_screen.dart`
```dart
// Line 21: App title
'Timer',  // Change app name here
```

## Common Customizations

### Change Default Timer Duration
Edit `lib/providers/timer_provider.dart`:
```dart
Duration _totalDuration = const Duration(minutes: 5);  // 5 minutes
```

### Adjust Alert Sound Volume
The app uses the device's media volume. Control via device volume buttons.

### Modify Vibration Intensity
Edit `lib/providers/timer_provider.dart` line 153:
```dart
pattern: [0, 300, 100, 300],  // Shorter vibration
intensities: [0, 128, 0, 128],  // Lower intensity (0-255)
```

### Change Flash Duration
Edit `lib/providers/timer_provider.dart` line 169:
```dart
Timer(const Duration(milliseconds: 500), () {  // Longer flash
```

### Modify Progress Circle Size
Edit `lib/screens/timer_screen.dart` line 53:
```dart
width: 320,   // Larger circle
height: 320,
```

### Add More Theme Colors
Edit `lib/main.dart` and add color variants:
```dart
ColorScheme.fromSeed(
  seedColor: Colors.blue,
  primary: Colors.blueAccent,    // Add custom colors
  secondary: Colors.orange,
),
```

## Testing Checklist

- [ ] Install Flutter SDK
- [ ] Run `flutter doctor` (all checks green)
- [ ] Run `flutter pub get`
- [ ] Connect Android device or start emulator
- [ ] Run `flutter run`
- [ ] Test timer countdown
- [ ] Test adding/removing alerts
- [ ] Test alert triggers (vibration, flash)
- [ ] Test pause/resume
- [ ] Test theme toggle
- [ ] Test sound toggle in settings
- [ ] Test app in background (notification)
- [ ] Test keep screen on feature
- [ ] Build release APK

## Performance Tips

### Reduce APK Size
Already configured in `android/app/build.gradle`:
```gradle
minifyEnabled true
shrinkResources true
```

### Optimize Images (if added)
Use WebP format for smaller size:
```bash
flutter pub run flutter_launcher_icons:main
```

### Battery Optimization
Timer uses minimal resources:
- 1-second tick interval
- Wake lock only when app is open
- Background service uses foreground service pattern

## Debugging

### View Logs
```bash
flutter run --verbose
```

### Hot Reload (during development)
Press `r` in terminal while app is running

### Restart App
Press `R` in terminal

### Check for Errors
```bash
flutter analyze
```

### Clear Build Cache
```bash
flutter clean
flutter pub get
```

## Building & Distribution

### Debug APK (for testing)
```bash
flutter build apk --debug
```
Location: `build\app\outputs\flutter-apk\app-debug.apk`

### Release APK (for sharing)
```bash
flutter build apk --release
```
Location: `build\app\outputs\flutter-apk\app-release.apk`

### App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Location: `build\app\outputs\bundle\release\app-release.aab`

### Signing APK (optional)
See: https://docs.flutter.dev/deployment/android#signing-the-app

## Feature Status

| Feature | Status | File Location |
|---------|--------|---------------|
| Countdown Timer | ✅ Done | timer_provider.dart |
| Multiple Alerts | ✅ Done | alerts_list.dart |
| Vibration | ✅ Done | timer_provider.dart:153 |
| Sound Alerts | ⚠️ Needs MP3 | timer_provider.dart:158 |
| Dark/Light Mode | ✅ Done | main.dart |
| Keep Screen On | ✅ Done | timer_provider.dart:88 |
| Flash Effect | ✅ Done | timer_screen.dart:118 |
| Settings Persistence | ✅ Done | timer_provider.dart:46 |
| Animations | ✅ Done | circular_timer.dart |

⚠️ = Requires alert.mp3 file in assets/sounds/

## Permissions Explained

```xml
VIBRATE              → Haptic feedback for alerts
FOREGROUND_SERVICE   → Keep timer running when minimized
WAKE_LOCK           → Prevent screen sleep during timer
POST_NOTIFICATIONS  → Show notification (Android 13+)
```

All permissions are justified and minimal!

## Package Versions

Check `pubspec.yaml` for current versions:
- provider: State management
- flutter_background_service: Background timer
- flutter_local_notifications: Notifications
- vibration: Haptic feedback
- audioplayers: Sound playback
- wakelock_plus: Keep screen on
- shared_preferences: Settings storage

## Resources

- **Flutter Docs:** https://docs.flutter.dev/
- **Material Design 3:** https://m3.material.io/
- **Provider Package:** https://pub.dev/packages/provider
- **Free Alert Sounds:** https://pixabay.com/sound-effects/

---

**Need help?** Check SETUP.md or README.md for detailed guides!
