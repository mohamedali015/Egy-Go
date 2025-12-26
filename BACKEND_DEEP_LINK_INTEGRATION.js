/**
 * BACKEND CODE CHANGES FOR STRIPE DEEP LINK REDIRECT
 *
 * This file contains the exact changes needed in your Node.js backend
 * to enable mobile app deep link redirects after Stripe payment.
 */

// =============================================================================
// FILE: controllers/tourist/tripController.js (or similar)
// =============================================================================

/**
 * Create Stripe Checkout Session - UPDATED VERSION
 *
 * Changes:
 * 1. Use egygo:// deep link scheme instead of https://
 * 2. Inject tripId dynamically into URLs
 * 3. Add extensive logging for debugging
 */

const createCheckoutSession = async (req, res) => {
  const { tripId } = req.params;

  try {
    console.log(`[Stripe] Creating checkout session for trip: ${tripId}`);

    // Fetch trip details
    const trip = await Trip.findById(tripId).populate('guide');

    if (!trip) {
      return res.status(404).json({
        success: false,
        message: 'Trip not found',
      });
    }

    if (!trip.meta?.negotiatedPrice) {
      return res.status(400).json({
        success: false,
        message: 'Trip does not have a negotiated price',
      });
    }

    // Calculate amount in cents
    const amountInCents = Math.round(trip.meta.negotiatedPrice * 100);

    console.log(`[Stripe] Trip details:`, {
      tripId,
      price: trip.meta.negotiatedPrice,
      amountInCents,
      status: trip.status,
      paymentStatus: trip.paymentStatus,
    });

    // ✅ CRITICAL: Build deep link URLs with egygo:// scheme
    const successUrl = `egygo://payment/success?tripId=${tripId}&session_id={CHECKOUT_SESSION_ID}`;
    const cancelUrl = `egygo://payment/cancel?tripId=${tripId}`;

    console.log('[Stripe] 🔗 Deep link URLs:');
    console.log('[Stripe]   Success:', successUrl);
    console.log('[Stripe]   Cancel:', cancelUrl);

    // Create Stripe checkout session
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: process.env.CURRENCY || 'usd',
            product_data: {
              name: `Trip to ${trip.governorate}`,
              description: `Guided tour with ${trip.guide?.name || 'professional guide'}`,
              images: trip.image ? [trip.image] : undefined,
            },
            unit_amount: amountInCents,
          },
          quantity: 1,
        },
      ],
      mode: 'payment',

      // ✅ USE DEEP LINKS - This is what makes it work!
      success_url: successUrl,
      cancel_url: cancelUrl,

      // Store trip info in metadata for webhook
      metadata: {
        tripId: tripId,
        touristId: trip.tourist.toString(),
        guideId: trip.guide._id.toString(),
      },
    });

    console.log('[Stripe] ✅ Session created:', {
      sessionId: session.id,
      checkoutUrl: session.url,
      successUrl: session.success_url,
      cancelUrl: session.cancel_url,
    });

    // Return checkout URL to Flutter app
    res.status(200).json({
      success: true,
      message: 'Checkout session created successfully',
      data: {
        checkoutUrl: session.url,
        sessionId: session.id,
      },
    });

  } catch (error) {
    console.error('[Stripe] ❌ Error creating checkout session:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to create checkout session',
      error: error.message,
    });
  }
};

// =============================================================================
// FILE: webhooks/stripeWebhook.js (or similar)
// =============================================================================

