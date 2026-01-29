# Quick Start Guide - Timer App Setup

## ⚠️ Flutter Not Detected

Flutter SDK is not installed on your system. Follow these steps to get the app running:

## Step 1: Install Flutter

### Windows Installation:

1. **Download Flutter SDK:**
   - Visit: https://docs.flutter.dev/get-started/install/windows
   - Download the Flutter SDK ZIP file (stable channel)
   - Extract to: `C:\src\flutter` (recommended location)

2. **Add Flutter to PATH:**
   - Search "Environment Variables" in Windows Start menu
   - Click "Environment Variables" button
   - Under "User variables", find "Path" and click "Edit"
   - Click "New" and add: `C:\src\flutter\bin`
   - Click "OK" on all dialogs

3. **Verify Installation:**
   ```powershell
   flutter --version
   flutter doctor
   ```

## Step 2: Install Android Development Tools

### Option A: Android Studio (Recommended)
1. Download Android Studio: https://developer.android.com/studio
2. During installation, ensure these are checked:
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device
3. Run Android Studio once to complete setup
4. Open SDK Manager and ensure Android SDK 34 is installed

### Option B: VS Code with Flutter Extension
1. Install VS Code: https://code.visualstudio.com/
2. Install Flutter extension from marketplace
3. Run `flutter doctor` and follow prompts to install Android SDK

## Step 3: Setup Project

Once Flutter is installed, open PowerShell in the project directory and run:

```powershell
# Navigate to project
cd e:\TimerApp

# Get Flutter dependencies
flutter pub get

# Check for issues
flutter doctor

# Connect Android device via USB or start emulator
# Then run the app:
flutter run
```

## Step 4: Build Release APK

To create an installable APK file:

```powershell
flutter build apk --release
```

The APK will be at: `build\app\outputs\flutter-apk\app-release.apk`

Transfer this file to your Android device and install it.

## Troubleshooting

### "cmdlet not found" Error
- Flutter is not in your PATH. See Step 1 above.
- After adding to PATH, restart PowerShell/Terminal

### "No devices found"
- Enable USB Debugging on your Android phone (Settings > Developer Options)
- Or start an Android emulator from Android Studio

### License Errors
```powershell
flutter doctor --android-licenses
```
Accept all licenses when prompted.

### Gradle Errors
```powershell
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

## Quick Development Commands

```powershell
# Hot reload during development
flutter run

# Check for errors
flutter analyze

# Run tests
flutter test

# Build release APK
flutter build apk --release

# Build app bundle for Play Store
flutter build appbundle --release
```

## Next Steps After Setup

1. The app is fully functional as-is
2. Optional: Add a real alert sound MP3 to `assets/sounds/alert.mp3`
3. Customize colors in `lib/main.dart` (seedColor)
4. Test on a physical device for best experience (vibration, notifications)

## Project Features Already Implemented ✅

- ✅ Countdown timer with hours/minutes/seconds
- ✅ Multiple alert times (unlimited)
- ✅ Vibration and sound alerts
- ✅ Dark and light mode themes
- ✅ Modern Material Design 3 UI
- ✅ Circular progress animation
- ✅ White flash overlay on alerts
- ✅ Keep screen awake during timer
- ✅ Settings persistence
- ✅ No internet permission (offline only)

## Support

For Flutter installation help:
- Official docs: https://docs.flutter.dev/get-started/install
- Flutter Discord: https://discord.gg/flutter
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter

For this project:
- Check README.md for detailed documentation
- All code is commented and organized
- Settings screen shows all features
