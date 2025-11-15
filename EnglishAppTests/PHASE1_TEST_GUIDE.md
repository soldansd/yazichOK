# Phase 1: Flash Cards Feature - Test Guide

## Automated Unit Tests

The file `FlashCardsTests.swift` contains comprehensive unit tests for:
- Data models (FlashCard, WordGroup, ReviewSession)
- FlashCardStorage CRUD operations
- ReviewSession logic (flip, mark as known/unknown, completion)
- AddWordViewModel validation
- Screen enum integration
- Card counting (new cards, review cards)

### Running Automated Tests

In Xcode:
1. Open `EnglishApp.xcodeproj`
2. Press `Cmd+U` to run all tests
3. Or right-click `FlashCardsTests.swift` and select "Run Tests"

Command line:
```bash
xcodebuild test -project EnglishApp.xcodeproj -scheme EnglishApp -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Manual UI Test Checklist

### Test 1: Home Screen - Flashcards Card
- [ ] Launch the app and navigate to Home tab
- [ ] Verify Flashcards card is visible (purple/pastel purple background)
- [ ] Verify "Flashcards" title is bold
- [ ] Verify "Review your vocabulary" subtitle
- [ ] Verify gear icon on the right
- [ ] Verify "X new" badge is displayed (purple background)
- [ ] Verify "X to review" badge is displayed (purple background)
- [ ] Tap the Flashcards card
- [ ] Verify navigation to Flashcards main screen

### Test 2: Flashcards Main Screen
- [ ] Verify navigation title "Flashcards"
- [ ] Verify plus icon in top-left toolbar
- [ ] Verify back button in top-right toolbar
- [ ] Verify list of word groups is displayed
- [ ] Verify each group shows folder icon and word count
- [ ] Verify floating action button (folder with plus) in bottom-right
- [ ] Tap a word group
- [ ] Verify navigation to MemoriseWords screen

### Test 3: Add New Group
- [ ] From Flashcards main screen, tap floating action button
- [ ] Verify "New Group" navigation title
- [ ] Verify "Group Name" label and text field
- [ ] Verify "Save" button is disabled when field is empty
- [ ] Enter group name (e.g., "Technology")
- [ ] Verify "Save" button becomes enabled
- [ ] Tap "Save"
- [ ] Verify navigation back to Flashcards screen
- [ ] Verify new group appears in the list

### Test 4: Add New Word
- [ ] From Flashcards main screen, tap plus icon in toolbar
- [ ] Verify "New Word" navigation title
- [ ] Verify all input fields:
   - [ ] Word field
   - [ ] Translation field
   - [ ] Example sentence field (multiline)
   - [ ] Pronunciation field (with speaker icon)
   - [ ] Category selector (shows selected group)
   - [ ] Difficulty level buttons (Easy, Medium, Hard)
- [ ] Verify "Add to My Words" button is disabled initially
- [ ] Fill in Word: "Adventure"
- [ ] Fill in Translation: "Приключение"
- [ ] Verify button still disabled (need category)
- [ ] Select category from menu
- [ ] Verify "Add to My Words" button becomes enabled
- [ ] Optionally fill pronunciation: "[ədˈventʃər]"
- [ ] Select difficulty: Medium
- [ ] Tap "Add to My Words"
- [ ] Verify navigation back to previous screen
- [ ] Verify word was added (check storage)

### Test 5: Difficulty Level Selection
- [ ] From Add New Word screen
- [ ] Tap "Easy" button
- [ ] Verify Easy button has green background (.pastelGreen)
- [ ] Verify other buttons are gray
- [ ] Tap "Medium" button
- [ ] Verify Medium button has orange background (.pastelOrange)
- [ ] Tap "Hard" button
- [ ] Verify Hard button has red background (.pastelRed)

### Test 6: Memorise Words - Card Display
- [ ] From Flashcards main, tap a group with cards
- [ ] Verify "Words Review" navigation title
- [ ] Verify progress indicator shows "X words left"
- [ ] Verify blue progress bar
- [ ] Verify flash card displays:
   - [ ] "English" label at top
   - [ ] Word in large font (e.g., "Adventure")
   - [ ] Pronunciation below word (if available)
   - [ ] "Tap to flip" text with refresh icon at bottom
- [ ] Verify two action buttons below card:
   - [ ] "Don't know" (red/pink background)
   - [ ] "Know" (green background)
- [ ] Verify statistics bar at bottom:
   - [ ] Time (clock icon)
   - [ ] Correct count (green checkmark)
   - [ ] Wrong count (red X)

### Test 7: Memorise Words - Card Flip
- [ ] Tap on the flash card
- [ ] Verify card flips with 3D rotation animation
- [ ] Verify back side shows:
   - [ ] Translation in large font
   - [ ] Example sentence (if available)
   - [ ] No "Tap to flip" text
- [ ] Tap card again
- [ ] Verify card flips back to front side
- [ ] Verify word is displayed again

### Test 8: Memorise Words - Mark as Known
- [ ] Display a flash card
- [ ] Tap "Know" button
- [ ] Verify card advances to next word
- [ ] Verify progress bar updates
- [ ] Verify "X words left" decreases by 1
- [ ] Verify "Correct" count increases by 1
- [ ] Verify card is no longer showing translation

### Test 9: Memorise Words - Mark as Unknown
- [ ] Display a flash card
- [ ] Tap "Don't know" button
- [ ] Verify card advances to next word
- [ ] Verify progress bar updates
- [ ] Verify "X words left" decreases by 1
- [ ] Verify "Wrong" count increases by 1

### Test 10: Memorise Words - Session Complete
- [ ] Answer all cards in a group
- [ ] Verify statistics screen displays:
   - [ ] Green checkmark icon
   - [ ] "Session Complete!" title
   - [ ] Correct count (large, green)
   - [ ] Wrong count (large, red)
   - [ ] Total time
   - [ ] "Review Again" button
   - [ ] "Back to Home" button
- [ ] Tap "Review Again"
- [ ] Verify session restarts with same cards
- [ ] Complete session again, tap "Back to Home"
- [ ] Verify navigation to home screen

### Test 11: Delete Group (Context Menu)
- [ ] From Flashcards main screen
- [ ] Long-press on a word group
- [ ] Verify context menu appears
- [ ] Verify "Delete" option with trash icon
- [ ] Tap "Delete"
- [ ] Verify group is removed from list
- [ ] Verify associated cards are also deleted

### Test 12: Data Persistence
- [ ] Add a new group
- [ ] Add cards to the group
- [ ] Close the app completely
- [ ] Relaunch the app
- [ ] Navigate to Flashcards
- [ ] Verify groups and cards are still present
- [ ] Verify counts are correct

### Test 13: Empty State
- [ ] Delete all word groups
- [ ] Verify empty state displays:
   - [ ] Folder with plus icon
   - [ ] "No word groups yet" message
   - [ ] "Create a group to start adding flashcards" subtitle
   - [ ] "Create First Group" button
- [ ] Tap "Create First Group"
- [ ] Verify navigation to Add New Group screen

### Test 14: Visual Consistency
- [ ] Verify all screens use .appBackground color
- [ ] Verify purple theme colors (.darkPurple, .pastelPurple)
- [ ] Verify difficulty colors (green, orange, red)
- [ ] Verify button styles are consistent
- [ ] Verify card shadows and rounded corners
- [ ] Verify navigation bar styling

## Expected Results

All tests should pass with:
- ✅ Flashcards card visible on Home screen with correct design
- ✅ Word groups list with proper styling
- ✅ Add group/word functionality working
- ✅ Flash card flip animation smooth
- ✅ Progress tracking accurate
- ✅ Statistics display correct
- ✅ Data persists across app restarts
- ✅ No crashes or console errors
- ✅ All UI matches screenshots

## Performance Expectations

- Card flip animation should be smooth (60 FPS)
- Navigation transitions should be instant
- Data loading should be fast (< 100ms)
- No memory leaks during card review sessions
