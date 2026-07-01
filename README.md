# FieldTrack To-Do

FieldTrack is a modern Flutter-based mobile application designed for field tracking, task management, offline synchronization, and geofence-based notification alerts. The application ensures workers can view tasks, sync their status changes even when offline, and get notified immediately when entering specific active zones.

---

##  Demo & Download

*    **Demo Video:** [Watch the Demo Video](https://drive.google.com/file/d/1A062zhDondzwmW9_bBL6wGu6sWd7fQHu/view?usp=sharing)
*    **APK Download:** [Download Android APK](https://drive.google.com/file/d/100KcFCFCufET1Hv8wuXYlWREHPQbTRv-/view?usp=sharing)

---

##  Project Setup Steps

To set up the project on your local machine, follow these steps:

### Prerequisites
*   **Flutter SDK**: `^3.12.2` (Make sure your flutter path is configured in your system environment)
*   **Dart SDK**: Matches the Flutter SDK requirements.
*   **Android Studio / VS Code**: Installed with Dart and Flutter plugins.
*   **Physical Device / Emulator**: Location permissions and services must be enabled for geofencing to work.

### Installation

1.  **Clone the Repository**:
    ```bash
    git clone <repository_url>
    cd field_track_todo
    ```

2.  **Fetch Dependencies**:
    Download the required package packages defined in the [pubspec.yaml](field_track_todo/pubspec.yaml):
    ```bash
    flutter pub get
    ```

3.  **Setup Platform-Specific Configurations**:

    #### Android Configurations
    Make sure permissions and services are declared in [AndroidManifest.xml](field_track_todo/android/app/src/main/AndroidManifest.xml):
    *   **Permissions**:
        *   `ACCESS_FINE_LOCATION` & `ACCESS_COARSE_LOCATION` for retrieving high-accuracy location tracking.
        *   `ACCESS_BACKGROUND_LOCATION` to enable location monitoring when the app is in the background.
        *   `FOREGROUND_SERVICE` & `FOREGROUND_SERVICE_LOCATION` to keep location streams active in the foreground service (required on newer Android versions).
        *   `POST_NOTIFICATIONS` to post local alerts to the user interface.
    *   **Foreground Service Declaration**:
        The Geolocator foreground service is registered under the `<application>` tag:
        ```xml
        <service
            android:name="com.baseflow.geolocator.GeolocatorForegroundService"
            android:enabled="true"
            android:exported="false"
            android:foregroundServiceType="location" />
        ```

    #### iOS Configurations
    Verify the following keys in [Info.plist](field_track_todo/ios/Runner/Info.plist):
    *   `NSLocationWhenInUseUsageDescription`: Displays prompt when location is accessed in-app.
    *   `NSLocationAlwaysAndWhenInUseUsageDescription`: Displays prompt for background location tracking.
    *   `NSLocationAlwaysUsageDescription`: Displays prompt for legacy background location configurations.
    *   `UIBackgroundModes`: Configured with `<string>location</string>` to support background location updates.

---

##  How to Run the App

1.  Connect your physical device or start your simulator/emulator.
2.  Check if device is recognized:
    ```bash
    flutter devices
    ```
3.  **Run in Debug Mode**:
    ```bash
    flutter run
    ```
4.  **Build Release APK (Android)**:
    ```bash
    flutter build apk --release
    ```
5.  **Build Release IPA (iOS)**:
    ```bash
    flutter build ipa
    ```

---

##  Environment and Configuration Notes

*   **API Base URL**: Configured globally in [endpoints.dart](field_track_todo/lib/core/endpoints/endpoints.dart).
    ```dart
    static const String baseUrl = 'https://todo.progressivebyte.com';
    ```
*   **Authentication Storage**: Uses `shared_preferences` via [shared_preference_helper.dart](field_track_todo/lib/core/services/shared_preference_helper.dart) to persist JWT token pairs (`accessToken` and `refreshToken`). These are automatically attached to HTTP headers in outbound requests.
*   **State Management**: Built entirely on **Flutter Riverpod** (`flutter_riverpod` package) for state management and dependency injection, alongside standard Flutter Navigator for routing and standard controllers.

---

##  Folder Structure Overview

The project uses a structured, feature-first architecture layout:

```text
lib/
├── app.dart                   # Root widget configuring MaterialApp, theme, and router
├── main.dart                  # App entry point, initializes Riverpod ProviderContainer
├── core/                      # Global/shared utilities and configurations
│   ├── common/                # Common structures and resources
│   ├── endpoints/             # API endpoint configuration (endpoints.dart)
│   ├── services/              # Core background services:
│   │   ├── geofence_service.dart      # Geolocator stream & boundary comparison logic
│   │   ├── notification_service.dart  # Flutter Local Notification triggers
│   │   └── shared_preference_helper.dart # Token store utilities
│   ├── theme/                 # App styling & theme tokens (app_theme.dart)
│   └── widgets/               # Reusable UI widgets
├── features/                  # App modules containing presentation and logic
│   ├── auth/                  # Register, Login, Token handling logic
│   ├── create_location/       # Screen and logic to create geofenced boundaries
│   ├── edit_location/         # Configuration screens for modifying existing geofences
│   ├── location/              # Geofence location listings (LocationsController)
│   ├── nav_bar/               # Bottom navigation management
│   ├── profile/               # User details and account management
│   ├── splash/                # Initial launching visual loader
│   ├── sync/                  # Offline sync status tracking and queue
│   └── tasks/                 # Task checklist and progressive summary graphs
└── routes/                    # Routing maps and route definitions (app_routes.dart)
```

Within each feature module, files are organized as follows:
*   `controller/` - Controllers (ChangeNotifiers) managing the business logic and state, exposed via Riverpod providers.
*   `model/` - Serializers/Deserializers to convert remote payloads.
*   `screen/` - Full visual UI layouts (ConsumerWidgets/ConsumerStatefulWidgets).
*   `service/` - API services extending `BaseService` for network calls.
*   `widgets/` - Local specific widgets.

---

##  Offline Synchronization Approach

The offline synchronization is powered by the [SyncController](file:///f:/Flutter/field_track_todo/lib/features/sync/controller/sync_controller.dart):

1.  **Network State Detection**:
    Uses the `connectivity_plus` package to listen to live internet modifications. Changes are observed via a stream listener in `_initConnectivityListener()`.
2.  **Queue Modification**:
    *   If the user toggles a task's status while offline, the local UI updates immediately.
    *   The change details (`todoId`, `title`, `isCompleted`, `updatedAt`) are appended to `pendingChanges` list.
    *   If a task already has a pending change in the list, it gets updated to reflect the latest status, avoiding redundant requests.
3.  **Persistence**:
    The pending change list is converted to a JSON payload and written to `SharedPreferences` (`pending_todo_sync_changes` key) to prevent data loss on app restart.
4.  **Auto-Synchronization**:
    *   When the connectivity stream reports that the device is back online, it automatically calls `syncNow()`.
    *   It wraps the payload and issues a batch `POST` request to the `/api/v1/todos/sync` endpoint using [SyncService](file:///f:/Flutter/field_track_todo/lib/features/sync/service/sync_service.dart).
5.  **Reconciliation**:
    *   Upon receiving an `HTTP 200 OK`, the response body yields a list of `synced_ids` and a `failed` list.
    *   Successfully processed IDs are removed from the local database.
    *   Failed items are logged, removed from the queue to prevent persistent lockups, and an error description lists them to the user via `EasyLoading`.
    *   The task lists are re-fetched from the server to guarantee consistency.

---

##  Geofencing & Notifications Approach

Geofencing is managed via a combination of the [GeofenceService](field_track_todo/lib/core/services/geofence_service.dart) and the [NotificationService](field_track_todo/lib/core/services/notification_service.dart):

1.  **Position Stream**:
    The app initializes a high-accuracy, low-latency location stream through `Geolocator.getPositionStream`. It's configured with a `distanceFilter: 5` (meters limit) and `intervalDuration: const Duration(seconds: 5)`.
2.  **Foreground Mode**:
    On Android, the stream runs with an `AndroidSettings.foregroundNotificationConfig` configuration, turning the stream session into a sticky foreground notification to ensure Android does not throttle location requests in the background.
3.  **Boundary Evaluation**:
    On each location update, the service:
    *   Retrieves all active geofenced circles from `LocationsController`.
    *   Computes the distance in meters between the device coordinates and each target using `Geolocator.distanceBetween()`.
    *   Determines if the distance is within the location's `radiusM` value.
4.  **Notification Trigger**:
    *   To avoid spamming alerts on every location stream tick, the service records active entries in a `_enteredLocationIds` Set.
    *   If the user enters a boundary not already in the set, the app adds it and sends a native notification using `NotificationService.showNotification()`.
    *   Upon exit (distance exceeds radius), the location ID is removed from the tracking set.
5.  **Local Notifications**:
    `NotificationService` configures `FlutterLocalNotificationsPlugin` settings for Darwin (iOS) and Android, defining a dedicated `geofence_channel_id` channel with high priority, sound, and vibration enabled.

---

##  Assumptions and Known Limitations

1.  **Backend API Issue - Inactive Locations**:
    > [!IMPORTANT]
    > There is a known issue with the location fetching API (`GET /api/v1/locations`). It does **not** return locations that are inactive (`is_active: false`). Because of this backend limitation:
    > *   Inactive locations cannot be displayed or reactivated from the location listing in the app.
    > *   The application relies entirely on state variables in memory or localized changes during active sessions to track status toggling for inactive entries.
2.  **Task Progress Scope**:
    Task metrics (e.g., progress bar percentage and completion counts) only calculate tasks completed **today**. This is a design layout selection determined by `_isToday(task.updatedAt)`.
3.  **Battery Performance**:
    Geofencing checks are conducted via active background location polling in a foreground service. This can lead to increased battery usage compared to native hardware-assisted geofencing configurations.
