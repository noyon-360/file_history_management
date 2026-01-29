# 📄 Scanner Pro: File & History Management
## *Flutter Developer Coding Test Implementation*

Scanner Pro is a premium document scanning and management application built as a solution for the Flutter Developer Coding Test. It leverages modern architecture and sleek design to provide a robust user experience.

---

## � Features Implemented
1.  **PDF Scanning**: Integrated `simplest_document_scanner` for high-quality document capture.
2.  **History List**: A reactive history of all scanned documents with real-time updates.
3.  **Favorites System**: One-tap "Star" functionality to organize important documents in a dedicated tab.
4.  **Real-time Search**: Instant filtering of documents by name.
5.  **Soft & Permanent Delete**: A Trash Bin system (Soft Delete) for safety, with permanent deletion and "Clear All" options.
6.  **File Details**: Comprehensive view of file size, creation date, and storage path.

---

## 🧠 Technical Considerations (Coding Test Answers)

### 1. Handling Missing Files on Disk
In the `ScanDocController`, the `loadDocuments()` method performs a safety check. Before populating the list, it verifies `File(path).exists()`. If a file is missing (e.g., deleted manually from the file explorer), the app automatically prunes the Hive registry to keep the database and storage in sync.

### 2. Preventing Duplicate Entries
Each document is assigned a unique `timestamp` as its ID during the save process. This ID is used as the key in Hive storage, ensuring that every scan is a unique entity. The saving logic also prevents multiple rapid-fire clicks from creating redundant files.

### 3. Optimizing for Large Numbers of Files
*   **Modular Controllers**: Logic is separated into `ScanDocController` (Repository/Core), `SearchController`, and `TrashController` to reduce the load on a single controller.
*   **Reactive State**: Using `GetX` with `Obx`, only the specific parts of the UI that change are re-rendered.
*   **In-Memory Filtering**: For performance, active/favorite/trash lists are computed in memory for instant responsiveness, with a structure ready for lazy-loading/pagination if the dataset grows significantly.

### 4. File Type Detection
Detection is handled through a combination of the `simplest_document_scanner` result (which generates PDF bytes) and standard path extension metadata. The app specifically targets `.pdf` generation.

### 5. Storage Failure Handling
All storage operations (saving, deleting, updating) are wrapped in `try-catch` blocks. Failures are logged using `DPrint` and can be easily hooked into UI snackbars or alerts to inform the user if disk space is full or permissions are denied.

---

## 🚀 Usage Guide

### 1. 🔍 Scanning
- Tap **"Scan Document"** at the bottom right.
- Provide a name (or leave empty for a default timestamp-based name).

### 2. 📂 Navigation
- **All Docs**: Your main history feed.
- **Favorites**: Tap the **Star Icon** to send a file here.
- **Search**: Tap the **Magnifying Glass** in the appraisal to find files by name.

### 3. 🗑 Trash Bin
- Tap the **Trash Icon** in the top right of the main screen to view deleted files.
- You can **Restore** or **Permanently Delete** items here.

---

## 📦 Tech Stack
- **Framework**: Flutter
- **State Management**: GetX
- **Storage**: Hive (for metadata), `path_provider` (for PDF storage)
- **Scanning**: `simplest_document_scanner`
- **Typography**: Manrope (Configured in `pubspec.yaml` and `AppTheme`)

---

*Coded with focus on high-quality architecture and user experience.* 🚀
