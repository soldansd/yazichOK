# Phase 3: Listening Practice - Manual Testing Guide

This guide provides step-by-step instructions for manually testing the Listening Practice feature implemented in Phase 3.

## Prerequisites

- App must be running on iOS Simulator or device
- User must be authenticated (signed in)
- Navigate to the **Learn** tab

## Test Scenarios

### 1. Navigate to Listening Practice

**Objective:** Test navigation from Learn screen to Listening Practice

**Steps:**
1. Open the app
2. Tap on the **Learn** tab
3. Tap on **"Listening Practice"** row

**Expected Results:**
- ✅ Navigation to "Listening Practice" screen occurs
- ✅ Screen title shows "Listening Practice"
- ✅ Back button appears in navigation bar
- ✅ Settings gear icon appears in top right
- ✅ Screen loads without errors

---

### 2. Listening Practice Screen Layout

**Objective:** Verify the screen displays all required elements

**Steps:**
1. Navigate to Listening Practice screen
2. Observe the layout

**Expected Results:**
- ✅ Progress section at top shows "Progress" label and "3/10" count
- ✅ Blue progress bar shows ~30% filled
- ✅ Audio Player Card is visible (white card)
- ✅ "Up Next" section heading is visible
- ✅ List of audio items is displayed
- ✅ Layout matches `Screenshots/ListeningPractice.png`

---

### 3. Audio Player Card Elements

**Objective:** Verify Audio Player Card displays correctly

**Steps:**
1. Observe the Audio Player Card

**Expected Results:**
- ✅ "Now Playing" label is displayed
- ✅ Audio title is shown (e.g., "Business Meeting Discussion")
- ✅ Circular indicator/icon is centered
- ✅ Progress bar (horizontal blue/grey bar)
- ✅ Time labels show "0:00" and total duration (e.g., "3:45")
- ✅ Three control buttons are visible:
  - Skip backward button (left)
  - Large blue circular Play button (center)
  - Skip forward button (right)
- ✅ White card with rounded corners and shadow

---

### 4. Initial Audio Loading

**Objective:** Test that first unlocked audio loads automatically

**Steps:**
1. Navigate to Listening Practice screen for the first time
2. Observe which audio is loaded

**Expected Results:**
- ✅ First unlocked audio is auto-selected
- ✅ Audio title appears in "Now Playing"
- ✅ Duration is displayed
- ✅ Play button is ready (not disabled)
- ✅ Loading indicator may briefly appear

---

### 5. Play Audio

**Objective:** Test play functionality

**Steps:**
1. Tap the blue **Play button** in the center

**Expected Results:**
- ✅ Button changes to Pause icon
- ✅ Progress bar starts filling from left to right
- ✅ Current time label increments (0:00, 0:01, 0:02, etc.)
- ✅ Waveform icon may animate
- ✅ Audio playback begins (if audio files exist) OR
- ✅ Mock playback progresses (in development mode)

---

### 6. Pause Audio

**Objective:** Test pause functionality

**Steps:**
1. While audio is playing, tap the **Pause button**

**Expected Results:**
- ✅ Button changes back to Play icon
- ✅ Progress bar stops moving
- ✅ Current time label stops incrementing
- ✅ Playback pauses at current position

---

### 7. Progress Bar Updates

**Objective:** Verify progress bar reflects playback accurately

**Steps:**
1. Play audio for 30 seconds
2. Observe the progress bar

**Expected Results:**
- ✅ Blue portion of bar increases proportionally
- ✅ Bar fills based on currentTime/duration ratio
- ✅ At 50% of duration, bar should be ~50% filled
- ✅ Progress is smooth and continuous

---

### 8. Time Display Updates

**Objective:** Test time labels update correctly

**Steps:**
1. Play audio and observe time labels

**Expected Results:**
- ✅ Left label (current time) updates every second
- ✅ Right label (total duration) remains constant
- ✅ Format is "M:SS" (e.g., "1:23", "3:45")
- ✅ Current time never exceeds duration
- ✅ Times are synchronized with progress bar

---

### 9. Skip Backward

**Objective:** Test skip backward functionality

