I have created an iOS SwiftUI application for English learners.
The project already includes several functional modules:

### **Current Functionality**

1. **Speech Assessment Module**

   * `SpeakingTopicsView`: selection of topic for assessment
   * `RecordingView`: recording audio responses
   * `SpeakingAssessmentView`: displaying assessment results

2. **Articles Module**

   * `ArticlesPreviewView`: list of articles
   * `ArticleView`: full article
   * `ArticleAnalysisView`: analysis of a selected article

3. **Architecture & Technologies**

   * MVVM + Coordinator pattern implemented with `NavigationStack` and `path`
   * Managers:

     * `NetworkManager` (DTOs from network layer mapped to business logic)
     * `AudioRecorder`
   * Network requests implemented with **Alamofire**
   * Animations implemented with **Lottie**

For new features, use **mock network interactions** with the ability to easily replace them with real network requests.

---

## **Task 1: Implement Flash Cards Feature**

### **Main Screen**

Add a new UI element on the main screen (purple element on `Screenshots/MainScreen.png`).
Tapping this element should open a new **FlashCards** screen.

---

## **FlashCards Module Structure**

### **1. FlashCards Main Screen**

Requirements:

* Add a `ToolbarItem` on the `.topLeading` edge with a **plus icon**.

  * Tapping it opens **AddNewWord** screen.
* Add an overlay button:

  * Alignment: `.bottomTrailing`
  * Small circular button with a **folder icon**
  * Tapping it opens **AddNewWordsGroup** screen
* Display a **list of word groups** (e.g., Travel, Education, Cafe, etc.).

  * Tapping a group opens **MemoriseWords** screen
  * Only words belonging to the selected group should be shown there

### **2. AddNewWord Screen**

Design reference: `Screenshots/AddNewWord.png`
Fields required:

* Word to memorise
* Transcription
* Translation to the user’s language
* Selector for choosing the **group** to which this word will be added

### **3. AddNewWordsGroup Screen**

A simple screen with:

* Text field to enter a new group name
* Save button

### **4. MemoriseWords Screen and Logic**

Design reference: `Screenshots/MemoriseWords.png`

Functionality:

* Display a **single flash card** showing:

  * Word
  * Transcription
  * Button to reveal translation
* Below the card:

  * HStack with buttons:

    * “Don’t Know”
    * “Know”
* After tapping either button, show the **next word** in the selected group
* After all words are shown:

  * Display statistics:

    * How many words the user knew
    * How many they did not know

---

## **Task 2: Grammar Tests**

### **Overview**

We need to add a new learning module accessible through a new tab bar item named **“Learn”**.
The feature includes:

* A Learn screen with two rows
* A Grammar Tests list
* A Test screen with interactive question flow
* End-of-test statistics

Design references are in:

* `Screenshots/Learn.png`
* `Screenshots/Test.png`

---

## **1. Tab Bar**

Add a new item to the tab bar:

* **Title:** “Learn”
* **Icon:** (use any appropriate learning/education icon)
* Tapping this item should open the new **Learn** screen.

---

## **2. Learn Screen**

Design reference: `Screenshots/Learn.png`

The screen must contain a list with **two rows**:

1. **Listening Practice**
2. **Tests**

For now, Task 2 covers only the **Tests** row behavior.

* **Tap on “Tests” row → open Grammar Topics screen**

---

## **3. Grammar Topics List Screen**

A screen displaying a list of grammar topics for tests (e.g., “Articles”, “Tenses”, “Prepositions”, etc. — actual topics can be mocked).

* Tapping any topic leads to the **Test Screen** for that topic.
* Use mock data for topics and test questions.

---

## **4. Test Screen**

Design reference: `Screenshots/Test.png`

### **UI Structure**

The screen should display:

1. **Test Card** (main question card)

   * Text of the grammar question/task
   * A list of answer options (one-choice answers)

2. **Check Button**

   * Enabled only after the user selects one of the answers

3. **Result Card** (appears after checking)

   * Indicates whether the selected answer is **Correct** or **Incorrect**
   * Shows the correct answer if the user was wrong
   * Contains a **Continue** button

---

## **5. Test Logic**

### **Answering workflow**

1. User reads the question on the card

2. User selects one of the answer options

3. User taps **Check**

4. A result card appears beneath the question card:

   * Styled as in the mock design
   * Shows:

     * Correct / Incorrect indicator
     * (Optional) Explanation or the correct answer

5. User taps **Continue**

   * Show the **next question** from the same topic
   * Reset UI state for the next question (no result until Check is tapped again)

### **End of Test**

When all questions for the topic are answered:

* The Continue button should lead to a **Summary card**
* Summary must show:

  * How many questions were answered correctly
  * How many were answered incorrectly

---

## **Task 3: Listening Practice**

### **Overview**

This task implements the **Listening Practice** option from the Learn screen.
It introduces a **ListeningPractice** screen where users can browse audio materials and play them directly from a playback card integrated on the same screen.

Design reference: `Screenshots/ListeningPractice.png`

Initially, audio files are stored **locally on the device**, but the architecture must allow replacing them with network-sourced audio in the future.

---

## **1. ListeningPractice Screen**

### **Entry Point**

