# Stripe Payment Return Configuration Guide

## Problem

After completing payment on Stripe's website, users are redirected to a web URL instead of returning
to the Flutter app.

## Solution

Configure Stripe return URLs to use deep links that the Flutter app can intercept.

---

## Backend Configuration Required

### Update `.env` file with the following URLs:

```env
# Stripe Payment Integration
STRIPE_SECRET_KEY=sk_test_51ScnomPQAVx313emQlDFpN4hW2EC9wHiRSA4XKcDwN8R3FXhWjaYAgJcAZCfUz09KHxDztRQtXWNRns0AAC5HdXJ00IwBZrxkl
STRIPE_WEBHOOK_SECRET=whsec_6e82fc4c96203bc94de9c13372fcc78ec56b459298527341f1ada553e3aff503

# IMPORTANT: Use app deep link scheme instead of web URLs
STRIPE_SUCCESS_URL=egygo://payment/success?trip_id={tripId}&session_id={CHECKOUT_SESSION_ID}
STRIPE_CANCEL_URL=egygo://payment/cancel?trip_id={tripId}

CURRENCY=usd
```

### Alternative: Universal Links (Recommended for Production)

If you prefer HTTPS links that work on both web and mobile:

```env
STRIPE_SUCCESS_URL=https://egygo.app/payment/success?trip_id={tripId}&session_id={CHECKOUT_SESSION_ID}
STRIPE_CANCEL_URL=https://egygo.app/payment/cancel?trip_id={tripId}
```

**Note:** For universal links to work, you need to:

1. Host a `assetlinks.json` file at `https://egygo.app/.well-known/assetlinks.json` (Android)
2. Host an `apple-app-site-association` file at
   `https://egygo.app/.well-known/apple-app-site-association` (iOS)

---

## URL Pattern Support

The Flutter app supports the following URL patterns:

### App Scheme (Custom URL Scheme)

- `egygo://payment/success?trip_id=XXX&session_id=YYY`
- `egygo://payment/cancel?trip_id=XXX`

### Universal Links (HTTPS)

- `https://egygo.app/payment/success?trip_id=XXX&session_id=YYY`
- `https://egygo.app/payment/cancel?trip_id=XXX`

### Path-based (Alternative)

- `egygo://trips/{tripId}/payment/success?session_id=YYY`
- `https://egygo.app/trips/{tripId}/payment/success?session_id=YYY`

---

## Required Parameters

### Success URL

- `trip_id` or `tripId` (required) - The trip ID to return to
- `session_id` or `sessionId` (optional) - Stripe checkout session ID

### Cancel URL

- `trip_id` or `tripId` (required) - The trip ID to return to

---

## How It Works

1. **User clicks "Pay Now"** in Flutter app
2. **Backend creates Stripe checkout session** with return URLs
3. **Flutter opens Stripe payment page** in external browser
4. **User completes/cancels payment** on Stripe's website
5. **Stripe redirects to return URL** (egygo:// or https://egygo.app)
6. **Android/iOS OS intercepts the deep link** and opens the app
7. **Flutter app handles the callback** and navigates to payment result screen
8. **App shows success/cancel message** and returns to trip details
9. **Socket.io updates trip status** automatically when webhook confirms payment

---

## Implementation Status

### ✅ Flutter App (Completed)

- [x] Deep link service implemented (`DeepLinkService`)
- [x] Payment return screen created (`PaymentReturnScreen`)
- [x] AndroidManifest.xml configured for both `egygo://` and `https://egygo.app`
- [x] Route handling for payment callbacks
- [x] Deep link listener in main app
- [x] Automatic navigation back to trip details

### ⚠️ Backend (Action Required)

- [ ] Update `.env` with new return URLs
- [ ] Test Stripe checkout with new URLs
- [ ] Verify webhook still works correctly

---

## Testing

### Test Success Flow

1. Create a trip and get it accepted by a guide
2. Click "Pay Now" in the app
3. Complete payment with test card: `4242 4242 4242 4242`
4. Verify app receives callback and shows success screen
5. Verify app navigates back to trip details
6. Verify trip status updates to confirmed

### Test Cancel Flow

1. Create a trip and get it accepted by a guide
2. Click "Pay Now" in the app
3. Click "Cancel" or close browser
4. Verify app receives callback and shows cancel screen
5. Verify app navigates back to trip details
6. Verify trip status remains unchanged

---

## Android Configuration (Already Done)

`android/app/src/main/AndroidManifest.xml`:

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    
    <!-- Custom scheme -->
    <data android:scheme="egygo"/>
    
    <!-- Universal links -->
    <data android:scheme="https"
          android:host="egygo.app"
          android:pathPrefix="/payment"/>
</intent-filter>
```

---

## iOS Configuration (May Need Updates)

Check `ios/Runner/Info.plist` for URL scheme configuration.

---

## Important Notes

1. **DO NOT change webhook logic** - Payment confirmation still comes from webhook
2. **DO NOT rely on return URL for payment status** - It's only for UX navigation
3. **Trip status updates via Socket.io** - The return URL just improves user experience
4. **Deep links only work on real devices** - Use `adb` to test on Android emulator

---

## Troubleshooting

### Issue: App doesn't open after payment

**Solution:**

- Verify backend is using the new return URLs
- Check Android logs: `adb logcat | grep -i "deeplink"`
- Ensure app is installed on device/emulator

### Issue: Wrong trip opens

**Solution:**

- Ensure `{tripId}` placeholder is replaced with actual trip ID in backend
- Check deep link logs for correct trip ID

### Issue: Universal links not working

**Solution:**

- Verify `.well-known` files are hosted correctly
- Check `android:autoVerify="true"` in AndroidManifest
- Test with:
  `adb shell am start -a android.intent.action.VIEW -d "https://egygo.app/payment/success?trip_id=XXX"`

---

## Contact

For questions or issues, check the implementation in:

- `lib/core/services/deep_link_service.dart`
- `lib/features/trip/views/payment_return_screen.dart`
- `lib/main.dart` (deep link handler)

---

## DONE: Stripe Payment Return URL Configuration Complete
