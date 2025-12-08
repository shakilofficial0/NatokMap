# Quick Start Guide - NatokMap

## 🚀 Quick Start (5 minutes)

### Step 1: Dependencies
```bash
cd NatokMap
flutter pub get
```

### Step 2: Run on Emulator/Device
```bash
flutter run
```

### Step 3: Grant Permissions
When app launches, grant these permissions:
- Location
- Camera
- Storage/Photos

## 📱 Using the App

### Add Your First Landmark

1. **Tap "New Entry" tab** (bottom navigation)
2. **Tap image area** to select a photo
   - Choose "Gallery" or "Camera"
3. **Fill in details:**
   - Title (e.g., "Dhaka University")
   - Tap "Use Current Location" (or enter manually)
4. **Tap "Create Landmark"**
5. Wait for success message!

### View on Map

1. **Tap "Overview" tab**
2. See your landmark as a glowing cyan marker
3. **Tap marker** to see details in bottom sheet
4. Use refresh button to reload data

### View in List

1. **Tap "Records" tab**
2. See all landmarks as cards
3. **Swipe left** to edit
4. **Swipe right** to delete
5. **Pull down** to refresh

### Edit Landmark

**Method 1:** Swipe left on list item
**Method 2:** Tap marker → Tap "Edit" button

### Delete Landmark

**Method 1:** Swipe right on list item
**Method 2:** Tap marker → Tap "Delete" button

## 🎨 Theme Features

- **Dark Background**: Navy gradient
- **Neon Accents**: Cyan, Magenta, Green
- **Glass Cards**: Semi-transparent with borders
- **Glow Effects**: On buttons and markers

## 💾 Offline Mode

- App works offline automatically
- Orange "Offline" indicator appears
- Cached data is shown
- Auto-syncs when online

## ⚠️ Common Issues

### Location Not Detected
- Enable Location Services
- Grant Location Permission
- Try again or enter manually

### Image Not Uploading
- Check internet connection
- Ensure image size < 10MB
- Try different image

### Map Not Loading
- Check internet connection
- Tiles load from stadiamaps.com
- Restart app if needed

## 🔧 Build Release APK

```bash
flutter build apk --release
```

**Output:** `build/app/outputs/flutter-apk/app-release.apk`

## 📊 API Testing

Test API directly:

```bash
# Get all landmarks
curl https://labs.anontech.info/cse489/t3/api.php

# Create landmark (use Postman for file upload)
POST https://labs.anontech.info/cse489/t3/api.php
Body:
- title: "Test"
- lat: 23.8103
- lon: 90.4125
- image: [file]
```

## 🎯 Next Steps

1. ✅ App is ready to use
2. ✅ All features implemented
3. ✅ Offline support enabled
4. 🎨 Enjoy the futuristic UI!

## 📞 Support

- Check `README.md` for details
- Check `PROJECT_SUMMARY.md` for technical info
- Review code comments for implementation details

---

**Happy Mapping! 🗺️✨**
