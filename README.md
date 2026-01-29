# Timer App

A modern Android countdown timer app with multiple alerts and background support.

## Features

- ⏱️ **Countdown Timer** - Set hours, minutes, and seconds
- 🔔 **Multiple Alerts** - Add unlimited alert times (e.g., warn at 5 min, finish at 0)
- 📳 **Vibration & Sound** - Haptic feedback and audio alerts
- 🌓 **Dark & Light Mode** - Modern Material Design 3 UI
- 💫 **Animations** - Smooth transitions and white flash alerts
- 🔋 **Background Running** - Timer continues when app is minimized
- 📱 **Keep Screen On** - Display stays active during countdown
- 🔒 **Privacy First** - No internet, no data collection, minimal permissions

## Setup Instructions

### Prerequisites
- Flutter SDK 3.2.0 or higher
- Android Studio or VS Code with Flutter extensions
- Android device or emulator (API 24+)

### Installation Steps

1. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

2. **Add Alert Sound (Optional):**
   - Download a free alert sound MP3 from [Pixabay](https://pixabay.com/sound-effects/search/alert/) or [Freesound](https://freesound.org/)
   - Save it as `assets/sounds/alert.mp3`
   - The app works without this (vibration only)

3. **Run the app:**
   ```bash
   flutter run
   ```

## Building for Release

```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

## Permissions

- **VIBRATE** - For haptic feedback on alerts
- **FOREGROUND_SERVICE** - To keep timer running in background
- **WAKE_LOCK** - To keep screen on during timer
- **POST_NOTIFICATIONS** - To show notification when app is backgrounded (Android 13+)

## Usage

1. **Set Timer Duration** - Use the time picker to set hours, minutes, seconds
2. **Add Alerts** - Tap the + button to add alert times (e.g., "Alert me at 5:00")
3. **Start Timer** - Press the play button to begin countdown
4. **Minimize App** - Timer continues running with notification showing time
5. **Alerts Trigger** - Device vibrates, plays sound, and flashes white screen

## Technical Stack

- **Framework:** Flutter 3.2+
- **State Management:** Provider
- **Local Storage:** SharedPreferences
- **Audio:** audioplayers
- **Notifications:** flutter_local_notifications
- **Background Service:** flutter_background_service
- **Device Features:** vibration, wakelock_plus

## Project Structure

```
lib/
├── main.dart              # App entry point & theming
├── models/
│   └── timer_alert.dart   # Alert data model
├── providers/
│   └── timer_provider.dart # Timer logic & state management
├── screens/
│   ├── timer_screen.dart  # Main timer UI
│   └── settings_screen.dart # Settings page
├── widgets/
│   ├── circular_timer.dart # Animated circular progress
│   ├── time_picker.dart   # Time input widget
│   └── alerts_list.dart   # Alert management UI
└── services/
    └── background_service.dart # Background timer service (future)
```

## Known Limitations

- Background service implementation is simplified for MVP
- iOS support not fully implemented (iOS has stricter background limitations)
- Sound requires manual MP3 file addition

## License

This project is open source and available for personal and commercial use.
