# Use official Flutter Docker image
FROM cirrusci/flutter:3.16.0

# Set working directory
WORKDIR /app

# Copy project files
COPY pubspec.* ./
COPY . .

# Get dependencies
RUN flutter pub get

# Build release APK
RUN flutter build apk --release

# The APK will be at: build/app/outputs/flutter-apk/app-release.apk
CMD ["echo", "Build complete! APK is in build/app/outputs/flutter-apk/app-release.apk"]