/**
 * Stripe Webhook Handler - NO CHANGES NEEDED
 *
 * This remains the source of truth for payment confirmation.
 * The deep link redirect is ONLY for UX - the webhook still handles
 * the actual payment status update.
 */

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
    console.error('[Webhook] ❌ Signature verification failed:', err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  console.log('[Webhook] 📥 Received event:', event.type);

  // Handle checkout.session.completed event
  if (event.type === 'checkout.session.completed') {
    const session = event.data.object;
    const tripId = session.metadata.tripId;

    console.log('[Webhook] 💳 Payment completed for trip:', tripId);
    console.log('[Webhook] 📝 Session ID:', session.id);
    console.log('[Webhook] 💰 Amount paid:', session.amount_total / 100);

    try {
      // Update trip status
      const trip = await Trip.findByIdAndUpdate(
        tripId,
        {
          paymentStatus: 'paid',
          status: 'confirmed',
          'meta.stripeSessionId': session.id,
          'meta.paidAt': new Date(),
        },
        { new: true }
      );

      console.log('[Webhook] ✅ Trip updated:', {
        tripId,
        status: trip.status,
        paymentStatus: trip.paymentStatus,
      });

      // ✅ CRITICAL: Emit socket event for real-time UI update
      const io = req.app.get('io');
      if (io) {
        io.to(`trip:${tripId}`).emit('trip_status_updated', {
          tripId,
          status: 'confirmed',
          paymentStatus: 'paid',
        });
        console.log('[Webhook] 📡 Socket event emitted to trip:', tripId);
      }

    } catch (error) {
      console.error('[Webhook] ❌ Error updating trip:', error);
    }
  }

  res.json({ received: true });
};

// =============================================================================
// FILE: .env
// =============================================================================

/**
 * Environment Variables - UPDATE THESE
 *
 * NOTE: These are now optional since we're hardcoding the deep links
 * in the controller, but you can still use them if you prefer.
 */

/*
# Stripe Configuration
STRIPE_SECRET_KEY=sk_test_51ScnomPQAVx313emQlDFpN4hW2EC9wHiRSA4XKcDwN8R3FXhWjaYAgJcAZCfUz09KHxDztRQtXWNRns0AAC5HdXJ00IwBZrxkl
STRIPE_WEBHOOK_SECRET=whsec_6e82fc4c96203bc94de9c13372fcc78ec56b459298527341f1ada553e3aff503

# Deep Link URLs (optional - hardcoded in controller)
STRIPE_SUCCESS_URL=egygo://payment/success?tripId={tripId}&session_id={CHECKOUT_SESSION_ID}
STRIPE_CANCEL_URL=egygo://payment/cancel?tripId={tripId}

CURRENCY=usd
*/

// =============================================================================
// TESTING
// =============================================================================

/**
 * To verify the changes work:
 *
 * 1. Restart your backend server
 * 2. Make a request to create checkout session:
 *
 *    curl -X POST http://localhost:5001/api/tourist/trips/YOUR_TRIP_ID/create-checkout-session \
 *      -H "Authorization: Bearer YOUR_TOKEN"
 *
 * 3. Check the logs - you should see:
 *    [Stripe] 🔗 Deep link URLs:
 *    [Stripe]   Success: egygo://payment/success?tripId=...
 *    [Stripe]   Cancel: egygo://payment/cancel?tripId=...
 *
 * 4. Verify in Stripe Dashboard:
 *    - Go to: Developers → Checkout Sessions
 *    - Find your session
 *    - Check "Success URL" and "Cancel URL" fields
 *    - Should show egygo:// URLs, not https:// URLs
 *
 * 5. Test full flow:
 *    - Open Flutter app
 *    - Create trip → Get accepted → Pay Now
 *    - Complete payment with test card: 4242 4242 4242 4242
 *    - App should automatically open and show success screen
 *    - Should navigate to trip details
 *    - Trip status should update to "confirmed"
 */

// =============================================================================
// EXPORT
// =============================================================================

module.exports = {
  createCheckoutSession,
  handleStripeWebhook,
};

/**
 * ✅ CHECKLIST FOR BACKEND TEAM:
 *
 * [ ] Updated createCheckoutSession to use egygo:// URLs
 * [ ] Added logging to verify URLs are correct
 * [ ] Tested checkout session creation
 * [ ] Verified URLs in Stripe Dashboard
 * [ ] Webhook still works correctly
 * [ ] Socket events still emit on payment success
 * [ ] Restarted backend server
 *
 * ⚠️ IMPORTANT NOTES:
 *
 * 1. The deep link redirect is for UX ONLY
 * 2. Payment confirmation still comes from webhook
 * 3. Never rely on redirect for payment validation
 * 4. Socket events enable real-time status updates
 * 5. The {CHECKOUT_SESSION_ID} placeholder is replaced by Stripe
 */

