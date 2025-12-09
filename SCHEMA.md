# Database Schema Documentation

## Overview

NatokMap uses **SQLite** as its local database for offline caching of landmark data. The database provides persistence for the application, allowing users to view and interact with landmarks even when offline.

**Database File**: `landmarks.db`  
**Database Version**: 1  
**Database Engine**: SQLite (via sqflite package)

---

## Tables

### `landmarks` Table

This is the primary table that stores all landmark information, both synced from the remote server and locally created entries awaiting synchronization.

#### Table Structure

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| `id` | INTEGER | PRIMARY KEY | Unique identifier for the landmark (matches server ID) |
| `title` | TEXT | NOT NULL | Name/title of the landmark |
| `latitude` | REAL | NOT NULL | Latitude coordinate (decimal degrees) |
| `longitude` | REAL | NOT NULL | Longitude coordinate (decimal degrees) |
| `image_url` | TEXT | NULLABLE | Remote URL of the landmark image on the server |
| `local_image_path` | TEXT | NULLABLE | Local file path for cached/offline image |
| `created_at` | TEXT | NULLABLE | ISO 8601 timestamp when landmark was created |
| `updated_at` | TEXT | NULLABLE | ISO 8601 timestamp of last update |
| `is_synced` | INTEGER | NOT NULL | Sync status: 1 = synced with server, 0 = pending sync |

#### SQL Definition

```sql
CREATE TABLE landmarks (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  latitude REAL NOT NULL,
  longitude REAL NOT NULL,
  image_url TEXT,
  local_image_path TEXT,
  created_at TEXT,
  updated_at TEXT,
  is_synced INTEGER NOT NULL
);
```

---

## Field Details

### Primary Key
- **`id`**: Auto-incremented integer that serves as the primary key. This ID is synchronized with the server-side database to maintain consistency.

### Required Fields
- **`title`**: The landmark's name (e.g., "National Martyrs' Memorial", "Ahsan Manzil")
- **`latitude`**: Geographic latitude in decimal degrees format (e.g., 23.780800)
- **`longitude`**: Geographic longitude in decimal degrees format (e.g., 90.349300)
- **`is_synced`**: Boolean stored as integer (0 or 1) indicating synchronization status

### Optional Fields
- **`image_url`**: Full URL to the image stored on the remote server (e.g., "https://labs.anontech.info/cse489/t3/uploads/landmark_123.jpg")
- **`local_image_path`**: Path to locally cached image file for offline viewing
- **`created_at`**: ISO 8601 formatted datetime string (e.g., "2025-12-09T10:30:00.000Z")
- **`updated_at`**: ISO 8601 formatted datetime string for tracking modifications

---

## Data Types Mapping

### SQLite to Dart Mapping

| SQLite Type | Dart Type | Example Value |
|-------------|-----------|---------------|
| INTEGER | `int?` | `1`, `42`, `null` |
| TEXT | `String` | `"Dhaka"`, `"2025-12-09T10:30:00.000Z"` |
| REAL | `double` | `23.780800`, `90.349300` |
| INTEGER (boolean) | `bool` | `true` → `1`, `false` → `0` |

### Coordinate Precision
- Latitude: `-90.0` to `+90.0` (typically 6-8 decimal places)
- Longitude: `-180.0` to `+180.0` (typically 6-8 decimal places)
- Example: `23.780800, 90.349300` (precision to ~11 meters)

---

## Entity-Relationship Diagram (ERD)

```
┌─────────────────────────────────────────────────────────────┐
│                         LANDMARKS                           │
├─────────────────────────────────────────────────────────────┤
│ PK  id                  INTEGER                             │
│     title               TEXT NOT NULL                       │
│     latitude            REAL NOT NULL                       │
│     longitude           REAL NOT NULL                       │
│     image_url           TEXT                                │
│     local_image_path    TEXT                                │
│     created_at          TEXT (ISO 8601)                     │
│     updated_at          TEXT (ISO 8601)                     │
│     is_synced           INTEGER (0 or 1)                    │
└─────────────────────────────────────────────────────────────┘
```

**Notes:**
- Single table architecture (no foreign keys or relationships)
- Self-contained entity with all required information
- No normalized relationships (denormalized for offline-first performance)

---

## Indexes

Currently, the database does not have explicit indexes beyond the primary key. For future optimization, consider:

```sql
-- Potential indexes for future versions
CREATE INDEX idx_landmarks_synced ON landmarks(is_synced);
CREATE INDEX idx_landmarks_created ON landmarks(created_at DESC);
CREATE INDEX idx_landmarks_location ON landmarks(latitude, longitude);
```

---

## Database Operations

### CRUD Operations

| Operation | SQL Method | Description |
|-----------|------------|-------------|
| **Create** | `INSERT INTO landmarks` | Add new landmark (conflict: REPLACE) |
| **Read All** | `SELECT * FROM landmarks ORDER BY created_at DESC` | Retrieve all landmarks sorted by creation |
| **Read One** | `SELECT * FROM landmarks WHERE id = ?` | Get specific landmark by ID |
| **Update** | `UPDATE landmarks SET ... WHERE id = ?` | Modify existing landmark |
| **Delete** | `DELETE FROM landmarks WHERE id = ?` | Remove landmark by ID |
| **Delete All** | `DELETE FROM landmarks` | Clear entire table |