* Tapping **Listening Practice** on the Learn screen opens the **ListeningPractice** screen.

### **UI Layout**

* **Audio Player Card (top of the screen)**

  * Displays the currently selected audio recording.
  * Provides full playback controls (Play/Pause, Seek Backward, Seek Forward).
  * Shows audio progress and timestamps.

* **List of Audio Records (bottom of the screen)**

  * Scrollable list of available audio recordings (mocked locally for now).
  * Each item displays:

    * Title of the audio (e.g., “Travel Dialogue 1”, “Shopping Listening Exercise 2”)
    * Optional: Duration or difficulty level.
  * Tapping a list item updates the **Audio Player Card** with the selected audio.

---

## **2. Audio Player Card**

### **Functionality**

The Audio Player Card must support:

* Play / Pause of the selected audio
* Seek backward by 10 seconds
* Seek forward by 10 seconds
* Show current playback time and remaining duration
* Optional: a progress bar (scrubber) to indicate playback position

### **Technical Notes**

* Use **AVFoundation** (`AVAudioPlayer` or `AVPlayer`) for audio playback.
* Audio management must handle:

  * Loading local audio files
  * Observing playback state
  * Seeking accurately
* The architecture should support switching from local files to remote URLs through a network manager with minimal changes.

---

### **3. Behavior**

1. When the screen opens, the **Audio Player Card** shows the first or last-selected audio.
2. The user scrolls through the list of audio recordings at the bottom.
3. Tapping an item in the list updates the **Audio Player Card** with that audio.
4. Playback controls operate entirely within the **Audio Player Card**.
5. All playback state and timing updates are reflected in real time on the card.
6. The system is prepared for future integration with a network audio source.

---

## **Task 4: Sign In Screen**

### **Overview**

Implement the **Sign In** screen for user authentication.
Design reference: `Screenshots/SignIn.png`.

The screen includes:

* Email input field
* Password input field
* Sign In button
* A navigation text leading to the Sign Up screen

Authentication will be mocked for now, with a future option to integrate with real backend services.

---

## **1. SignIn Screen**

### **UI Requirements**

Based on the design (`Screenshots/SignIn.png`), the screen should include:

1. **Email Text Field**

   * Placeholder: “Email”
   * Validation: check for valid email format (can be simplified for mock phase)

2. **Password Text Field**

   * Placeholder: “Password”
   * Secure entry enabled
   * Optional: “Show/Hide” toggle

3. **Sign In Button**

   * Disabled until both fields have valid input
   * On tap, perform authentication through a mock AuthManager

4. **Sign Up Navigation Text**

   * Text like:
     *“Don’t have an account? Sign up”*
   * “Sign up” should be tappable and lead to the **SignUp screen** (to be implemented later)

### **Behaviour**

* On Sign In:

  * Validate inputs
  * Trigger mock authentication logic

    * If success: navigate to the main app flow
    * If failure: show a simple error message (e.g., “Invalid credentials”)
* Navigation:

  * Tap on “Sign up” → open **SignUp** screen

### **Authentication Logic**

For now:

* Use a **MockAuthManager** with in-memory mocked users
* Allow replacing with real API integration in the future
* Manager should provide:

  * `signIn(email, password)`
  * Error handling
  * Basic session state storage (mock)

---

## **Task 5: Sign Up Screen**

### **Overview**

Implement the **Sign Up** screen that allows new users to create an account.
Design reference: `Screenshots/SignUp.png`.

The screen includes:

* Email field
* Password field
* Repeat password field
* Sign Up button
* Text that navigates back to the previously implemented **Sign In** screen

As with Task 4, authentication should be implemented using **mock logic**, but structured so it can easily be replaced with real backend services.

---

## **1. SignUp Screen**

### **UI Requirements**

Based on the design (`Screenshots/SignUp.png`), the screen should include:

1. **Email Text Field**

   * Placeholder: “Email”
   * Basic email format validation

2. **Password Text Field**

   * Placeholder: “Password”
   * Secure text entry
   * Optional: visibility toggle

3. **Repeat Password Text Field**

   * Placeholder: “Repeat password”
   * Secure text entry
   * Must match the first password field

4. **Sign Up Button**

   * Disabled until:

     * Email is valid
     * Password is not empty
     * Password and Repeat Password match
   * On tap:

     * Perform mock sign-up request
     * Show error if email already exists (mock behavior)
     * On success, navigate to main flow

5. **Navigation Text**

   * Text example:
     *“Already have an account? Sign in”*
   * “Sign in” should be tappable and navigate back to the **Sign In** screen (Task 4)

---

## **2. Behavior & Logic**

### **Sign Up Flow**

* Validate fields
* Call `MockAuthManager.signUp(email, password)`
* If sign-up succeeds: Option A: navigate directly into the main app

### **Error Cases**

* Email already registered

### **Session / State Management**

* Use the same **MockAuthManager** introduced in Task 4
* Manager should provide:

  * `signUp(email, password)`
  * Duplicate-user validation (mocked)
  * Temporary storage for created accounts

This architecture must support future replacement with:

* Firebase Auth
* Custom backend
* OAuth2 / JWT auth
  (with minimal refactoring).

---
