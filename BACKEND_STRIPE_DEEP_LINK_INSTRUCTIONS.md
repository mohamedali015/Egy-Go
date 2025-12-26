# BACKEND: Stripe Deep Link Configuration - REQUIRED CHANGES

## ⚠️ CRITICAL: Backend Changes Required

The Flutter app is **READY** to handle deep links, but the backend must update the Stripe checkout
session creation to use mobile deep links instead of web URLs.

---

## What Backend Must Change

### File: `.env`

**BEFORE (Current - WRONG for mobile):**

```env
STRIPE_SUCCESS_URL=https://1p1jgw5z-5173.euw.devtunnels.ms/trips/{tripId}/payment/success?session_id={CHECKOUT_SESSION_ID}
STRIPE_CANCEL_URL=https://1p1jgw5z-5173.euw.devtunnels.ms/trips/{tripId}/payment/cancel
```

**AFTER (Required - WORKS with mobile):**

```env
STRIPE_SUCCESS_URL=egygo://payment/success?tripId={tripId}&session_id={CHECKOUT_SESSION_ID}
STRIPE_CANCEL_URL=egygo://payment/cancel?tripId={tripId}
```

### Important Notes:

1. Use `egygo://` scheme (not `https://`)
2. Use `tripId` in query parameter (not in path)
3. Replace `{tripId}` and `{CHECKOUT_SESSION_ID}` with actual values when creating session

---

## Backend Code Changes

### File: `controllers/tourist/tripController.js` (or similar)

**Locate the function that creates Stripe checkout session:**

```javascript
// EXAMPLE - Your code may differ
const createCheckoutSession = async (req, res) => {
  const { tripId } = req.params;
  
  try {
    const trip = await Trip.findById(tripId);
    
    // ⚠️ CHANGE THIS PART:
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
            unit_amount: Math.round(trip.meta.negotiatedPrice * 100), // Convert to cents
          },
          quantity: 1,
        },
      ],
      mode: 'payment',
      
      // 🔴 OLD (doesn't work with mobile app):
      // success_url: process.env.STRIPE_SUCCESS_URL
      //   .replace('{tripId}', tripId)
      //   .replace('{CHECKOUT_SESSION_ID}', '{CHECKOUT_SESSION_ID}'),
      // cancel_url: process.env.STRIPE_CANCEL_URL
      //   .replace('{tripId}', tripId),
      
      // ✅ NEW (works with mobile app):
      success_url: `egygo://payment/success?tripId=${tripId}&session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `egygo://payment/cancel?tripId=${tripId}`,
      
      metadata: {
        tripId: tripId,
      },
    });
    
    res.status(200).json({
      success: true,
      message: 'Checkout session created successfully',
      data: {
        checkoutUrl: session.url,
        sessionId: session.id,
      },
    });
  } catch (error) {
    console.error('Error creating checkout session:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to create checkout session',
      error: error.message,
    });
  }
};
```

### Alternative: Keep using .env (Recommended)

If you prefer to keep using environment variables:

```javascript
// Make sure .env has the deep link URLs
success_url: process.env.STRIPE_SUCCESS_URL
  .replace('{tripId}', tripId)
  .replace('{CHECKOUT_SESSION_ID}', '{CHECKOUT_SESSION_ID}'),
cancel_url: process.env.STRIPE_CANCEL_URL
  .replace('{tripId}', tripId),
```

**And update `.env` as shown above.**

---

## Testing After Backend Changes

### 1. Test Checkout Session Creation

```bash
# Call your API
curl -X POST http://localhost:5001/api/tourist/trips/YOUR_TRIP_ID/create-checkout-session \
  -H "Authorization: Bearer YOUR_TOKEN"

# Expected response should include:
{
  "success": true,
  "data": {
    "checkoutUrl": "https://checkout.stripe.com/...",
    "sessionId": "cs_test_..."
  }
}
```

### 2. Verify Stripe Dashboard

1. Go to Stripe Dashboard → Checkout Sessions
2. Find the created session
3. Check "Success URL" field - should show: `egygo://payment/success?tripId=...`
4. Check "Cancel URL" field - should show: `egygo://payment/cancel?tripId=...`

### 3. Test Full Flow

1. Open Flutter app
2. Create a trip and get it accepted
3. Tap "Pay Now"
4. Complete payment with test card: `4242 4242 4242 4242`
5. **App should automatically open** (not stay in browser)
6. Should see success screen
7. Should navigate to trip details

---

## Webhook - NO CHANGES REQUIRED

Your webhook handler should remain unchanged. The webhook is still the source of truth for payment
confirmation.

```javascript
// Webhook handler - KEEP AS IS
const handleStripeWebhook = async (req, res) => {
  const sig = req.headers['stripe-signature'];
  let event;

  try {
    event = stripe.webhooks.constructEvent(
      req.body,
      sig,
      process.env.STRIPE_WEBHOOK_SECRET
    );
  } catch (err) {
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  if (event.type === 'checkout.session.completed') {
    const session = event.data.object;
    const tripId = session.metadata.tripId;
    
    // Update trip status
    await Trip.findByIdAndUpdate(tripId, {
      paymentStatus: 'paid',
      status: 'confirmed',
    });
    
    // Emit socket event
    io.to(`trip:${tripId}`).emit('trip_status_updated', {
      tripId,
      status: 'confirmed',
      paymentStatus: 'paid',
    });
  }

  res.json({ received: true });
};
```

---

## Common Issues & Solutions

### Issue: "Invalid URL" error from Stripe

**Cause:** Stripe validates URLs, but mobile deep links are allowed.

**Solution:** Make sure you're using `egygo://` (not `egygo:/` - needs two slashes)

### Issue: App doesn't open after payment

**Cause:** Backend still using web URLs.

**Solution:** Check Stripe dashboard - the session should have `egygo://` URLs, not `https://`

### Issue: Payment works but status doesn't update

**Cause:** Webhook issue (unrelated to deep links).

**Solution:** Check webhook logs, verify webhook secret is correct.

---

## Summary - What You Need to Do

1. ✅ **Update `.env` file** with deep link URLs (see above)
2. ✅ **Restart backend server** to load new environment variables
3. ✅ **Test checkout session creation** - verify deep link URLs in Stripe dashboard
4. ✅ **Test full payment flow** - app should open after payment
5. ⚠️ **DO NOT change webhook logic** - it's already correct

---

## Status Check

After making changes, verify:

- [ ] `.env` file updated with `egygo://` URLs
- [ ] Backend server restarted
- [ ] New checkout sessions show deep link URLs in Stripe dashboard
- [ ] App opens automatically after payment completion
- [ ] Trip status updates correctly via webhook

---

## DONE: Backend instruction document created

Flutter app is **READY**. Waiting for backend to update return URLs.
