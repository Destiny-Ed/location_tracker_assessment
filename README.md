# Flutter Location Tracker

This is a Flutter application assessment that demonstrates foreground and background location tracking using Android foreground services. It includes permission handling, persistent tracking, and local storage of location logs.

---

## Features

### Location Tracking
- Foreground location tracking (manual trigger)
- Background location tracking using a foreground service
- Location updates every 1 minute

### Background Service
- Android foreground service implementation
- Persistent notification showing live location updates
- Continues running when the app is minimized

### State Persistence
- Saves tracking state locally
- Restores tracking state when the app restarts
- Prevents unintended service execution

### Location Logs
- Stores all location updates locally
- Groups logs by:
  - Today
  - Yesterday
  - Specific dates
- Each log includes latitude, longitude, timestamp, and source

### Log Source Tracking
Each location entry is marked as:
- Foreground (manual update from app)
- Background (automatic update from service)

### Permission Handling
Centralized permission system that handles:
- Location permission (foreground and background)
- Notification permission (Android 13+ and iOS)
- Permanently denied permission states

---

## How It Works

### App Launch
- Checks required permissions automatically
- Requests missing permissions
- Blocks access until permissions are granted

### Tracking Flow
- User enables background tracking from the UI
- Foreground service starts immediately
- Persistent notification appears with live location

### Background Execution
- Service runs every 1 minute
- Fetches current GPS location
- Sends updates to the UI through events
- Updates notification with latest coordinates

### Logging System
- Every location update is saved locally
- Logs are grouped by date in the UI
- Each log shows coordinates, timestamp, and source

---

## Platform Limitations

### iOS
- Background tracking is limited when the app is force-killed due to system restrictions

### Android
- Full background tracking support
- Some devices may restrict background services unless battery optimization is disabled

---

## Architecture

- Provider used for state management
- Background service separated from UI logic
- SharedPreferences used for local storage
- Permission logic centralized in a dedicated service layer
- Clean separation between features and core services

---

## Setup Instructions

```bash
flutter pub get
flutter run