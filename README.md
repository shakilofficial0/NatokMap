# NatokMap - Bangladesh Landmarks Application

A futuristic Android application for managing and visualizing landmark records in Bangladesh. Built with Flutter following MVC architecture.

## Features

### 🗺️ Interactive Map View
- OpenStreetMap integration with custom dark theme
- Interactive markers for landmarks
- Centered on Bangladesh (23.6850°N, 90.3563°E)
- Bottom sheet details on marker tap
- Real-time online/offline status indicator

### 📋 List View
- Scrollable card-based landmark list
- Cached network images
- Swipe gestures for edit/delete
- Pull-to-refresh functionality
- Empty state handling

### ➕ Form View
- Add new landmarks with image upload
- Edit existing landmarks
- Auto-detect current GPS location
- Image picker (Gallery/Camera)
- Automatic image resize to 800x600
- Form validation

### 🎨 Design
- **Futuristic Dark Theme**: Navy gradient background with neon accents
- **Glass Card Effect**: Semi-transparent cards with neon borders
- **Neon Glow Buttons**: Cyan and magenta gradient buttons
- **Clean Typography**: Orbitron and Rajdhani fonts
- **Smooth Animations**: Modern transitions and effects

### 💾 Offline Support
- SQLite database for local caching
- Offline-first data strategy
- Automatic sync when online
- Offline mode indicator

## Architecture

### MVC Pattern
```
lib/
├── models/              # Data models
│   ├── landmark.dart
│   └── api_response.dart
├── views/               # UI screens
│   ├── map_view.dart
│   ├── list_view.dart
│   ├── form_view.dart
│   └── landmark_detail_sheet.dart
├── controllers/         # Business logic
│   └── landmark_controller.dart
├── services/            # External services
│   ├── api_service.dart
│   ├── image_service.dart
│   └── location_service.dart
├── repositories/        # Data management
│   └── landmark_repository.dart
├── database/            # Local storage
│   └── database_helper.dart
├── widgets/             # Reusable UI components
│   ├── glass_card.dart
│   ├── neon_button.dart
│   ├── neon_loading.dart
│   └── dialogs.dart
├── theme/               # App styling
│   └── app_theme.dart
└── main.dart           # Entry point
```

## API Endpoints

**Base URL**: `https://labs.anontech.info/cse489/t3/api.php`

### Create Landmark (POST)
```
Parameters:
- title (String)
- lat (Double)
- lon (Double)
- image (File)
```

### Get All Landmarks (GET)
```
Response: JSON array of landmarks
```

### Update Landmark (PUT)
```
Parameters:
- id (Integer)
- title (String)
- lat (Double)
- lon (Double)
- image (File, optional)
```

### Delete Landmark (DELETE)
```
Parameters:
- id (Integer)
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.10.1 or higher)
- Android Studio / VS Code
- Android device or emulator

### Installation

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Run the app**
   ```bash
   flutter run
   ```

## Dependencies

```yaml
dependencies:
  # Map
  flutter_map: ^7.0.2
  latlong2: ^0.9.1
  
  # Networking
  http: ^1.2.0
  dio: ^5.4.0
  
  # Database
  sqflite: ^2.3.0
  path_provider: ^2.1.1
  
  # Image
  image_picker: ^1.0.5
  image: ^4.1.3
  cached_network_image: ^3.3.0
  
  # Location
  geolocator: ^11.0.0
  permission_handler: ^11.1.0
  
  # UI
  google_fonts: ^6.1.0
  shimmer: ^3.0.0
  
  # State Management
  provider: ^6.1.1
```

## Permissions

- `INTERNET` - API communication
- `ACCESS_FINE_LOCATION` - GPS location
- `ACCESS_COARSE_LOCATION` - Network location
- `CAMERA` - Take photos
- `READ_EXTERNAL_STORAGE` - Access gallery
- `WRITE_EXTERNAL_STORAGE` - Save images
- `READ_MEDIA_IMAGES` - Android 13+ image access

## Key Features Implementation

### 1. Bottom Navigation
Three tabs for easy navigation:
- Overview (Map)
- Records (List)
- New Entry (Form)

### 2. Offline Caching
- All landmarks saved to SQLite
- Automatic sync when online
- Offline mode indicator
- Seamless fallback to cached data

### 3. Image Handling
- Pick from gallery or camera
- Automatic resize to 800x600
- JPEG compression (85% quality)
- Local caching

### 4. Location Services
- Auto-detect current location
- GPS coordinate validation
- Manual coordinate entry

### 5. Error Handling
- Success snackbars for operations
- Error dialogs with details
- Network error handling
- Form validation

## Theme Customization

The app uses a futuristic dark theme with:
- **Primary Neon**: Cyan (#00F0FF)
- **Secondary Neon**: Magenta (#FF00E5)
- **Accent Neon**: Green (#00FF88)
- **Dark Navy**: #0A0E27
- **Glass Blue**: #1A2347

## Code Quality

- **Modular Architecture**: Small, focused files (< 200 lines)
- **MVC Pattern**: Clear separation of concerns
- **Reusable Components**: Custom widgets
- **Type Safety**: Strict null safety

## Build APK

```bash
flutter build apk --release
```

## Troubleshooting

### Location not working
- Enable location services
- Grant location permissions
- Check GPS signal

### Images not loading
- Check internet connection
- Verify API endpoint
- Check image URLs

### Offline mode
- App automatically switches to offline
- Cached data displayed
- Sync when online restored

---

**Built with Flutter & ❤️**
