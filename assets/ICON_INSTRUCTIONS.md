# NatokMap Launcher Icon Setup

## Required Icon

You need to create or place an icon file at: `assets/icon.png`

### Icon Requirements:
- **Size**: 1024x1024 pixels (recommended)
- **Format**: PNG with transparency
- **Design**: NatokMap logo - map pin or location marker with "N" or Bangladesh map outline
- **Background**: Transparent (for adaptive icon)

### Suggested Design Elements:
- 📍 Location pin/marker icon
- 🗺️ Map outline
- 🇧🇩 Bangladesh country outline
- Colors: Navy blue (#0A0E27), Cyan (#00F0FF), or Magenta (#FF00E5)

## Quick Icon Generation Options:

### Option 1: Use an Online Icon Generator
1. Visit: https://icon.kitchen or https://www.appicon.co
2. Upload or create your design
3. Download as PNG (1024x1024)
4. Save as `assets/icon.png`

### Option 2: Use Figma/Canva
1. Create 1024x1024 canvas
2. Design your icon with location pin theme
3. Export as PNG
4. Save as `assets/icon.png`

### Option 3: Use an Existing Image
1. Find a suitable icon image (preferably 512x512 or larger)
2. Resize to 1024x1024 using image editor
3. Save as `assets/icon.png`

## After Creating Icon:

Run these commands to generate launcher icons:

```bash
# Install dependencies
flutter pub get

# Generate launcher icons
flutter pub run flutter_launcher_icons

# Build and run
flutter run
```

## Icon Configuration

The icon is configured in `pubspec.yaml`:
- Android adaptive icon with navy background (#0A0E27)
- Foreground icon with transparency
- Minimum Android SDK: 21

## Troubleshooting

If you see errors:
1. Ensure `assets/icon.png` exists and is valid PNG
2. Check file size is at least 512x512 pixels
3. Run `flutter clean` and try again
4. Verify flutter_launcher_icons package is installed: `flutter pub get`