**Steps:**
1. Play audio for 20 seconds
2. Tap the **Skip backward button** (left button)

**Expected Results:**
- ✅ Current time decreases by 10 seconds
- ✅ Progress bar position updates accordingly
- ✅ Playback continues from new position (if was playing)
- ✅ Cannot skip before 0:00 (stays at 0:00)

---

### 10. Skip Forward

**Objective:** Test skip forward functionality

**Steps:**
1. Play audio from the beginning
2. Tap the **Skip forward button** (right button)

**Expected Results:**
- ✅ Current time increases by 10 seconds
- ✅ Progress bar position updates accordingly
- ✅ Playback continues from new position (if was playing)
- ✅ Cannot skip beyond duration (stops at max time)

---

### 11. Multiple Skip Operations

**Objective:** Test multiple skip operations in sequence

**Steps:**
1. Skip forward 3 times
2. Skip backward 2 times
3. Observe the behavior

**Expected Results:**
- ✅ Each skip operation works correctly
- ✅ Time and progress bar stay synchronized
- ✅ No crashes or UI glitches
- ✅ Final position is correct (30 seconds forward - 20 back = +10s)

---

### 12. Up Next List Display

**Objective:** Verify the audio list displays correctly

**Steps:**
1. Scroll to the "Up Next" section
2. Observe the list items

**Expected Results:**
- ✅ "Up Next" heading is visible
- ✅ Multiple audio items are listed
- ✅ Each item shows:
  - Speaker/volume icon on left
  - Audio title
  - Duration (e.g., "4:30 mins")
  - Lock icon on right (if locked)
- ✅ Items are in white rounded cards
- ✅ List is scrollable if needed

---

### 13. Audio List Item Selection

**Objective:** Test selecting a different audio from the list

**Steps:**
1. Scroll to "Up Next" section
2. Tap on an unlocked audio item (e.g., "Travel Dialogue")

**Expected Results:**
- ✅ Selected audio loads in the player card
- ✅ "Now Playing" title updates to new audio
- ✅ Duration updates to new audio's duration
- ✅ Progress resets to 0:00
- ✅ Previously playing audio pauses
- ✅ Selected item may have visual highlight

---

### 14. Locked Audio Behavior

**Objective:** Test that locked audio cannot be played

**Steps:**
1. Identify an audio item with a lock icon
2. Tap on the locked item

**Expected Results:**
- ✅ Audio does NOT load
- ✅ Current audio continues to be displayed
- ✅ No error message displayed (graceful handling)
- ✅ Lock icon remains visible
- ✅ Item may appear dimmed/disabled

---

### 15. Locked vs Unlocked Audio

**Objective:** Verify visual distinction between locked and unlocked

**Steps:**
1. Compare locked and unlocked items in the list

**Expected Results:**
- ✅ Locked items have lock icon
- ✅ Locked items may be slightly faded/dimmed
- ✅ Unlocked items have no lock icon
- ✅ Unlocked items respond to taps
- ✅ At least some items are unlocked

---

### 16. Progress Counter

**Objective:** Test the overall progress counter at top

**Steps:**
1. Observe the progress counter "3/10"
2. Check the progress bar beneath it

