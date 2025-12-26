# CRITICAL: Stripe Return URL Configuration Required

## Date: December 26, 2025

---

## ⚠️ URGENT: Payment Redirect Issue

**Problem:** After users complete payment in Stripe, they get stuck on a web page and cannot return
to the app.

**Cause:** Backend is NOT configuring success/cancel URLs when creating Stripe checkout sessions.

---

## ✅ SOLUTION: Configure Return URLs

### Backend Changes Required

When creating a Stripe checkout session, the backend **MUST** include these URLs:

```javascript
// Backend: POST /api/tourist/trips/:tripId/create-checkout-session

const session = await stripe.checkout.sessions.create({
  // ...existing configuration...
  
  // CRITICAL: Add these URLs
  success_url: `egygo://payment/success?tripId=${tripId}`,
  cancel_url: `egygo://payment/cancel?tripId=${tripId}`,
  
  // Alternative if custom scheme doesn't work:
  // success_url: `https://egygo.app/payment/success?tripId=${tripId}`,
  // cancel_url: `https://egygo.app/payment/cancel?tripId=${tripId}`,
});
```

---

## 📱 Deep Link Schemes Configured

The Flutter app now supports these deep link schemes:

### Option 1: Custom Scheme (Recommended)

```
egygo://payment/success?tripId={tripId}
egygo://payment/cancel?tripId={tripId}
```

### Option 2: HTTPS URL (Fallback)

```
https://egygo.app/payment/success?tripId={tripId}
https://egygo.app/payment/cancel?tripId={tripId}
```

---

## 🔧 What I've Done (Flutter Side)

### 1. Android Manifest Updated ✅

Added deep link intent filters:

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data android:scheme="egygo"/>
    <data android:scheme="https"
          android:host="egygo.app"
          android:pathPrefix="/payment"/>
</intent-filter>
```

### 2. Payment Success Screen Created ✅

- Shows success message with animation
- Auto-redirects to trip details after 3 seconds
- Does NOT call any APIs (follows strict contract)
- Socket will update trip status automatically

### 3. Routes Added ✅

- `/paymentSuccess` route configured
- Handles deep link navigation

---

## 🧪 Testing Instructions

### For Backend Team:

1. **Update checkout session creation:**

```javascript
// In your payment controller:
const session = await stripe.checkout.sessions.create({
  payment_method_types: ['card'],
  line_items: [{
    price_data: {
      currency: 'usd',
      product_data: {
        name: 'Trip Booking',
      },
      unit_amount: Math.round(trip.meta.negotiatedPrice * 100),
    },
    quantity: 1,
  }],
  mode: 'payment',
  
  // ADD THESE:
  success_url: `egygo://payment/success?tripId=${tripId}`,
  cancel_url: `egygo://payment/cancel?tripId=${tripId}`,
  
  metadata: {
    tripId: tripId,
    touristId: req.user.id,
  },
});
```

2. **Test the flow:**

```bash
# Create checkout session
POST /api/tourist/trips/{tripId}/create-checkout-session

# Response should include:
{
  "success": true,
  "data": {
    "checkoutUrl": "https://checkout.stripe.com/...",
    "sessionId": "cs_test_..."
  }
}
```

3. **Complete payment in Stripe**
4. **Verify redirect:** Should go to `egygo://payment/success?tripId=XXX`

---

## 🎯 Expected Flow

### Current (BROKEN):

```
1. User clicks "Pay Now" ✅
2. Opens Stripe Checkout ✅
3. Completes payment ✅
4. Stays on Stripe success page ❌ STUCK!
5. Cannot return to app ❌
```

### After Fix (CORRECT):

```
1. User clicks "Pay Now" ✅
2. Opens Stripe Checkout ✅
3. Completes payment ✅
4. Redirects to egygo://payment/success ✅
5. App opens payment success screen ✅
6. Auto-redirects to trip details (3s) ✅
7. Socket updates trip status to "confirmed" ✅
```

---

## 📋 Backend Checklist

- [ ] Add `success_url` to checkout session creation
- [ ] Add `cancel_url` to checkout session creation
- [ ] Use format: `egygo://payment/success?tripId={tripId}`
- [ ] Test payment flow end-to-end
- [ ] Verify app opens after payment
- [ ] Confirm webhook still updates trip status

---

## 🔗 Alternative: Web-Based Redirect

If deep links don't work, you can use a web redirect page:

### Create simple redirect HTML page:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Payment Success</title>
    <meta http-equiv="refresh" content="2;url=egygo://payment/success?tripId={{tripId}}">
</head>
<body>
    <h1>Payment Successful!</h1>
    <p>Redirecting back to app...</p>
    <script>
        // Try deep link
        window.location.href = "egygo://payment/success?tripId={{tripId}}";
        
        // Fallback to app store if app not installed
        setTimeout(() => {
            window.location.href = "https://play.google.com/store/apps/details?id=com.egygo.app";
        }, 3000);
    </script>
</body>
</html>
```

Host this page and use:

```javascript
success_url: `https://yourbackend.com/payment/success?tripId=${tripId}`
```

---

## ⚠️ Important Notes

1. **Do NOT poll trip status** - The webhook handles this
2. **Include tripId in URL** - App needs to know which trip to show
3. **Test on real device** - Deep links don't work in emulator
4. **Use custom scheme** - `egygo://` is configured in app

---

## 🆘 Troubleshooting

### Issue: "Deep link not opening app"

**Solution:** Make sure:

- App is installed on device
- Using custom scheme: `egygo://`
- URL format is correct
- Android manifest has intent filter (already done ✅)

### Issue: "URL opens browser instead of app"

**Solution:**

- Use custom scheme `egygo://` instead of `https://`
- Or implement web redirect page (see above)

---

## 📞 Next Steps

1. **Backend team:** Update checkout session creation with return URLs
2. **Test:** Complete a payment and verify redirect works
3. **Deploy:** Push backend changes to production

---

**Status:** Waiting for backend team to add `success_url` and `cancel_url` to Stripe checkout
session.

**Priority:** CRITICAL - Users cannot complete payments without this!