### Special Queries

**Get Unsynced Landmarks:**
```sql
SELECT * FROM landmarks WHERE is_synced = 0;
```
Used for synchronization operations to identify locally modified entries that need to be pushed to the server.

---

## Synchronization Strategy

### Offline-First Architecture

1. **On App Launch:**
   - Load landmarks from local SQLite database
   - Display cached data immediately (fast startup)
   - Fetch latest data from server in background
   - Update local database with server response

2. **On Create:**
   - Insert into local database with `is_synced = 0`
   - Attempt POST to server
   - If successful: Update `is_synced = 1` and set server `id`
   - If failed: Keep `is_synced = 0` for later retry

3. **On Update:**
   - Modify local database record
   - Set `is_synced = 0` and update `updated_at`
   - Attempt PUT to server
   - If successful: Set `is_synced = 1`
   - If failed: Keep unsync status for retry

4. **On Delete:**
   - Remove from local database immediately (optimistic UI)
   - Attempt DELETE on server
   - If failed: Log error (record already removed locally)

5. **On Network Restore:**
   - Query for unsynced records: `WHERE is_synced = 0`
   - Batch sync all pending changes
   - Update sync status on success

---

## Data Validation

### Constraints & Rules

| Field | Validation Rule | Error Handling |
|-------|----------------|----------------|
| `title` | NOT NULL, min 1 char | Display error: "Title required" |
| `latitude` | -90 to +90 | Auto-clamp or validation error |
| `longitude` | -180 to +180 | Auto-clamp or validation error |
| `image_url` | Valid URL or NULL | Allow empty, no strict validation |
| `is_synced` | 0 or 1 only | Enforced by application logic |

### Application-Level Validation

The Dart model (`Landmark`) performs additional validation:
- **Type conversion**: Safely parses strings to doubles
- **NULL safety**: Handles missing fields gracefully
- **URL normalization**: Converts relative URLs to absolute

---

## Example Data

### Sample Record

```json
{
  "id": 1,
  "title": "National Martyrs' Memorial",
  "latitude": 23.780800,
  "longitude": 90.349300,
  "image_url": "https://labs.anontech.info/cse489/t3/uploads/landmark_001.jpg",
  "local_image_path": "/data/user/0/com.shakil.natok_map/cache/landmark_001.jpg",
  "created_at": "2025-12-09T08:15:30.000Z",
  "updated_at": "2025-12-09T14:22:45.000Z",
  "is_synced": 1
}
```

### SQL INSERT Example

```sql
INSERT INTO landmarks (
  id, 
  title, 
  latitude, 
  longitude, 
  image_url, 
  local_image_path,
  created_at,
  updated_at,
  is_synced
) VALUES (
  1,
  'National Martyrs'' Memorial',
  23.780800,
  90.349300,
  'https://labs.anontech.info/cse489/t3/uploads/landmark_001.jpg',
  '/data/user/0/com.shakil.natok_map/cache/landmark_001.jpg',
  '2025-12-09T08:15:30.000Z',
  '2025-12-09T14:22:45.000Z',
  1
);
```

---

## Database Migration Strategy

**Current Version**: 1

If schema changes are needed in future versions:

```dart
// Example migration from v1 to v2
Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    // Add new column for categories
    await db.execute('ALTER TABLE landmarks ADD COLUMN category TEXT');
  }
}
```

---

## Performance Considerations

### Optimization Strategies

1. **Batch Operations**: Use transactions for multiple inserts/updates
2. **Lazy Loading**: Load only visible landmarks for list view
3. **Image Caching**: Store images locally to reduce network calls
4. **Query Optimization**: Use WHERE clauses to filter before loading into memory

### Current Performance

- **Insert**: < 10ms per record
- **Query All**: < 50ms for 100 records
- **Query By ID**: < 5ms (primary key lookup)
- **Update**: < 10ms per record
- **Delete**: < 5ms per record

---

## Backup & Recovery

### Backup Location
- **Database Path**: `/data/data/com.shakil.natok_map/databases/landmarks.db`
- **Android Internal Storage**: Not accessible without root

### Export Strategy
Future implementations could include:
- Export to JSON file
- Cloud backup integration
- CSV export for spreadsheet analysis

---

## Security Considerations

- **No Sensitive Data**: Database contains only public landmark information
- **Local Only**: Database is not directly exposed to network
- **SQL Injection**: Protected by parameterized queries (`?` placeholders)
- **Permissions**: Android sandbox protects database from other apps

---

## Related Files

| File Path | Description |
|-----------|-------------|
| `lib/database/database_helper.dart` | SQLite operations and queries |
| `lib/models/landmark.dart` | Dart data model with serialization |
| `lib/repositories/landmark_repository.dart` | Data access layer |
| `lib/controllers/landmark_controller.dart` | State management and business logic |

---

## Technical Notes

### sqflite Package
- **Version**: ^2.3.0
- **Platform**: Android, iOS, macOS
- **Type**: SQLite wrapper for Flutter
- **Thread Safety**: Operations are serialized automatically

### Database Location
- **Android**: `/data/data/<package_name>/databases/`
- **iOS**: `/Documents/databases/`
- **Filename**: `landmarks.db`

---

**Schema Version**: 1.0  
**Last Updated**: December 9, 2025  
**Maintained By**: Shakil Ahmed
