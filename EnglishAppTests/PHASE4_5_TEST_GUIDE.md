# Phase 4 & 5: Authentication - Test Guide

## Automated Unit Tests

The file `AuthenticationTests.swift` contains comprehensive unit tests for:
- User model initialization and equality
- Email validation (valid and invalid formats)
- Sign in functionality (success and error cases)
- Sign up functionality (success and error cases)
- Sign out functionality
- Auth state persistence
- ViewModel validation
- Error handling and messages

### Running Automated Tests

In Xcode:
1. Open `EnglishApp.xcodeproj`
2. Press `Cmd+U` to run all tests
3. Or right-click `AuthenticationTests.swift` and select "Run Tests"

Command line:
```bash
xcodebuild test -project EnglishApp.xcodeproj -scheme EnglishApp -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Manual UI Test Checklist

### Test 1: Initial App Launch - Sign In Screen
- [ ] Launch the app (fresh install or after sign out)
- [ ] Verify Sign In screen is displayed
- [ ] Verify person icon is visible at top
- [ ] Verify "Welcome back" title
- [ ] Verify "Sign in to continue to your account" subtitle
- [ ] Verify Email label and text field with placeholder "Enter your email"
- [ ] Verify Password label and text field with placeholder "Enter your password"
- [ ] Verify "Sign In" button is blue
- [ ] Verify "Don't have an account? Sign up" text at bottom
- [ ] Verify "Sign up" text is blue/clickable

### Test 2: Sign In - Form Validation
- [ ] Verify "Sign In" button is disabled when fields are empty
- [ ] Enter email only
- [ ] Verify button remains disabled
- [ ] Enter password
- [ ] Verify button becomes enabled (blue)
- [ ] Clear email field
- [ ] Verify button becomes disabled again (gray)

### Test 3: Sign In - Invalid Email Format
- [ ] Enter invalid email: "notanemail"
- [ ] Enter any password
- [ ] Tap "Sign In"
- [ ] Verify error message: "Please enter a valid email address"
- [ ] Verify error is displayed in red text
- [ ] Verify user is NOT signed in

### Test 4: Sign In - User Not Found
- [ ] Enter email: "nonexistent@test.com"
- [ ] Enter password: "password123"
- [ ] Tap "Sign In"
- [ ] Verify error message: "No account found with this email"
- [ ] Verify user is NOT signed in

### Test 5: Sign In - Incorrect Password
- [ ] Enter email: "test@example.com" (mock user)
- [ ] Enter password: "wrongpassword"
- [ ] Tap "Sign In"
- [ ] Verify error message: "Incorrect password"
- [ ] Verify user is NOT signed in

### Test 6: Sign In - Success
- [ ] Enter email: "test@example.com"
- [ ] Enter password: "password123"
- [ ] Tap "Sign In"
- [ ] Verify loading indicator appears briefly
- [ ] Verify navigation to MainTabView
- [ ] Verify tab bar is visible
- [ ] Verify Home tab is selected
- [ ] Navigate to Profile tab
- [ ] Verify user name is displayed
- [ ] Verify user email is displayed

### Test 7: Sign In - Keyboard Handling
- [ ] Tap email field
- [ ] Verify keyboard appears with email keyboard type
- [ ] Tap "Next" on keyboard
- [ ] Verify focus moves to password field
- [ ] Tap "Go" on keyboard
- [ ] Verify sign in is triggered (if valid)

### Test 8: Navigation to Sign Up
- [ ] From Sign In screen
- [ ] Tap "Sign up" link
- [ ] Verify navigation to Sign Up screen
- [ ] Verify back button is visible in nav bar
- [ ] Tap back button
- [ ] Verify return to Sign In screen

### Test 9: Sign Up Screen - UI Elements
- [ ] Navigate to Sign Up screen
- [ ] Verify illustration/icon at top
- [ ] Verify "Start Learning English" title
- [ ] Verify "Join millions of students worldwide" subtitle
- [ ] Verify "Full Name" text field with placeholder
- [ ] Verify "Email Address" text field with placeholder
- [ ] Verify "Password" secure field with placeholder
- [ ] Verify "Confirm Password" secure field with placeholder (not in screenshot but per plan)
- [ ] Verify "Create Account" button (blue)
- [ ] Verify privacy policy text
- [ ] Verify "Already have an account? Log in" text
- [ ] Verify "Log in" is blue/clickable

### Test 10: Sign Up - Form Validation
- [ ] Verify "Create Account" button is disabled initially
- [ ] Fill in only Full Name
- [ ] Verify button remains disabled
- [ ] Fill in Email
- [ ] Verify button remains disabled
- [ ] Fill in Password
- [ ] Verify button remains disabled
- [ ] Fill in Confirm Password
- [ ] Verify button becomes enabled (blue)

### Test 11: Sign Up - Invalid Email
- [ ] Enter Full Name: "Test User"
- [ ] Enter Email: "invalid-email"
- [ ] Enter Password: "password123"
- [ ] Enter Confirm Password: "password123"
- [ ] Tap "Create Account"
- [ ] Verify error: "Please enter a valid email address"
- [ ] Verify user is NOT signed up

### Test 12: Sign Up - Password Too Short
- [ ] Enter Full Name: "Test User"
- [ ] Enter Email: "test@test.com"
- [ ] Enter Password: "12345" (less than 6 characters)
- [ ] Enter Confirm Password: "12345"
- [ ] Tap "Create Account"
- [ ] Verify error: "Password must be at least 6 characters"
- [ ] Verify user is NOT signed up

### Test 13: Sign Up - Passwords Don't Match
- [ ] Enter Full Name: "Test User"
- [ ] Enter Email: "test@test.com"
- [ ] Enter Password: "password123"
- [ ] Enter Confirm Password: "different123"
- [ ] Tap "Create Account"
- [ ] Verify error: "Passwords do not match"
- [ ] Verify user is NOT signed up

### Test 14: Sign Up - Email Already Exists
- [ ] Enter Full Name: "Another User"
- [ ] Enter Email: "test@example.com" (existing mock user)
- [ ] Enter Password: "password123"
- [ ] Enter Confirm Password: "password123"
- [ ] Tap "Create Account"
- [ ] Verify error: "An account with this email already exists"
- [ ] Verify user is NOT signed up

### Test 15: Sign Up - Success
- [ ] Enter Full Name: "New Test User"
- [ ] Enter Email: "newuser@test.com"
- [ ] Enter Password: "newpass123"
- [ ] Enter Confirm Password: "newpass123"
- [ ] Tap "Create Account"
- [ ] Verify loading indicator appears briefly
- [ ] Verify automatic sign in
- [ ] Verify navigation to MainTabView
- [ ] Navigate to Profile tab
- [ ] Verify user name "New Test User" is displayed
- [ ] Verify email "newuser@test.com" is displayed

### Test 16: Sign Up - Keyboard Flow
- [ ] From Sign Up screen
- [ ] Tap Full Name field
- [ ] Verify keyboard with capitalization
- [ ] Tap "Next"
- [ ] Verify focus moves to Email field
- [ ] Tap "Next"
- [ ] Verify focus moves to Password field
- [ ] Tap "Go"
- [ ] Verify sign up is triggered (if valid)

### Test 17: Sign Up - Back to Sign In
- [ ] From Sign Up screen
- [ ] Tap "Log in" link at bottom
- [ ] Verify navigation back to Sign In screen
- [ ] Or tap back button in nav bar
- [ ] Verify navigation back to Sign In screen

### Test 18: Profile Screen - User Info Display
- [ ] Sign in successfully
- [ ] Navigate to Profile tab
- [ ] Verify person icon at top
- [ ] Verify user's full name is displayed
- [ ] Verify user's email is displayed
- [ ] Verify "Manage your account and settings" text
- [ ] Verify settings sections:
   - [ ] Account Settings
   - [ ] Notifications
   - [ ] Privacy
   - [ ] Help & Support
- [ ] Verify all sections have icons and chevrons
- [ ] Verify "Sign Out" button in red

### Test 19: Sign Out
- [ ] From Profile tab (while signed in)
- [ ] Tap "Sign Out" button
- [ ] Verify immediate sign out (no confirmation)
- [ ] Verify navigation to Sign In screen
- [ ] Verify user is no longer authenticated
- [ ] Attempt to navigate to Profile
- [ ] Should remain on Sign In screen

### Test 20: Auth State Persistence
- [ ] Sign in successfully
- [ ] Navigate to Profile, verify signed in
- [ ] Close app completely (swipe up in app switcher)
- [ ] Relaunch app
- [ ] Verify app opens directly to MainTabView (stays signed in)
- [ ] Verify Profile shows correct user info
- [ ] Sign out
- [ ] Close app completely
- [ ] Relaunch app
- [ ] Verify app opens to Sign In screen

### Test 21: Case-Insensitive Email
- [ ] Sign in with "TEST@EXAMPLE.COM" (uppercase)
- [ ] Password: "password123"
- [ ] Verify successful sign in
- [ ] Sign out
- [ ] Sign in with "test@example.com" (lowercase)
- [ ] Password: "password123"
- [ ] Verify successful sign in

### Test 22: Error Message Dismissal
- [ ] Trigger any error (e.g., wrong password)
- [ ] Verify error message displays
- [ ] Start typing in any field
- [ ] Verify error message persists (doesn't auto-dismiss)
- [ ] Fix the error and submit
- [ ] Verify error clears on successful submission

### Test 23: Visual Design Matching
- [ ] Compare Sign In screen to screenshot
- [ ] Verify spacing, padding, colors match
- [ ] Verify icon size and color
- [ ] Verify text sizes and weights
- [ ] Verify button styling (blue, rounded corners)
- [ ] Verify input field styling
- [ ] Compare Sign Up screen to screenshot
- [ ] Verify illustration area
- [ ] Verify all field placeholders
- [ ] Verify button and text colors

## Expected Results

All tests should pass with:
- ✅ Sign In screen displays correctly
- ✅ Sign Up screen displays correctly
- ✅ Form validation works properly
- ✅ Email format validation works
- ✅ Password requirements enforced (6+ characters)
- ✅ Password matching works in Sign Up
- ✅ Duplicate email detection works
- ✅ Sign in with mock users works
- ✅ Sign up creates new users
- ✅ Auto sign-in after sign up
- ✅ Sign out returns to Sign In screen
- ✅ Auth state persists across app restarts
- ✅ Profile shows user information
- ✅ Error messages are clear and helpful
- ✅ Loading indicators show during async operations
- ✅ Keyboard navigation works smoothly
- ✅ No crashes or console errors

## Mock Test Users

For testing, use these credentials:

**User 1:**
- Email: test@example.com
- Password: password123

**User 2:**
- Email: alex@example.com
- Password: alex123

## Performance Expectations

- Sign in should complete in < 500ms (mock)
- Sign up should complete in < 500ms (mock)
- No UI lag during form input
- Smooth transitions between screens
- Loading indicators should be visible but brief
