# **Fixes Required in the Application**

## **1. MemoriseWordsView Fixes**

### **1.1 Mirrored Text on Card Rotation**

When the card rotates 180 degrees, all text appears mirrored because the entire view is rotated.
**Fix:**
Ensure that only the card container rotates, when staring animation hide text labels and when it finishes show updated text labels.

---

### **1.2 `formattedTime` Does Not Trigger UI Updates**

The label

```swift
Text("Time: \(viewModel.formattedTime)")
    .font(.caption)
```

does not refresh when the time changes because `formattedTime` is a computed property and not an observable `@Published` value.

**Fix:**

* Introduce a dedicated `@Published var formattedTime: String` in the ViewModel.
* Update this property every second, so changes propagate to the view and the UI updates correctly.

---

### **1.3 Excessive Card Rotation on Rapid Taps**

Currently, multiple rapid taps on the card cause the rotation value (`cardRotation`) to accumulate:

```swift
cardRotation += 180
```

This creates unexpected visual behavior when the user later selects “don’t know” or “know,” because the rotation resets from a large accumulated value.

**Fix:**
Use toggle-style rotation logic:

```swift
cardRotation = cardRotation == 0 ? 180 : 0
```

This ensures the card always rotates between two stable states instead of endlessly increasing rotation values.

---

## **2. Fixes for TestQuestionCard**

### **Incorrect Icon and Styling for Wrong Answers**

When the user selects an incorrect answer, the selected button still displays the **green check mark** icon used for correct answers.
This is misleading.

**Fix:**
If the selected answer is incorrect:

* The chosen answer button should have:

  * **Red stroke**
  * **Red.opacity(0.1)** background
  * **Red “X” mark icon** instead of the green check mark

---

## **3. Threading Corrections in Managers**

Several managers currently mark the entire class with `@MainActor`, causing all their operations—including networking, audio processing, file access, and long-running logic—to execute on the main thread. This leads to performance issues and potential UI freezes.

### **Required Fixes**

#### **3.1 Limit Main-Thread Execution to UI-Related Updates Only**

* Remove `@MainActor` from entire manager classes.
* Ensure only UI-bound updates (e.g., modifying `@Published` properties observed by views) are executed on the main thread.
* Business logic, parsing, networking, decoding, and audio operations must run on background threads.

---

#### **3.2 Use Swift Concurrency Properly**

Since the project already uses modern Swift Concurrency (`async/await`), all managers should adopt the following pattern:

* Perform heavy operations in **non-isolated async functions** on background threads.
* When updating a property that triggers UI changes, switch to the main actor explicitly:

```swift
await MainActor.run {
    self.someUIBoundProperty = newValue
}
```

* Avoid placing `@MainActor` on entire types—only apply it to individual functions or property setters that must run on the main thread.

---

#### **3.3 Network and Audio Managers**

* Network requests should run fully off the main actor.
* Audio processing, playback preparation, and file loading must also occur in background contexts.
* Only events like:

  * updating progress,
  * updating currently playing audio name,
  * notifying UI of completion
    should be moved onto `MainActor`.

---

#### 3.4 Update unit tests according to updated managers
