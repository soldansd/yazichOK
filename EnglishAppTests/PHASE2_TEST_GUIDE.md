# Phase 2: Grammar Tests - Manual Testing Guide

This guide provides step-by-step instructions for manually testing the Grammar Tests feature implemented in Phase 2.

## Prerequisites

- App must be running on iOS Simulator or device
- User must be authenticated (signed in)
- Navigate to the **Learn** tab

## Test Scenarios

### 1. Learn Screen Layout

**Objective:** Verify the Learn screen displays correctly

**Steps:**
1. Open the app
2. Tap on the **Learn** tab in the bottom tab bar

**Expected Results:**
- ✅ Header displays with user greeting (e.g., "Hello, John!")
- ✅ Subtitle shows "Intermediate Level"
- ✅ Profile icon appears on the left
- ✅ Notification bell icon appears on the right
- ✅ Three list rows are visible:
  - "Listening Practice" (with chevron)
  - "Tests" (with chevron)
  - "AI Chat Assistance" (with chevron)
- ✅ Layout matches the design in `Screenshots/Learn.png`

---

### 2. Navigate to Grammar Topics

**Objective:** Test navigation from Learn screen to Grammar Topics list

**Steps:**
1. On the Learn screen, tap on **"Tests"** row

**Expected Results:**
- ✅ Navigation to "Grammar Tests" screen occurs
- ✅ Screen title shows "Grammar Tests"
- ✅ Back button appears in navigation bar
- ✅ List of grammar topics is displayed
- ✅ Each topic shows:
  - Topic name
  - Question count (e.g., "20 questions")
  - Chevron on the right

---

### 3. Grammar Topics List Content

**Objective:** Verify grammar topics are loaded correctly

**Steps:**
1. Navigate to Grammar Topics screen
2. Scroll through the list

**Expected Results:**
- ✅ At least 8 topics are displayed:
  - Present Simple
  - Past Simple
  - Present Continuous
  - Future Simple
  - Articles (a, an, the)
  - Prepositions
  - Modal Verbs
  - Conditionals
- ✅ Each topic has a question count
- ✅ Topics are displayed in a white card with dividers

---

### 4. Start a Grammar Test

**Objective:** Test starting a test for a specific topic

**Steps:**
1. On Grammar Topics screen, tap on **"Present Simple"**

**Expected Results:**
- ✅ Navigation to test screen
- ✅ Navigation bar shows "Present Simple"
- ✅ Score counter "0/20" appears in top right with trophy icon
- ✅ Green progress bar appears at the top (showing ~5% progress for question 1)
- ✅ Question number displays: "Question 1 of 20"
- ✅ Question text is displayed
- ✅ Four answer options are shown in white rounded rectangles
- ✅ No answer is selected initially
- ✅ No "Check" button is visible (disabled state)

---

### 5. Select an Answer

**Objective:** Test answer selection functionality

**Steps:**
1. On the test screen, tap on the first answer option

**Expected Results:**
- ✅ Selected answer has a light green background
- ✅ Selected answer has a green border
- ✅ Green checkmark appears on the right of selected option
- ✅ "Check" button appears and is enabled (dark blue)
- ✅ Can change selection by tapping another option

---

### 6. Check Correct Answer

**Objective:** Test checking a correct answer

**Steps:**
1. Select the correct answer (for question 1, "goes" is correct)
2. Tap the **"Check"** button

**Expected Results:**
- ✅ Result card appears at the bottom with light green background
- ✅ Green checkmark icon is shown
- ✅ "Correct!" text is displayed in green
- ✅ Explanation text appears in dark green
- ✅ Green "Continue" button is shown
- ✅ Selected answer maintains green border
- ✅ Other options are greyed out
- ✅ Cannot change answer selection
- ✅ Layout matches `Screenshots/Test.png`

---

### 7. Check Incorrect Answer

**Objective:** Test checking an incorrect answer

**Steps:**
1. Navigate to a new question (by continuing from previous)
2. Select an incorrect answer
3. Tap the **"Check"** button

**Expected Results:**
- ✅ Result card appears with light red/pink background
- ✅ Red X icon is shown
- ✅ "Incorrect" text is displayed in red
- ✅ Explanation text appears (explaining the correct answer)
- ✅ Red "Continue" button is shown
- ✅ Other options are greyed out

---

### 8. Progress Through Questions

**Objective:** Test continuing to next questions

**Steps:**
1. Answer a question and check it
2. Tap the **"Continue"** button
3. Repeat for several questions

**Expected Results:**
- ✅ Next question loads immediately
- ✅ Question number increments: "Question 2 of 20", "Question 3 of 20", etc.
- ✅ Progress bar fills proportionally (10% for Q2, 15% for Q3, etc.)
- ✅ Score counter updates when answers are correct (e.g., "1/20", "2/20")
- ✅ Previous answer is not shown
- ✅ New question has no selected answer
- ✅ Result card disappears
- ✅ State resets for each new question

---

### 9. Score Tracking

**Objective:** Verify score is tracked correctly

**Steps:**
1. Start a test
2. Answer first 5 questions (mix of correct and incorrect)
3. Observe the score counter in top right

**Expected Results:**
- ✅ Score shows "X/20" format
- ✅ X increments only for correct answers
- ✅ Denominator stays at total question count
- ✅ Trophy icon remains green

---

### 10. Progress Bar Accuracy

**Objective:** Test progress bar fills correctly

**Steps:**
1. Start a test with 20 questions
2. Answer questions and observe progress bar

**Expected Results:**
- ✅ At question 1: ~5% filled
- ✅ At question 10: ~50% filled
- ✅ At question 20: 100% filled
- ✅ Progress bar is green
- ✅ Fills smoothly from left to right

