# PhotoSafe - A Secure Photo Vault iOS App

PhotoSafe is a privacy-focused iOS app that lets users securely store photos, encrypt them, and organize them using face detection. The app supports offline access, secure sharing via RESTful APIs, and an SDK for third-party integration. It uses a mix of Objective-C, Swift, and C/C++ to handle low-level operations, with a focus on performance, security, and modern iOS development practices.

# Key Features

### Secure Photo Storage: 
- Photos are encrypted using AES-256 (leveraging cryptography knowledge).
- Stored in a Core Data database with SQLite backend for persistence.
- Offline access with secure caching.

### Face Detection:
- Uses Core Image for face detection to tag and organize photos.
- Implemented in C/C++ for performance-critical image processing.

### Secure Sharing:
- RESTful API integration to share encrypted photos with other users.
- Asynchronous networking with JSON parsing for metadata exchange.

### Custom UI:
- Programmatic UI using Swift and Interface Builder for certain views.
- Core Animation for smooth transitions and custom photo gallery animations.

### SDK for Third-Party Integration:
- A native iOS SDK to allow other apps to integrate PhotoSafe’s encryption and storage capabilities.
- Exposes APIs for photo encryption/decryption and storage.

### Performance Optimization:
- Multithreading with GCD and Operation Queues for background tasks (e.g., encryption, face detection).
- Memory management with ARC and manual handling for C/C++ components.

### Testing and Debugging:Unit tests for core functionality (encryption, database operations).
- UI tests for user flows (e.g., photo upload, sharing).
- Profiling with Instruments for memory leaks and performance bottlenecks.

### App Distribution:
- Configured for App Store submission with provisioning profiles and code signing.
- Uses Swift Package Manager for third-party dependencies (e.g., networking libraries).


