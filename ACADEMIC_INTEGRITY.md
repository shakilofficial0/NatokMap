# Academic Integrity Statement

## Project: NatokMap - Bangladesh Landmarks Management Application

**Student Name:** Shakil Ahmed  
**Course:** CSE489  
**Date:** December 9, 2025

---

## Declaration of Work

I hereby declare that this project submission is my own original work, and I have acknowledged all sources of assistance and collaboration in accordance with the academic integrity policies of my institution.

---

## Work Created by Me

### Core Application Development

I personally designed, developed, and implemented the following components from scratch:

#### 1. **Architecture & Design**
- Complete MVC (Model-View-Controller) architecture design
- Application structure and folder organization
- Data flow and state management strategy
- Offline-first architecture with synchronization logic

#### 2. **Models**
- `Landmark` class with all properties and methods
- JSON serialization and deserialization logic
- Database mapping functions (`toDbMap()`, `fromDbMap()`)
- Type conversion and validation methods

#### 3. **Views (User Interface)**
- `map_view.dart` - Interactive map screen with OpenStreetMap integration
- `list_view.dart` - Records list with swipe gestures and theme switcher
- `form_view.dart` - New/Edit entry form with image picker and GPS integration
- `landmark_detail_sheet.dart` - Bottom sheet for landmark details
- Custom UI components and layouts
- Theme-aware styling for all components

#### 4. **Controllers (State Management)**
- `landmark_controller.dart` - Complete CRUD operations and state management
- `theme_controller.dart` - Theme switching logic
- Provider integration and notifiers
- Business logic implementation

#### 5. **Services**
- `api_service.dart` - REST API communication with Dio
  - GET, POST, DELETE implementations (working)
  - PUT method with multipart/form-data (attempted fixes)
- Database operations and offline caching logic
- Image handling and resizing
- GPS location services integration

#### 6. **Database Layer**
- SQLite database schema design
- `database_helper.dart` - All CRUD operations
- Offline caching implementation
- Data synchronization strategy

#### 7. **Theming System**
- `app_theme.dart` - Complete dark and light theme definitions
- Color schemes (neon colors for dark, clean colors for light)
- Theme-aware component styling
- Dynamic theme switching functionality

#### 8. **Features Implementation**
- Bottom navigation with three tabs
- Swipe-to-edit and swipe-to-delete gestures
- Pull-to-refresh functionality
- Image picker with camera/gallery options
- Automatic image resizing (800×600px)
- GPS location detection
- Form validation and error handling
- Success/error notifications
- Offline/online indicators
- Landmark detail views

#### 9. **Integration Work**
- REST API integration with backend
- Image upload with multipart/form-data
- Offline data caching and retrieval
- Network state management
- Permission handling (location, camera, storage)

#### 10. **Testing & Debugging**
- Manual testing of all features
- Bug identification and resolution
- Error handling implementation
- Edge case handling

---

## Tools and Technologies Used

### Development Tools
- **Flutter SDK** (3.10.1) - Primary development framework
- **Dart** (3.10.1) - Programming language
- **Android Studio** - IDE for Android development
- **VS Code** - Code editor
- **Git** - Version control

### Flutter Packages (Open Source)
- `flutter_map: ^7.0.2` - Map display
- `dio: ^5.4.0` - HTTP client
- `sqflite: ^2.3.0` - Local database
- `provider: ^6.1.1` - State management
- `image_picker: ^1.0.5` - Image selection
- `geolocator: ^10.1.0` - GPS location
- `google_fonts: ^6.1.0` - Typography
- `cached_network_image: ^3.3.0` - Image caching
- Other supporting packages as listed in `pubspec.yaml`

### External Services
- **OpenStreetMap** - Free map tiles provider
- **Backend API** - Provided by course instructor at `labs.anontech.info`

---

## AI Tools Used

### GitHub Copilot (AI Assistant)

I used **GitHub Copilot** as an AI-powered coding assistant throughout the development process for the following purposes:

#### Areas Where AI Was Used:

1. **Bug Fixing and Troubleshooting**
   - Debugging PUT request image upload issues
   - Fixing map tile display problems
   - Resolving DELETE method format issues
   - Troubleshooting theme-related UI inconsistencies
   - Fixing image URL conversion problems

2. **Code Optimization**
   - Suggestions for more efficient Dart code
   - Performance optimization recommendations
   - Code refactoring suggestions
   - Null safety improvements

3. **Documentation**
   - README.md structure and content
   - WIREFRAMES.md creation
   - SCHEMA.md database documentation
   - Code comments and inline documentation
   - ICON_INSTRUCTIONS.md setup guide

4. **Problem-Solving Assistance**
   - Multipart/form-data construction for PUT requests
   - SQLite query optimization
   - State management best practices
   - Theme switching implementation guidance

