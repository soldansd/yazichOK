# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an iOS app built with SwiftUI for English language learners. The app includes:
- **Speaking Assessment**: Record and evaluate pronunciation
- **Article Reading**: Browse and read English articles
- **Flash Cards**: Vocabulary learning with spaced repetition
- **Grammar Tests**: Interactive quizzes with instant feedback
- **Listening Practice**: Audio playback with controls
- **Authentication**: User sign in/sign up system

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
- `HomeCoordinator` manages Home tab navigation using `NavigationPath`
- `LearnCoordinator` manages Learn tab navigation using `NavigationPath`
- Navigation targets defined in `Screen` enum (Home) and `LearnScreen` enum (Learn)
- Each screen case can carry associated data (e.g., `case article(id: Int)`, `case grammarTest(topicID: String)`)
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

### Audio Management

**AudioRecorder** (`Managers/AudioRecorder.swift`):
- Singleton: `AudioRecorder.shared`
- Uses AVFoundation for recording/playback
- Recordings saved to `FileManager.temporaryDirectory` as `.m4a`
- Key methods: `requestPermissionAndRecord()`, `stopRecording()`, `playRecording()`
- Supports pause/resume functionality

**AudioPlayerManager** (`Managers/AudioPlayerManager.swift`):
- Singleton: `AudioPlayerManager.shared`
- Uses AVPlayer for audio playback (supports both local and remote audio)
- Published properties: `isPlaying`, `currentTime`, `duration`, `isLoading`, `currentAudio`
- Key methods: `loadAudio(_:)`, `play()`, `pause()`, `seekBackward(by:)`, `seekForward(by:)`, `reset()`
- Real-time progress updates via observers
- Mock playback support for development without audio files

## Project Structure

```
EnglishApp/
├── EnglishAppApp.swift           # App entry point (with auth check)
├── MainTabView.swift             # Main tab bar (4 tabs)
├── ContentView.swift             # Test/playground view
├── HomeTab/                      # Home tab feature modules
│   ├── ArticleModule/
│   ├── ArticlesPreviewModule/
│   ├── FlashCardsModule/         # Vocabulary flash cards
│   ├── HomeModule/
│   │   └── Coordinator/          # Navigation coordinator
│   ├── RecordingAnswersModule/
│   ├── SpeakingAssesmentModule/
│   └── SpeakingTopicsModule/
├── LearnTab/                     # Learn tab feature modules
│   ├── LearnModule/              # Main Learn screen
│   ├── GrammarTopicsModule/      # Grammar topics list
│   ├── GrammarTestModule/        # Interactive tests
│   └── ListeningPracticeModule/  # Audio player
├── ProgressTab/                  # Progress tracking (placeholder)
├── ProfileTab/                   # User profile
├── AuthenticationModule/         # Sign in/Sign up
├── Managers/
│   ├── AudioRecorder.swift       # Recording audio
│   ├── AudioPlayerManager.swift  # Playing audio (AVPlayer)
│   ├── MockAuthManager.swift     # Authentication
│   ├── FlashCardStorage.swift    # Flash cards persistence
│   └── NetworkManager/           # API calls
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

## Implemented Features

All planned features have been implemented. See `IMPLEMENTATION_STATUS.md` for comprehensive details:

**✅ Phase 0: Tab Bar Infrastructure** - 4-tab navigation system
**✅ Phase 1: Flash Cards** - Vocabulary learning with flip animations
**✅ Phase 2: Grammar Tests** - Interactive quizzes (8 topics, 20+ questions each)
**✅ Phase 3: Listening Practice** - Audio player with playback controls
**✅ Phase 4 & 5: Authentication** - Sign in/Sign up with MockAuthManager

**Total:** 54 files, ~6,759 lines of code, 145+ unit tests

### Key Managers & Utilities

**Storage:**
- `FlashCardStorage`: UserDefaults-based persistence for flash cards
- `MockAuthManager`: In-memory authentication (ready for backend integration)

**Audio:**
- `AudioRecorder`: For recording user speech
- `AudioPlayerManager`: For playing learning materials

When adding new features, follow the established MVVM + Coordinator patterns and refer to existing modules for consistency.
