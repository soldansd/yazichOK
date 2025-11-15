# Phase 0: Tab Bar Navigation - Test Guide

## Automated Unit Tests

The file `TabNavigationTests.swift` contains comprehensive unit tests for:
- LearnCoordinator push/pop/popToRoot functionality
- HomeCoordinator integration (ensuring existing functionality works)
- LearnScreen enum Hashable conformance
- Edge cases (popping from empty path)

### Running Automated Tests

In Xcode:
1. Open `EnglishApp.xcodeproj`
2. Press `Cmd+U` to run all tests
3. Or right-click `TabNavigationTests.swift` and select "Run Tests"

Command line:
```bash
xcodebuild test -project EnglishApp.xcodeproj -scheme EnglishApp -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Manual UI Test Checklist

### Test 1: Tab Bar Visibility
- [ ] Launch the app
- [ ] Verify tab bar is visible at the bottom
- [ ] Verify 4 tabs are present: Home, Learn, Progress, Profile
- [ ] Verify each tab has the correct icon:
  - Home: house.fill
  - Learn: book.fill
  - Progress: trophy.fill
  - Profile: person.fill

### Test 2: Tab Selection Visual Feedback
- [ ] Tap on each tab
- [ ] Verify selected tab icon is highlighted in blue (.darkBlue)
- [ ] Verify unselected tabs are gray
- [ ] Verify tab labels are visible

### Test 3: Home Tab Navigation
- [ ] Tap Home tab
- [ ] Verify HomeView is displayed
- [ ] Verify "Speech Practice" card is visible
- [ ] Verify "Recommended Articles" section is visible (if articles loaded)
- [ ] Test navigation: tap "Start speaking"
- [ ] Verify navigation to topics list works
- [ ] Tap back button
- [ ] Verify return to HomeView

### Test 4: Learn Tab
- [ ] Tap Learn tab
- [ ] Verify LearnView is displayed
- [ ] Verify "Learn" title is visible
- [ ] Verify placeholder text "Coming soon: Grammar Tests and Listening Practice"
- [ ] Verify background color matches app theme (.appBackground)

### Test 5: Progress Tab
- [ ] Tap Progress tab
- [ ] Verify ProgressView is displayed
- [ ] Verify trophy icon is visible
- [ ] Verify "Progress" title is visible
- [ ] Verify "Track your learning journey" subtitle
- [ ] Verify "Coming soon" badge

### Test 6: Profile Tab
- [ ] Tap Profile tab
- [ ] Verify ProfileView is displayed
- [ ] Verify person icon is visible
- [ ] Verify "Profile" title is visible
- [ ] Verify "Manage your account and settings" subtitle
- [ ] Verify "Coming soon" badge

### Test 7: Tab Switching Persistence
- [ ] Navigate to different screens within Home tab
- [ ] Switch to Learn tab
- [ ] Switch back to Home tab
- [ ] Verify navigation state is preserved (still on the screen you left)

### Test 8: Visual Consistency
- [ ] Verify all tabs use the same background color (.appBackground)
- [ ] Verify tab bar styling matches screenshot
- [ ] Verify icon sizes are consistent
- [ ] Verify text styling is consistent across all placeholder screens

## Expected Results

All tests should pass with:
- ✅ Tab bar visible with 4 tabs
- ✅ Correct icons for each tab
- ✅ Proper color scheme (blue for selected, gray for unselected)
- ✅ Navigation working within Home tab
- ✅ Placeholder screens displaying correctly
- ✅ No crashes or console errors
- ✅ Tab switching is smooth and responsive

## Known Limitations (To be implemented in later phases)

- Learn tab: Full functionality coming in Phase 2 & 3
- Progress tab: Full functionality not yet planned
- Profile tab: Full functionality coming in Phase 4 & 5
