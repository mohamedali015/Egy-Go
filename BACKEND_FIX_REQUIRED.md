# ============================================================

# CRITICAL FIX: Backend Configuration for Deep Links

# ============================================================

## ❌ THE PROBLEM

Your backend `.env` file has:

```
STRIPE_SUCCESS_URL=https://1p1jgw5z-5173.euw.devtunnels.ms/trips/{tripId}/payment/success?session_id={CHECKOUT_SESSION_ID}
STRIPE_CANCEL_URL=https://1p1jgw5z-5173.euw.devtunnels.ms/trips/{tripId}/payment/cancel
```

These are **WEB URLs** - they keep the user in the browser instead of returning to the Flutter app.

---

## ✅ THE SOLUTION

### Step 1: Update `.env` File

Replace the Stripe URLs in your `.env` file with:

```env
STRIPE_SUCCESS_URL=egygo://payment/success?tripId={tripId}&session_id={CHECKOUT_SESSION_ID}
STRIPE_CANCEL_URL=egygo://payment/cancel?tripId={tripId}
```

**Location**: `c:\My Programs\Project Backend\egygo\backend\.env`

**Lines to change**: Around line 52-54

---

### Step 2: Restart Backend Server

After updating `.env`:

1. **Stop** your Node.js server (Ctrl+C)
2. **Restart** it:
   ```bash
   npm run dev
   # or
   node server.js
   ```

**IMPORTANT**: Environment variables are loaded only on server startup!

---

### Step 3: Verify the URLs are Being Used

After restarting, create a test checkout session and check the logs.

You should see in your backend console:

```
[Stripe] Success URL: egygo://payment/success?tripId=...
[Stripe] Cancel URL: egygo://payment/cancel?tripId=...
```

If you still see `https://` URLs, the server didn't reload the environment variables.

---

### Step 4: Verify in Stripe Dashboard

1. Go to: https://dashboard.stripe.com/test/checkout-sessions
2. Find your latest session
3. Click on it
4. Check **"Success URL"** field
5. Should show: `egygo://payment/success?tripId=...`

If it still shows `https://`, your backend isn't using the updated `.env` file.

---

## 🔍 Troubleshooting

### Issue: Server doesn't pick up new .env values

**Solution 1**: Make sure you saved the `.env` file and restarted the server

**Solution 2**: Hard-code the URLs temporarily in your controller:

**File**: `src/controllers/tourist/tripController.js` (or similar)

Find the `createCheckoutSession` function and update it:

```javascript
const createCheckoutSession = async (req, res) => {
  const { tripId } = req.params;
  
  try {
    const trip = await Trip.findById(tripId);
    
    // ✅ HARD-CODE the deep link URLs
    const successUrl = `egygo://payment/success?tripId=${tripId}&session_id={CHECKOUT_SESSION_ID}`;
    const cancelUrl = `egygo://payment/cancel?tripId=${tripId}`;
    
    console.log('[Stripe] Creating session with URLs:');
    console.log('[Stripe] Success:', successUrl);
    console.log('[Stripe] Cancel:', cancelUrl);
    
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: process.env.CURRENCY || 'usd',
            product_data: {
              name: `Trip to ${trip.governorate}`,
              description: trip.description,
            },
            unit_amount: Math.round(trip.meta.negotiatedPrice * 100),
          },
          quantity: 1,
        },
      ],
      mode: 'payment',
      
      // ✅ USE HARD-CODED DEEP LINKS
      success_url: successUrl,
      cancel_url: cancelUrl,
      
      metadata: {
        tripId: tripId,
      },
    });
    
    console.log('[Stripe] Session created:', session.id);
    console.log('[Stripe] Checkout URL:', session.url);
    
    res.status(200).json({
      success: true,
      message: 'Checkout session created successfully',
      data: {
        checkoutUrl: session.url,
        sessionId: session.id,
      },
    });
    
  } catch (error) {
    console.error('[Stripe] Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to create checkout session',
      error: error.message,
    });
  }
};
```

---

## 🧪 Test After Backend Changes

### Test 1: Verify Backend Logs

After updating and restarting, call the API:

```bash
curl -X POST http://localhost:5001/api/tourist/trips/YOUR_TRIP_ID/create-checkout-session \
  -H "Authorization: Bearer YOUR_TOKEN"
```

Check console output - should show `egygo://` URLs

### Test 2: Test Full Payment Flow

1. Open Flutter app
2. Create a trip → Get accepted
3. Tap "Pay Now"
4. Complete payment with: `4242 4242 4242 4242`
5. **App should automatically open** ✅

If app doesn't open → Backend is still using old URLs

---

## 📋 Quick Checklist

- [ ] Updated `.env` file with `egygo://` URLs
- [ ] Saved the file
- [ ] Stopped backend server
- [ ] Restarted backend server
- [ ] Verified logs show `egygo://` URLs
- [ ] Tested creating checkout session
- [ ] Checked Stripe Dashboard shows `egygo://` URLs
- [ ] Tested full payment flow from Flutter app

---

## 🚨 Common Mistakes

1. **Forgot to restart server** - Changes won't apply
2. **Edited wrong `.env` file** - Some projects have multiple
3. **Typo in URL** - Must be exactly `egygo://payment/success`
4. **Cached environment** - Try `npm run dev` instead of `node server.js`

---

## 📞 Still Not Working?

If it still doesn't redirect to the app:

1. **Check backend logs** - Are `egygo://` URLs being used?
2. **Check Stripe Dashboard** - Does the session have `egygo://` URLs?
3. **Test deep link manually** - Run the test script on Flutter side
4. **Share backend logs** - Send the console output when creating a session

---

## ✅ Expected Behavior After Fix

1. User taps "Pay Now"
2. Browser opens with Stripe checkout
3. User completes payment
4. **Browser automatically closes**
5. **Flutter app automatically opens** ← This should happen now!
6. Success screen shows for 2 seconds
7. Navigates to trip details
8. Trip status updates to "Confirmed"

---

**ACTION REQUIRED NOW:**

1. Open: `c:\My Programs\Project Backend\egygo\backend\.env`
2. Find line ~52: `STRIPE_SUCCESS_URL=https://...`
3. Replace with:
   `STRIPE_SUCCESS_URL=egygo://payment/success?tripId={tripId}&session_id={CHECKOUT_SESSION_ID}`
4. Find line ~53: `STRIPE_CANCEL_URL=https://...`
5. Replace with: `STRIPE_CANCEL_URL=egygo://payment/cancel?tripId={tripId}`
6. Save file
7. Restart backend server
8. Test payment flow

**That's the fix! The issue is 100% in the backend URLs.**

