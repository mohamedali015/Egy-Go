# ✅ Stripe Payment Redirect - Implementation Status

## Current Status: Flutter App is READY ✅ | Backend Needs Update ⚠️

---

## What's Already Implemented (Flutter Side)

### 1. ✅ Deep Link Configuration

**AndroidManifest.xml** - Already configured:

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

### 2. ✅ Deep Link Service

**File:** `lib/core/services/deep_link_service.dart`

- Listens for incoming deep links
- Parses payment callback URLs
- Supports both `tripId` and `trip_id` parameter names
- Handles both success and cancel events

### 3. ✅ Payment Return Screen

**File:** `lib/features/trip/views/payment_return_screen.dart`

- Shows success/cancel UI
- Auto-navigates to trip details after 2 seconds
- Provides "Try Again" button for cancelled payments

### 4. ✅ Main App Integration

**File:** `lib/main.dart`

- Deep link service initialized on app start
- Listens for `egygo://` scheme
- Routes to PaymentReturnScreen with callback data

### 5. ✅ Route Configuration

**File:** `lib/core/helper/one_generate_routes.dart`

- PaymentReturnScreen route registered
- Handles tripId from multiple sources

### 6. ✅ Payment Section

**File:** `lib/features/trip/views/widgets/trip_details_widgets/payment_section.dart`

- Calls backend API: `POST /api/tourist/trips/{tripId}/create-checkout-session`
- Opens Stripe checkout URL in browser
- Shows instruction dialog
- **Does NOT store checkout URL or session ID** (follows strict contract)

---

## What Backend Must Change ⚠️

### Required Change: Update Return URLs

**File:** `.env` (or checkout session creation code)

**Current (Web URLs - doesn't work with mobile):**

```env
STRIPE_SUCCESS_URL=https://1p1jgw5z-5173.euw.devtunnels.ms/trips/{tripId}/payment/success?session_id={CHECKOUT_SESSION_ID}
STRIPE_CANCEL_URL=https://1p1jgw5z-5173.euw.devtunnels.ms/trips/{tripId}/payment/cancel
```

**Required (Deep Links - works with mobile):**

```env
STRIPE_SUCCESS_URL=egygo://payment/success?tripId={tripId}&session_id={CHECKOUT_SESSION_ID}
STRIPE_CANCEL_URL=egygo://payment/cancel?tripId={tripId}
```

### Backend Code Example

**In your checkout session creation:**

```javascript
const session = await stripe.checkout.sessions.create({
  // ...other config...
  
  // ✅ Use deep links
  success_url: `egygo://payment/success?tripId=${tripId}&session_id={CHECKOUT_SESSION_ID}`,
  cancel_url: `egygo://payment/cancel?tripId=${tripId}`,
  
  metadata: {
    tripId: tripId,
  },
});
```

---

## Payment Flow - Complete Sequence

### 1. User Initiates Payment

```
Flutter App → Backend API
POST /api/tourist/trips/{tripId}/create-checkout-session
```

### 2. Backend Creates Stripe Session

```
Backend → Stripe API
Creates checkout session with deep link return URLs
Returns: { checkoutUrl, sessionId }
```

### 3. Flutter Opens Stripe Checkout

```
Flutter → External Browser
Opens checkoutUrl using url_launcher
User enters payment details on Stripe's website
```

### 4. User Completes Payment

```
Stripe → Stripe Servers
Processes payment
Triggers webhook to backend
```

### 5. Stripe Redirects to App

```
Stripe → Mobile OS
Redirects to: egygo://payment/success?tripId=XXX&session_id=YYY
OS recognizes egygo:// scheme
```

### 6. OS Opens Flutter App

```
Mobile OS → Flutter App
Passes deep link URL to app
DeepLinkService receives URL
```

### 7. App Shows Result

```
Flutter App
Parses callback data
Shows PaymentReturnScreen (success/cancel)
Auto-navigates to TripDetailsScreen after 2s
```

### 8. Backend Webhook Confirms

```
Stripe Webhook → Backend
Backend updates trip status: 'confirmed'
Backend emits socket event: 'trip_status_updated'
```

### 9. Real-time Status Update

```
Backend Socket → Flutter App
TripDetailsCubit receives status update
UI rebuilds with new status
```

---

## Testing Instructions

### For Backend Team:

1. **Update `.env` file** with deep link URLs
2. **Restart backend server**
3. **Create test checkout session:**
   ```bash
   curl -X POST http://localhost:5001/api/tourist/trips/TEST_TRIP_ID/create-checkout-session \
     -H "Authorization: Bearer YOUR_TOKEN"
   ```
4. **Verify in Stripe Dashboard:**
    - Go to: Developers → Checkout Sessions
    - Check the session's "Success URL" field
    - Should show: `egygo://payment/success?tripId=...`