---

### 11. Complete Test - Summary Screen

**Objective:** Test the summary screen after completing all questions

**Steps:**
1. Answer all 20 questions in a test
2. After the last question, tap **"Continue"**

**Expected Results:**
- ✅ Summary screen appears
- ✅ Trophy or checkmark icon is shown (gold trophy if score ≥70%, green checkmark otherwise)
- ✅ Result message displays:
  - "Excellent work!" (90-100%)
  - "Great job!" (70-89%)
  - "Good effort!" (50-69%)
  - "Keep practicing!" (<50%)
- ✅ Topic name is shown
- ✅ Score percentage is displayed (e.g., "80%")
- ✅ Statistics card shows:
  - Green checkmark with "Correct answers: X"
  - Red X with "Incorrect answers: Y"
  - "Total questions: 20"
- ✅ "Done" button is visible (dark blue)

---

### 12. Close Summary Screen

**Objective:** Test navigation from summary back to topics

**Steps:**
1. Complete a test to reach summary screen
2. Tap the **"Done"** button

**Expected Results:**
- ✅ Navigation back to Grammar Topics screen
- ✅ Can start another test
- ✅ Previous test state is not persisted

---

### 13. Back Navigation During Test

**Objective:** Test back button behavior during a test

**Steps:**
1. Start a test
2. Answer 5 questions
3. Tap the back button in navigation bar

**Expected Results:**
- ✅ Navigation back to Grammar Topics screen
- ✅ Test progress is not saved
- ✅ Starting the same test again starts from question 1

---

### 14. Different Topics

**Objective:** Test that different topics load different questions

**Steps:**
1. Start "Present Simple" test, note the first question
2. Go back
3. Start "Past Simple" test, note the first question

**Expected Results:**
- ✅ Questions are different between topics
- ✅ Each topic has appropriate questions
- ✅ Question count may vary (Present Simple: 20, Past Simple: 15, etc.)

---

### 15. UI Responsiveness

**Objective:** Test UI responds correctly to user interactions

**Steps:**
1. Navigate through the entire flow quickly
2. Tap buttons rapidly
3. Try to select answers while result is showing

**Expected Results:**
- ✅ No crashes or freezes
- ✅ Cannot select new answers after checking
- ✅ Cannot tap "Check" button twice
- ✅ Transitions are smooth
- ✅ No UI glitches or overlapping elements

---

### 16. Long Text Handling

**Objective:** Test that long questions and answers display correctly

**Steps:**
1. Navigate through questions to find ones with long text
2. Check formatting of questions and options

**Expected Results:**
- ✅ Long question text wraps properly
- ✅ Answer options wrap if text is long
- ✅ No text is cut off
- ✅ Cards adjust height as needed
- ✅ Explanation text in result card is fully visible

---

### 17. Multiple Test Sessions

**Objective:** Test taking multiple tests in sequence

**Steps:**
1. Complete a full test for "Present Simple"
2. Tap "Done" on summary
3. Select "Articles (a, an, the)" topic
4. Complete that test

**Expected Results:**
- ✅ Each test is independent
- ✅ Scores don't carry over
- ✅ Questions are specific to each topic
- ✅ Progress resets for new test

---

### 18. Navigation Bar Elements

**Objective:** Verify all navigation elements work

**Steps:**
1. Navigate through: Learn → Grammar Topics → Test
2. Check navigation bar at each level

**Expected Results:**
- ✅ Learn screen: No navigation bar (custom header)
- ✅ Grammar Topics: Title "Grammar Tests", back button
- ✅ Test screen: Topic name, back button, score with trophy
- ✅ Back button returns to previous screen

---

### 19. Color Scheme Consistency

**Objective:** Ensure colors match the design system

**Steps:**
1. Review all screens in the Grammar Tests flow

**Expected Results:**
- ✅ Background: Light grey (.appBackground)
- ✅ Cards: White with rounded corners
- ✅ Selected answer: Light green background and green border
- ✅ Correct result: Green theme
- ✅ Incorrect result: Red theme
- ✅ Progress bar: Green
- ✅ Buttons: Dark blue for primary actions
- ✅ Trophy icon: Green

---

### 20. Accessibility

**Objective:** Test basic accessibility features

**Steps:**
1. Navigate through the flow
2. Check text sizes and contrast

**Expected Results:**
- ✅ All text is readable
- ✅ Buttons have clear labels
- ✅ Touch targets are large enough (minimum 44x44 points)
- ✅ Color is not the only indicator (icons accompany colors)

---

## Test Summary Checklist

After completing all test scenarios, verify:

- [ ] Learn screen displays correctly with all elements
- [ ] Navigation works throughout the entire flow
- [ ] Grammar topics load and display properly
- [ ] Questions load for each topic
- [ ] Answer selection works correctly
- [ ] Checking answers provides proper feedback
- [ ] Correct/incorrect results display appropriately
- [ ] Progress bar updates accurately
- [ ] Score counter increments correctly
- [ ] Summary screen shows after test completion
- [ ] Statistics are calculated correctly
- [ ] Multiple tests can be taken in sequence
- [ ] Back navigation works at all levels
- [ ] UI matches the provided screenshots
- [ ] No crashes or errors occur

## Known Limitations

- Test progress is not persisted (restarting a test starts from question 1)
- AI Chat Assistance and Listening Practice are placeholder features
- User level ("Intermediate Level") is hardcoded
- No network integration (all data is mocked locally)

## Next Steps

After manual testing is complete:
1. Run automated unit tests: `Cmd+U` in Xcode
2. Verify all 30+ test cases pass
3. Check code coverage if needed
4. Report any bugs or issues found
