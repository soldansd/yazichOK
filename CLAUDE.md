# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an iOS app built with SwiftUI for English language learners. The app includes speaking assessment, article reading, audio recording, and planned features for flashcards, grammar tests, listening practice, and authentication.

## Build & Development Commands

**Building the project:**
- Open `EnglishApp.xcodeproj` in Xcode
- Build: `Cmd+B` or `xcodebuild -project EnglishApp.xcodeproj -scheme EnglishApp`
- Run: `Cmd+R` or use Xcode's simulator

**Running tests:**
- Run tests: `Cmd+U` or `xcodebuild test -project EnglishApp.xcodeproj -scheme EnglishApp -destination 'platform=iOS Simulator,name=iPhone 15'`

## Dependencies

The project uses Swift Package Manager with the following dependencies (see `Package.resolved`):
- **Alamofire 5.10.2**: All network requests
- **Lottie-iOS 4.5.1**: Animations (JSON animation files in `/Animations/`)

## Architecture

### MVVM + Coordinator Pattern

The project uses **MVVM + Coordinator** pattern with SwiftUI's `NavigationStack` for navigation:

**Coordinator Navigation:**
- `HomeCoordinator` manages navigation using `NavigationPath`
- Navigation targets defined in `Screen` enum (see `EnglishApp/HomeTab/HomeModule/Coordinator/ScreenType/Screen.swift`)
- Each screen case can carry associated data (e.g., `case article(id: Int)`)
- Methods: `push(_:)`, `pop()`, `popToRoot()`

**Module Structure:**
Each feature module follows this organization:
```
FeatureModule/
├── Model/           # Business logic models
├── View/            # SwiftUI views
│   └── Subview/     # Reusable view components
└── ViewModel/       # View state and business logic
```

### Network Layer Architecture

**Pattern: DTO → Business Model**
- Network layer uses DTOs (Data Transfer Objects) in `Managers/NetworkManager/Models/`
- DTOs are mapped to domain models in feature modules
- This separation allows API changes without affecting business logic

**NetworkManager** (`Managers/NetworkManager/NetworkManager.swift`):
- Singleton: `NetworkManager.shared`
- Uses Alamofire for all HTTP requests
- Generic `decodeResponse(_:successType:)` handles error/success parsing
- All methods are `async throws` for Swift concurrency

**Adding new endpoints:**
1. Create DTO in `NetworkManager/Models/` (matches API response)
2. Create business model in feature's `Model/` folder
3. Add method to `NetworkManager` that returns DTO
4. Map DTO → business model in ViewModel

### Audio Recording

**AudioRecorder** (`Managers/AudioRecorder.swift`):
- Singleton: `AudioRecorder.shared`
- Uses AVFoundation for recording/playback
- Recordings saved to `FileManager.temporaryDirectory` as `.m4a`
- Key methods: `requestPermissionAndRecord()`, `stopRecording()`, `playRecording()`
- Supports pause/resume functionality

## Project Structure

```
EnglishApp/
├── EnglishAppApp.swift           # App entry point
├── ContentView.swift             # Test/playground view
├── HomeTab/                      # Main feature modules
│   ├── ArticleModule/
│   ├── ArticlesPreviewModule/
│   ├── HomeModule/
│   │   └── Coordinator/          # Navigation coordinator
│   ├── RecordingAnswersModule/
│   ├── SpeakingAssesmentModule/
│   └── SpeakingTopicsModule/
├── Managers/
│   ├── AudioRecorder.swift       # Singleton for audio
│   └── NetworkManager/           # Singleton for API calls
│       ├── Models/               # DTOs only
│       └── Error/                # Network error types
├── Assets.xcassets/
│   ├── Colors/                   # Custom color sets
│   └── Images/                   # App images
└── Preview Content/
```

## Adding New Features

**Follow these steps when implementing new modules:**

1. **Create module folder** under appropriate tab (e.g., `HomeTab/NewFeatureModule/`)

2. **Implement MVVM structure:**
   - `Model/`: Define business models (not DTOs)
   - `View/`: SwiftUI views with preview
   - `ViewModel/`: `ObservableObject` with `@Published` state
   - Optional `View/Subview/`: Reusable components

3. **Add navigation:**
   - Add case to `Screen` enum if navigation is needed
   - Use coordinator's `push()` method to navigate
   - Use `BackButtonToolbar` for consistent back button UI

4. **Network integration (if needed):**
   - Create DTO in `NetworkManager/Models/`
   - Add method to `NetworkManager`
   - Map DTO to business model in ViewModel
   - Use mock data during development, then replace with real API

5. **Follow existing patterns:**
   - Check similar existing modules for reference
   - Use `@StateObject` for ViewModels
   - Use `@EnvironmentObject` for shared coordinators
   - Keep views declarative; logic belongs in ViewModels

## Development Guidelines

**Mock Data Strategy:**
Per project plan (see `Docs/plan.md`), new features should initially use mock network interactions that can be easily replaced with real network requests. This allows rapid UI development before backend is ready.

**Custom Colors:**
Use colors defined in `Assets.xcassets/Colors/`:
- Semantic: `appBackground`, `appForeground`
- Themed: `darkBlue`, `darkOrange`, `pastelBlue`, `pastelOrange`, etc.

**Animations:**
Lottie animations stored in `/Animations/` folder as `.json` files. Use `LottieView` from lottie-ios package.

## Planned Features (Reference)

See `Docs/plan.md` for detailed specifications of upcoming features:
- Task 1: Flash Cards
- Task 2: Grammar Tests
- Task 3: Listening Practice
- Task 4: Sign In Screen
- Task 5: Sign Up Screen

When implementing these, follow the architecture patterns and module structure outlined above.