### For Flutter Team:

1. **Test deep link manually:**
   ```bash
   # Run this script in project root:
   test_payment_deeplink.bat
   
   # Choose option 1 to test success flow
   ```

2. **Test full payment flow:**
    - Open app
    - Create trip → Get it accepted
    - Tap "Pay Now"
    - Complete payment with: `4242 4242 4242 4242`
    - **Verify:** App opens automatically (not stuck in browser)
    - **Verify:** Success screen shows
    - **Verify:** Navigates to trip details
    - **Verify:** Trip status updates to "confirmed"

---

## Verification Checklist

### Backend:

- [ ] `.env` file updated with `egygo://` URLs
- [ ] Backend server restarted
- [ ] Checkout sessions show deep link URLs in Stripe dashboard
- [ ] Webhook still works correctly
- [ ] Socket events still emit on payment success

### Flutter:

- [x] Deep link service implemented
- [x] AndroidManifest configured for `egygo://` scheme
- [x] Payment return screen created
- [x] Routes configured
- [x] Main app listens for deep links
- [ ] **Tested on real device** (waiting for backend update)

---

## Common Issues & Solutions

### Issue: App doesn't open after payment

**Check:**

1. Is backend using deep link URLs? (Check Stripe dashboard)
2. Is app installed on device?
3. Run: `adb logcat | findstr "deeplink"`

**Solution:** Backend must use `egygo://` URLs, not `https://` URLs.

### Issue: Wrong trip opens

**Check:** Is backend replacing `{tripId}` placeholder correctly?

**Solution:** Verify tripId in URL matches actual trip.

### Issue: Payment succeeds but status doesn't update

**This is NOT a deep link issue.**

**Check:**

1. Webhook endpoint configured in Stripe dashboard?
2. Webhook secret correct in `.env`?
3. Socket connection working?

---

## Architecture Diagram

```
User Taps "Pay Now"
        ↓
Flutter calls Backend API
        ↓
Backend creates Stripe Session (with egygo:// URLs)
        ↓
Backend returns checkoutUrl
        ↓
Flutter opens URL in browser
        ↓
User completes payment on Stripe
        ↓
        ├─────────────────────────────────┐
        ↓                                 ↓
Stripe redirects to:            Stripe sends webhook to:
egygo://payment/success         Backend /webhook endpoint
        ↓                                 ↓
OS opens Flutter app            Backend updates trip status
        ↓                                 ↓
App shows success screen        Backend emits socket event
        ↓                                 ↓
App navigates to trip details   Flutter receives status update
        ↓                                 ↓
        └─────────────────────────────────┘
                      ↓
            Trip Status = "confirmed"
```

---

## Key Points

1. **Deep links are for UX only** - Payment confirmation still comes from webhook
2. **Never rely on redirect for validation** - Always wait for webhook/socket
3. **Backend must update URLs** - Flutter app is already configured
4. **Test on real device** - Emulators may not handle deep links correctly

---

## Files Reference

### Flutter (Already Complete):

- `lib/core/services/deep_link_service.dart` - Deep link handler
- `lib/features/trip/views/payment_return_screen.dart` - Result screen
- `lib/main.dart` - Deep link listener
- `lib/core/helper/one_generate_routes.dart` - Route config
- `android/app/src/main/AndroidManifest.xml` - Deep link config

### Backend (Needs Update):

- `.env` - Update return URLs
- `controllers/tourist/tripController.js` - Checkout session creation
- `webhooks/stripeWebhook.js` - Keep as is (no changes needed)

---

## Next Steps

1. **Backend Team:** Update `.env` and restart server
2. **Backend Team:** Test checkout session creation
3. **Flutter Team:** Test with real device once backend is updated
4. **Both Teams:** Verify end-to-end payment flow

---

## Status: ✅ Flutter Ready | ⚠️ Waiting for Backend

**Action Required:** Backend team must update return URLs to use `egygo://` scheme.

See detailed instructions: `BACKEND_STRIPE_DEEP_LINK_INSTRUCTIONS.md`

---

## DONE: Implementation status documented
