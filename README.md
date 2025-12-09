# NatokMap 📍

A Flutter-based Android application for managing and visualizing landmark records in Bangladesh. NatokMap integrates with a remote REST API to provide comprehensive landmark management with offline support and an interactive map interface.

## 📱 App Summary

NatokMap is a full-featured landmark management application that allows users to:
- View landmarks on an interactive OpenStreetMap
- Browse landmarks in a list view with swipe gestures
- Create new landmarks with GPS location and photos
- Edit and delete existing landmarks
- Work offline with local SQLite caching
- Switch between light and dark themes

The app follows an MVC architecture pattern and uses Provider for state management, ensuring clean separation of concerns and maintainable code.

## ✨ Feature List

### 🗺️ Map View
- Interactive OpenStreetMap display
- Black location markers for all landmarks
- Tap markers to view landmark details
- Real-time online/offline indicator
- Full zoom and pan controls
- Centered on Bangladesh (23.6850°N, 90.3563°E)

### 📋 Records View
- Scrollable list of all landmarks with card-based layout
- Thumbnail images (80×80px) with cached loading
- **Swipe left** to edit a landmark
- **Swipe right** to delete a landmark
- Pull-to-refresh functionality
- Landmark count display
- App branding with logo and name (left side)
- **Theme switcher** for Light/Dark mode (right side)
- Empty state handling

### ➕ New Entry Form
- Image picker with camera or gallery support
- Automatic image resizing to 800×600px
- GPS-based location detection with "Use Current Location" button
- Manual coordinate entry (latitude/longitude)
- Form validation
- **Stays on page after creation** (no redirect)
- Success notifications via snackbar
- Auto-clear form after successful submission
- Form reloads GPS location for next entry

### ✏️ Edit Landmark
- Pre-filled form with existing landmark data
- Update title, latitude, and longitude
- Back button to return to previous screen
- Success notifications