**Expected Results:**
- ✅ Shows completed count / total count format
- ✅ "3/10" indicates 3 out of 10 audios completed
- ✅ Blue progress bar shows ~30% filled
- ✅ Counter is static (doesn't change during playback)
- ✅ Represents overall learning progress

---

### 17. Playback Reaches End

**Objective:** Test behavior when audio finishes playing

**Steps:**
1. Skip forward to near the end of an audio
2. Let it play to completion

**Expected Results:**
- ✅ Playback stops when reaching duration
- ✅ Play button reappears (changes from Pause)
- ✅ Progress bar is fully filled
- ✅ Time shows max duration on both sides OR
- ✅ Current time resets to 0:00
- ✅ No automatic play of next audio

---

### 18. Screen Navigation Away

**Objective:** Test behavior when leaving the screen

**Steps:**
1. Start playing an audio
2. Tap the back button to return to Learn screen

**Expected Results:**
- ✅ Navigation back to Learn screen succeeds
- ✅ Audio playback pauses automatically
- ✅ No audio continues playing in background

---

### 19. Return to Listening Practice

**Objective:** Test state when returning to screen

**Steps:**
1. Navigate away from Listening Practice
2. Return to Listening Practice

**Expected Results:**
- ✅ Screen loads correctly
- ✅ Audio state may be reset (starts fresh)
- ✅ First audio is loaded again
- ✅ No playback continues from before

---

### 20. Settings Button

**Objective:** Test the settings gear icon

**Steps:**
1. Tap the **Settings** gear icon in top right

**Expected Results:**
- ✅ Button is visible and tappable
- ✅ Currently shows placeholder behavior (future feature)
- ✅ No errors or crashes

---

### 21. Multiple Audio Selections

**Objective:** Test switching between multiple audios

**Steps:**
1. Play first audio for 10 seconds
2. Select second audio from list
3. Play for 5 seconds
4. Select third audio

**Expected Results:**
- ✅ Each audio loads correctly
- ✅ Previous audio stops when new one is selected
- ✅ Each audio starts from beginning
- ✅ No overlap or mixing of audio
- ✅ UI updates correctly for each audio

---

### 22. UI Responsiveness

**Objective:** Test UI responds to rapid interactions

**Steps:**
1. Rapidly tap play/pause multiple times
2. Quickly tap skip forward/backward buttons
3. Switch between audio items quickly

**Expected Results:**
- ✅ No crashes or freezes
- ✅ UI responds to all taps
- ✅ State remains consistent
- ✅ No visual glitches
- ✅ Buttons don't become unresponsive

---

### 23. Visual Design Compliance

**Objective:** Ensure design matches screenshot

**Steps:**
1. Compare screen to `Screenshots/ListeningPractice.png`

**Expected Results:**
- ✅ Overall layout matches
- ✅ Colors match (blue for primary, grey for secondary)
- ✅ Font sizes and weights are consistent
- ✅ Spacing and padding match design
- ✅ Card shadows and corners match
- ✅ Icon sizes and styles match

---

### 24. Duration Formatting

**Objective:** Verify all durations display correctly

**Steps:**
1. Observe duration labels in the list
2. Check time labels in player card

**Expected Results:**
- ✅ Format is "M:SS mins" for minutes (e.g., "4:30 mins")
- ✅ Format is "SS secs" for under 1 minute (if any)
- ✅ All durations are readable and accurate
- ✅ No negative durations
- ✅ No formatting errors

---

### 25. Audio Categories

**Objective:** Verify audio materials cover different categories

**Steps:**
1. Review the list of available audio

**Expected Results:**
- ✅ Multiple categories represented (Business, Travel, News, etc.)
- ✅ Variety of difficulty levels
- ✅ Range of durations (short and long)
- ✅ At least 8-10 different audio materials
- ✅ Mix of locked and unlocked content

---

## Test Summary Checklist

After completing all test scenarios, verify:

- [ ] Navigation to Listening Practice works
- [ ] Screen layout matches design screenshot
- [ ] Audio Player Card displays all elements
- [ ] Auto-load of first audio works
- [ ] Play/Pause functionality works
- [ ] Progress bar updates during playback
- [ ] Time labels update correctly
- [ ] Skip backward/forward work (10 seconds)
- [ ] Audio list displays correctly
- [ ] Can select unlocked audio from list
- [ ] Locked audio cannot be played
- [ ] Progress counter shows overall progress
- [ ] Playback stops at end of audio
- [ ] Audio pauses when leaving screen
- [ ] Multiple audio selections work
- [ ] UI is responsive to interactions
- [ ] Design matches provided screenshot
- [ ] No crashes or errors occur

## Known Limitations

- Audio files are mocked (no actual audio playback unless files exist in bundle)
- Progress counter (3/10) is static/mocked
- Settings button is a placeholder
- Completed audio tracking not implemented
- Auto-advance to next audio not implemented
- Volume control not implemented
- Playback speed control not implemented

## Next Steps

After manual testing is complete:
1. Run automated unit tests: `Cmd+U` in Xcode
2. Verify all 30+ test cases pass
3. Check integration with AudioPlayerManager
4. Report any bugs or issues found
