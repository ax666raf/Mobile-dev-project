# FCM (Firebase Cloud Messaging) Testing Guide

## 📋 Table of Contents
1. [Firebase Console Configuration Check](#1-firebase-console-configuration-check)
2. [Code Configuration Verification](#2-code-configuration-verification)
3. [Testing FCM on Android Emulator](#3-testing-fcm-on-android-emulator)

---

## 1. Firebase Console Configuration Check

### Step 1.1: Verify Firebase Project Setup
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (or create one if needed)
3. Click on **⚙️ Project Settings** (gear icon)

### Step 1.2: Verify Android App Registration
1. In Project Settings, scroll to **"Your apps"** section
2. Check if your Android app is registered:
   - **Package name**: `com.example.mahsoul_dz` (check your `build.gradle`)
   - **App nickname**: Any name you chose
3. If not registered:
   - Click **"Add app"** → Select **Android**
   - Enter package name: `com.example.mahsoul_dz`
   - Download `google-services.json`
   - Place it in: `mahsoul_dz/android/app/google-services.json`

### Step 1.3: Verify Cloud Messaging API
1. In Firebase Console, go to **Build** → **Cloud Messaging**
2. Check that **Cloud Messaging API (Legacy)** is enabled
3. If not enabled:
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Select your Firebase project
   - Navigate to **APIs & Services** → **Library**
   - Search for "Firebase Cloud Messaging API"
   - Click **Enable**

### Step 1.4: Get Server Key (for Backend Testing)
1. In Firebase Console → **Project Settings** → **Cloud Messaging** tab
2. Under **"Cloud Messaging API (Legacy)"**, find **"Server key"**
3. Copy this key (you'll need it for backend testing)

---

## 2. Code Configuration Verification

### Step 2.1: Verify `google-services.json` Location
```bash
# Check if file exists
ls mahsoul_dz/android/app/google-services.json
```
✅ **Expected**: File should exist and contain your Firebase project configuration

### Step 2.2: Verify Android Build Configuration
Check `mahsoul_dz/android/app/build.gradle`:
```gradle
// Should have these dependencies
dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-messaging'
}
```

Check `mahsoul_dz/android/build.gradle`:
```gradle
// Should have Google Services plugin
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}

// Should apply plugin
apply plugin: 'com.google.gms.google-services'
```

### Step 2.3: Verify Flutter Dependencies
Check `mahsoul_dz/pubspec.yaml`:
```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_messaging: ^14.7.0
  flutter_local_notifications: ^17.2.0
```

### Step 2.4: Verify AndroidManifest.xml
Check `mahsoul_dz/android/app/src/main/AndroidManifest.xml`:
- ✅ Should have Firebase Messaging Service
- ✅ Should have default notification channel meta-data

### Step 2.5: Verify Code Implementation
✅ **FCM Service**: `lib/core/services/fcm_service.dart` - Initialized in `main.dart`
✅ **Local Notifications**: `lib/core/services/local_notification_service.dart` - Initialized in `main.dart`
✅ **Background Handler**: Top-level function in `main.dart`
✅ **Backend Endpoint**: `/api/fcm-tokens` exists and working

---

## 3. Testing FCM on Android Emulator

### ⚠️ Important Note About Emulators
- **Standard Android Emulators** (without Google Play Services) **CANNOT** receive FCM notifications
- You need either:
  - **Physical Android device** (recommended)
  - **Emulator with Google Play Services** (Android 11+ with Google Play Store)

### Step 3.1: Setup Emulator with Google Play Services
1. Open **Android Studio** → **AVD Manager**
2. Click **Create Virtual Device**
3. Select a device (e.g., Pixel 5)
4. Select a **system image with Google Play** (look for "Google Play" icon)
   - Example: `Android 11.0 (Google Play)`
5. Finish setup and start the emulator

### Step 3.2: Build and Run the App
```bash
# Navigate to Flutter project
cd mahsoul_dz

# Get dependencies
flutter pub get

# Run on emulator
flutter run
```

### Step 3.3: Check FCM Token Generation
1. **Open the app** on emulator
2. **Log in** as a farmer or customer
3. **Check console/logcat** for FCM token:
   ```
   FCM Token: <your-token-here>
   ```
4. If you see:
   - ✅ `FCM Token: <token>` → Token generated successfully
   - ⚠️ `⚠️ Failed to get FCM token` → Emulator doesn't have Google Play Services

### Step 3.4: Register FCM Token with Backend
The app should automatically register the token when user logs in. Check:
1. **Backend logs** for POST request to `/api/fcm-tokens`
2. **Flutter console** for:
   ```
   ✅ FCM token registered successfully for user <user_id>
   ```

### Step 3.5: Test Notification from Firebase Console

#### Option A: Send Test Notification (Quick Test)
1. Go to Firebase Console → **Cloud Messaging**
2. Click **"Send your first message"** or **"New campaign"**
3. Enter:
   - **Notification title**: "Test Notification"
   - **Notification text**: "This is a test message"
4. Click **"Send test message"**
5. Enter your **FCM token** (from Step 3.3)
6. Click **"Test"**
7. **Expected Result**:
   - ✅ Notification appears in emulator notification tray
   - ✅ App shows local notification if in foreground
   - ✅ Console shows: `📬 Foreground message received!`

#### Option B: Send to Topic (For Farmer Testing)
1. In Firebase Console → **Cloud Messaging**
2. Create a notification
3. Select **"Topic"** as target
4. Enter topic: `farmer_<farmer_id>` (e.g., `farmer_fb9bad6a-1f5f-4085-86d5-e41bc8e371c3`)
5. Send notification
6. **Expected**: All farmers subscribed to that topic receive notification

### Step 3.6: Test Notification Scenarios

#### Scenario 1: App in Foreground
1. **Keep app open** and visible
2. Send test notification from Firebase Console
3. **Expected**:
   - ✅ Local notification appears in notification tray
   - ✅ Console shows: `📬 Foreground message received!`
   - ✅ Console shows: `✅ Local notification shown`

#### Scenario 2: App in Background
1. **Minimize app** (press home button)
2. Send test notification from Firebase Console
3. **Expected**:
   - ✅ Notification appears in notification tray
   - ✅ Tapping notification opens app
   - ✅ Console shows: `Background message: <title>`

#### Scenario 3: App Terminated
1. **Force close app** (swipe away from recent apps)
2. Send test notification from Firebase Console
3. **Expected**:
   - ✅ Notification appears in notification tray
   - ✅ Tapping notification launches app
   - ✅ App navigates to orders page (if notification has order data)

### Step 3.7: Test Backend-Triggered Notifications
1. **Place an order** from customer account
2. **Backend should send FCM notification** to farmer
3. **Check farmer's device/emulator** for notification
4. **Expected**: Farmer receives notification about new order

### Step 3.8: Verify Notification Data Handling
Send a notification with custom data:
```json
{
  "notification": {
    "title": "New Order",
    "body": "You have a new order #123"
  },
  "data": {
    "order_id": "123",
    "user_type": "farmer",
    "customer_id": "abc123"
  }
}
```
**Expected**:
- ✅ Notification displays correctly
- ✅ Tapping notification navigates to orders page
- ✅ Data payload is accessible in app

---

## 4. Troubleshooting

### Issue: "Failed to get FCM token"
**Solution**:
- Use emulator with Google Play Services
- Or test on physical device

### Issue: "Notification not appearing"
**Solutions**:
1. Check notification permissions:
   ```bash
   # On emulator, go to Settings → Apps → mahsoul_dz → Notifications
   # Ensure notifications are enabled
   ```
2. Check console for errors
3. Verify `google-services.json` is correct
4. Rebuild app: `flutter clean && flutter pub get && flutter run`

### Issue: "Background notification not working"
**Solutions**:
1. Verify background handler is top-level function in `main.dart`
2. Check AndroidManifest.xml has Firebase Messaging Service
3. Ensure app is properly closed (not just minimized)

### Issue: "Token not registering with backend"
**Solutions**:
1. Check backend is running
2. Verify API endpoint: `POST /api/fcm-tokens`
3. Check network connectivity
4. Verify user_id is correct

---

## 5. Quick Verification Checklist

- [ ] Firebase project created
- [ ] Android app registered in Firebase
- [ ] `google-services.json` in correct location
- [ ] Cloud Messaging API enabled
- [ ] Flutter dependencies installed
- [ ] AndroidManifest.xml configured
- [ ] App builds and runs successfully
- [ ] FCM token generated (check console)
- [ ] Token registered with backend
- [ ] Test notification sent from Firebase Console
- [ ] Notification received on emulator/device
- [ ] Foreground notification works
- [ ] Background notification works
- [ ] Terminated app notification works
- [ ] Notification tap navigation works

---

## 6. Testing Commands Summary

```bash
# 1. Navigate to project
cd mahsoul_dz

# 2. Get dependencies
flutter pub get

# 3. Clean build (if needed)
flutter clean

# 4. Run on emulator
flutter run

# 5. Check logs for FCM token
# Look for: "FCM Token: <token>"

# 6. Test backend (in separate terminal)
cd mahsoul_backend
# Activate virtual environment (Windows PowerShell)
.\venv\Scripts\Activate.ps1
# Or (Windows CMD)
venv\Scripts\activate.bat
# Or (Linux/Mac)
source venv/bin/activate

# Run backend
python app.py
```

---

## 7. Next Steps After Testing

Once FCM is working:
1. ✅ Integrate with order placement (send notification to farmer)
2. ✅ Integrate with order status updates (send notification to customer)
3. ✅ Add notification preferences in user settings
4. ✅ Implement notification history in app
5. ✅ Add sound and vibration customization

---

**Last Updated**: Based on current codebase implementation
**Tested On**: Android Emulator with Google Play Services