### 🎨 Theming
- **Dark Mode**: Navy gradient background (#0A0E27) with neon accents
  - Neon Cyan (#00F0FF), Magenta (#FF00E5), Green (#00FF88)
  - Glass card effects with neon borders
  - Futuristic design with glow effects
- **Light Mode**: Clean white/light gray backgrounds
  - Black text (#000000) on white backgrounds
  - Blue accent colors (#0066FF)
  - Subtle shadows and borders
- Theme switcher accessible in Records tab header
- All UI components theme-aware (cards, dialogs, forms, buttons, sheets)

### 💾 Offline Support
- SQLite local database for landmark caching
- Works completely offline with cached data
- Automatic synchronization when connection restored
- Visual offline/online indicators throughout the app
- Offline-first data strategy

### 🔄 API Integration
- REST API communication with PHP/SQLite backend
- Full CRUD operations: Create, Read, Update, Delete
- Image upload with multipart/form-data
- Efficient data synchronization
- Error handling with user feedback

## 📁 Project Structure

### MVC Architecture
```
lib/
├── main.dart                      # App entry point with Provider setup
├── models/
│   └── landmark.dart              # Landmark data model with JSON serialization
├── controllers/
│   ├── landmark_controller.dart   # Landmark state management
│   └── theme_controller.dart      # Theme state management
├── services/
│   ├── api_service.dart           # REST API communication (Dio)
│   └── database_service.dart      # SQLite database operations
├── views/
│   ├── map_view.dart              # Map screen with OpenStreetMap
│   ├── list_view.dart             # Records list screen
│   ├── form_view.dart             # New/Edit entry form
│   └── landmark_detail_sheet.dart # Landmark detail modal sheet
└── theme/
    └── app_theme.dart             # Light and dark theme definitions
```

## 🔌 API Endpoints

**Base URL**: `https://labs.anontech.info/cse489/t3/api.php`

| Method | Endpoint | Parameters | Description |
|--------|----------|------------|-------------|
| **GET** | `api.php` | - | Retrieve all landmarks |
| **POST** | `api.php` | `title`, `lat`, `lon`, `image` (file) | Create new landmark |
| **PUT** | `api.php` | `id`, `title`, `lat`, `lon`, `image` (file, optional) | Update landmark |
| **DELETE** | `api.php?id={id}` | `id` (query param) | Delete landmark |

**Response Format:**
```json
{
  "status": "success",
  "data": [
    {
      "id": "1",
      "title": "National Martyrs' Memorial",
      "lat": "23.780800",
      "lon": "90.349300",
      "image": "uploads/landmark_123456.jpg"
    }
  ]
}
```

## 🚀 Setup Instructions

### Prerequisites
- **Flutter SDK**: 3.10.1 or higher
- **Dart SDK**: 3.10.1 or higher
- **IDE**: Android Studio or VS Code with Flutter extensions
- **Device**: Android device or emulator (API level 21+)
- **Git**: For cloning the repository

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/shakilofficial0/NatokMap.git
   cd NatokMap
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter setup**
   ```bash
   flutter doctor
   ```
   Ensure all necessary components are installed.

4. **Configure API endpoint** (if needed)
   - Open `lib/services/api_service.dart`
   - Verify the base URL: `https://labs.anontech.info/cse489/t3/api.php`

5. **Run the app**
   ```bash
   flutter run
   ```
   Select your target device when prompted.

6. **Build APK** (for distribution)
   ```bash
   flutter build apk --release
   ```
   The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`

### Required Permissions
The app requires the following Android permissions (automatically requested at runtime):
- **Internet**: For REST API communication
- **Location (Fine/Coarse)**: For GPS-based coordinate detection
- **Camera**: For taking photos of landmarks
- **Storage/Media**: For selecting images from gallery (Android 13+ uses READ_MEDIA_IMAGES)

## 📦 Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Map Display
  flutter_map: ^7.0.2          # Interactive map widget
  latlong2: ^0.9.0             # Geographic coordinates
  
  # Networking
  dio: ^5.4.0                  # HTTP client for API calls
  http: ^1.2.0                 # Alternative HTTP client
  
  # Local Database
  sqflite: ^2.3.0              # SQLite database
  path: ^1.8.3                 # Path manipulation
  
  # Image Handling
  image_picker: ^1.0.5         # Camera/Gallery picker
  image: ^4.1.3                # Image processing/resizing
  cached_network_image: ^3.3.0 # Efficient image caching
  
  # Location Services
  geolocator: ^10.1.0          # GPS location access
  
  # UI/Theming
  google_fonts: ^6.1.0         # Custom fonts (Orbitron, Rajdhani)
  
  # State Management
  provider: ^6.1.1             # State management solution
```

## ⚠️ Known Limitations

### 🚫 Cannot Update Landmarks with New Images

**Issue:** When editing an existing landmark, you can successfully update the title, latitude, and longitude. However, **uploading a new image during the update operation fails** with a "File upload failed" error.

**Technical Details:**
- The PUT request with multipart/form-data is not being parsed correctly by the server
- The server-side API uses a custom `parsePutRequest()` function for handling PUT requests
- POST requests with images work perfectly (creating new landmarks)
- Per project constraints, the server-side PHP code cannot be modified

**Workarounds:**
1. **Create a new landmark** instead of updating if you need to change the image
2. **Update only text fields** (title, latitude, longitude) when editing existing landmarks
3. **Delete and recreate** the landmark if changing the image is critical

**Status:** This is a known server-side limitation that cannot be resolved without modifying the backend API.

### Other Limitations
- **Portrait Only**: App is locked to portrait orientation
- **Android Only**: No iOS build configuration (though Flutter code is cross-platform compatible)
- **Single User**: No authentication or multi-user support
- **No Search**: No search or filter functionality for landmarks
- **No Categories**: Landmarks cannot be organized into categories or tagged
- **Minimum API Level**: Requires Android 5.0 (API level 21) or higher

## 🛠️ Troubleshooting

### Map tiles not loading
- ✅ Check internet connection
- ✅ Verify OpenStreetMap tile servers are accessible
- ✅ Wait a few seconds for tiles to download

### GPS location not working
- ✅ Enable **Location Services** on your device
- ✅ Grant **Location Permission** to the app when prompted
- ✅ Ensure **GPS is enabled** (not just network location)
- ✅ Go outdoors for better GPS signal

### Images not displaying
- ✅ Check internet connection for remote images
- ✅ Verify image URLs are absolute paths
- ✅ Check if image files exist on server
- ✅ Clear app cache and restart

### App crashes or build errors
- ✅ Run `flutter clean` to clear build cache
- ✅ Run `flutter pub get` to refresh dependencies
- ✅ Update Flutter SDK: `flutter upgrade`
- ✅ Check for dependency version conflicts in `pubspec.yaml`
- ✅ Restart IDE and rebuild project

### Cannot edit landmarks with images
- ⚠️ This is a **known limitation** (see above)
- Use workarounds: update text-only fields or recreate the landmark

## 🎯 Future Enhancements

Potential improvements for future versions:
- ✨ Fix PUT request image upload functionality
- 🔍 Add search and filter capabilities for landmarks
- 🏷️ Implement landmark categories and tags
- 👤 Add user authentication and profiles
- 📱 Support landscape orientation
- 🔗 Add landmark sharing via link or social media
- 🧭 Include directions/navigation to landmarks using Google Maps integration
- 📤 Export landmarks to CSV, JSON, or KML format
- 🌐 Multi-language support (Bengali, English)
- ⭐ Favorite landmarks feature
- 📊 Statistics dashboard (most visited, recently added, etc.)

## 🎨 Design Philosophy

**Dark Theme (Default):**
- Futuristic aesthetic with navy gradients
- Neon accents: Cyan (#00F0FF), Magenta (#FF00E5), Green (#00FF88)
- Glass morphism effects with semi-transparent cards
- Glow effects on interactive elements

**Light Theme:**
- Clean, minimalist design
- High contrast with black text on white backgrounds
- Blue accent color (#0066FF) for primary actions
- Subtle shadows for depth

Both themes ensure readability and accessibility while maintaining a modern, professional appearance.


## 👨‍💻 Developer

**Shakil Ahmed**
- GitHub: [@shakilofficial0](https://github.com/shakilofficial0)
- Project: NatokMap - Bangladesh Landmarks Management App

## 🙏 Acknowledgments

- **OpenStreetMap** for providing free map tiles and mapping services
- **Backend API** hosted at `labs.anontech.info` by course instructor
- **Flutter Team** for the excellent cross-platform framework
- **Course Instructor** for project guidance and requirements
- **Dart Packages Community** for the amazing open-source packages

---

**Version:** 1.0.0  
**Last Updated:** December 9, 2025  
**Built with Flutter & ❤️**