5. **Learning and Reference**
   - Flutter package usage examples
   - Best practices for specific implementations
   - API integration patterns
   - Async/await patterns

---

## AI-Generated Content Modified by Me

All AI-suggested code and documentation went through my personal review and modification process:

### Code Modifications

1. **API Service PUT Method**
   - AI suggested initial multipart/form-data approach
   - **I modified:** Added custom boundary format, adjusted headers, fixed path separators
   - **I tested:** Multiple iterations to match server requirements
   - **Note:** Still working on resolving image upload in PUT requests

2. **Theme Implementation**
   - AI provided basic theme structure
   - **I customized:** All color schemes (neon colors for dark theme, clean colors for light)
   - **I designed:** Glass morphism effects, gradients, and specific styling
   - **I implemented:** Theme-aware components throughout the app

3. **UI Components**
   - AI suggested basic Flutter widgets
   - **I designed:** Custom layouts, positioning, and styling
   - **I implemented:** Specific UX requirements (e.g., form stays on page, theme switcher position)

4. **Database Operations**
   - AI provided SQLite query templates
   - **I designed:** Complete schema structure and relationships
   - **I implemented:** Sync logic and offline-first strategy

5. **Documentation Files**
   - AI helped structure markdown files
   - **I provided:** All technical details, specifications, and project-specific content
   - **I reviewed:** Accuracy and completeness of all documentation

### Design Decisions Made by Me

- Application architecture (MVC pattern)
- Database schema and field types
- Color schemes and theming approach
- User flow and navigation structure
- Feature prioritization and implementation order
- Error handling strategies
- Offline-first synchronization approach

---

## What I Learned

Through this project, I gained hands-on experience with:

1. **Flutter Development**
   - Building complete mobile applications
   - State management with Provider
   - Asynchronous programming with async/await
   - Widget composition and custom UI

2. **API Integration**
   - REST API communication
   - Multipart/form-data handling
   - Error handling and retry logic
   - Network state management

3. **Database Management**
   - SQLite database design
   - CRUD operations
   - Data synchronization strategies
   - Offline-first architecture

4. **Mobile App Features**
   - Map integration (OpenStreetMap)
   - Image handling and compression
   - GPS location services
   - Permission management
   - Theming systems

5. **Problem-Solving**
   - Debugging complex issues (PUT request problem)
   - Working within constraints (server-side limitations)
   - Iterative development and testing
   - Reading documentation and adapting solutions

---

## Known Limitations and Challenges

### Current Issue: PUT Request with Image Upload

**Problem:** Updating landmarks with new images fails with "File upload failed" error.

**My Attempts to Resolve:**
1. Manually constructed multipart/form-data body
2. Tried different boundary formats (dart-boundary, WebKit-boundary)
3. Adjusted headers and content formatting
4. Used alternative HTTP packages (http, dio)
5. Analyzed server-side requirements from api.php

**Constraint:** Cannot modify server-side code per project requirements.

**Workaround Provided:** Users can update text fields only, or delete and recreate landmarks to change images.

**AI Assistance:** GitHub Copilot provided suggestions for multipart construction, but the issue remains due to server-side parsing limitations.

---

## Honesty Statement

I confirm that:

- ✅ All core application logic was written by me
- ✅ I understand every line of code in this project
- ✅ AI tools were used as assistants, not as primary developers
- ✅ All AI-generated suggestions were reviewed, tested, and modified by me
- ✅ I can explain and defend any part of this codebase
- ✅ This project represents my genuine learning and effort
- ✅ All external resources and tools have been properly acknowledged

---

## References and Resources

### Official Documentation
- Flutter Documentation: https://flutter.dev/docs
- Dart Documentation: https://dart.dev/guides
- OpenStreetMap: https://www.openstreetmap.org

### Learning Resources
- Flutter Widget Catalog
- Pub.dev package documentation
- Stack Overflow (for specific technical issues)
- GitHub repositories for package examples

### Tools
- GitHub Copilot: AI pair programming assistant
- Flutter DevTools: Debugging and profiling
- Android Studio: IDE and emulator

---

**Signature:** Shakil Ahmed  
**Date:** December 9, 2025

---

## Final Note

This project represents my sincere effort to learn mobile application development using Flutter. While I used AI tools to assist with debugging and documentation, the core development, design decisions, and implementation were all performed by me. I take full responsibility for the code quality, functionality, and any limitations present in the application.

The use of AI tools has enhanced my learning experience by providing quick feedback, suggesting best practices, and helping me understand complex concepts. However, I ensured that I understood and could justify every piece of code before including it in my project.

I am committed to academic integrity and honest representation of my work.
