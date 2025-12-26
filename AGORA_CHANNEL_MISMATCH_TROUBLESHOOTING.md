# Agora Call Channel Mismatch - Troubleshooting Guide

## Problem

Tourist and Guide are not joining the same Agora channel - both see "Waiting for other to join"
instead of seeing each other's video.

## Root Cause

This happens when:

1. **Different Channel Names**: Tourist and Guide are joining different channels
2. **Invalid Tokens**: One or both tokens don't match the channel name
3. **Backend Issue**: Backend is generating separate channels instead of reusing the same channel

## How Agora Works

For a successful video call, **both users MUST**:

- ✅ Use the **exact same Channel Name**
- ✅ Have **different UIDs** (e.g., Tourist: 1, Guide: 2)
- ✅ Use valid **tokens** generated for that specific channel

## Diagnostic Steps

### Step 1: Check Flutter Logs (Tourist Side)

Run the Flutter app and initiate a call. Look for these logs:

```
═══════════════════════════════════════════
[AgoraCall] INITIALIZING AGORA CALL
═══════════════════════════════════════════
[AgoraCall] App ID: 1234567890abcdef
[AgoraCall] Channel Name: trip_64abc123_call_456def
[AgoraCall] UID: 1
[AgoraCall] Token: 006abc123def456...
[AgoraCall] Call ID: 64xyz...
[AgoraCall] Trip ID: 64abc...
═══════════════════════════════════════════
[AgoraCall] Engine initialized
[AgoraCall] Preview started
[AgoraCall] Joining channel...
[AgoraCall] Channel: trip_64abc123_call_456def
[AgoraCall] UID: 1
[AgoraCall] Join channel request sent
[AgoraCall] ✅ Local user 1 joined channel: trip_64abc123_call_456def
```

**Copy the Channel Name!** (e.g., `trip_64abc123_call_456def`)

### Step 2: Check React Website Logs (Guide Side)

When the guide clicks "Join Call", check the browser console for:

```javascript
[Agora] Joining channel: trip_DIFFERENT_NAME_789  // ❌ WRONG!
[Agora] UID: 2
```

### Step 3: Compare Channel Names

**CORRECT Scenario:**

```
Tourist Channel: trip_64abc123_call_456def
Guide Channel:   trip_64abc123_call_456def  // ✅ SAME!
```

**INCORRECT Scenario:**

```
Tourist Channel: trip_64abc123_call_456def
Guide Channel:   trip_64abc123_call_789xyz  // ❌ DIFFERENT!
```

## Backend API Flow (What Should Happen)

### Tourist Initiates Call

```http
POST /trips/64abc123/calls/initiate
Authorization: Bearer <tourist_token>

Response:
{
  "success": true,
  "callId": "456def",
  "tripId": "64abc123",
  "token": {
    "appId": "1234567890abcdef",
    "channelName": "trip_64abc123_call_456def",  // ⚠️ REMEMBER THIS!
    "uid": 1,
    "token": "006abc...",
    "expiresAt": "2025-12-24T12:00:00Z"
  }
}
```

### Guide Joins Call

```http
POST /calls/456def/join  // OR similar endpoint
Authorization: Bearer <guide_token>

Response:
{
  "success": true,
  "callId": "456def",
  "tripId": "64abc123",
  "token": {
    "appId": "1234567890abcdef",
    "channelName": "trip_64abc123_call_456def",  // ✅ SAME AS TOURIST!
    "uid": 2,  // ⚠️ DIFFERENT UID!
    "token": "007xyz...",  // Different token, same channel
    "expiresAt": "2025-12-24T12:00:00Z"
  }
}
```

## Backend Fix Required

If channel names are different, the backend needs to fix the guide join endpoint:

### ❌ Current Backend Code (Likely Bug)

```javascript
// Guide joining - WRONG!
async function guideJoinCall(callId, guideId) {
  // BUG: Generating NEW channel name instead of reusing existing one
  const channelName = `trip_${tripId}_call_${Date.now()}`;  // ❌ NEW!
  
  const token = await agoraService.generateToken(channelName, guideId);
  
  return {
    channelName,  // ❌ Different from tourist's channel!
    uid: guideId,
    token
  };
}
```

### ✅ Correct Backend Code

```javascript
// Guide joining - CORRECT!
async function guideJoinCall(callId, guideId) {
  // Get the EXISTING call from database
  const call = await Call.findById(callId).populate('trip');
  
  // Use the EXISTING channel name from the call
  const channelName = call.channelName;  // ✅ REUSE!
  
  const token = await agoraService.generateToken(channelName, guideId);
  
  return {
    channelName,  // ✅ Same as tourist's channel!
    uid: guideId,
    token
  };
}
```

## Quick Test

### Test 1: Manual Channel Join

1. Tourist initiates call → Note the `channelName` from logs
2. In React website, **manually override** the channel name in the code:
   ```javascript
   const channelName = "trip_64abc123_call_456def";  // From tourist logs
   ```
3. Guide joins → Check if they can now see each other
4. If YES → Backend is the issue (generating different channels)

### Test 2: Check Backend Database

```javascript
// In backend, check the calls collection
db.calls.find({ _id: "456def" })

// Should have:
{
  _id: "456def",
  tripId: "64abc123",
  channelName: "trip_64abc123_call_456def",  // This is stored
  touristUid: 1,
  guideUid: 2,
  status: "active"
}
```

## Backend Action Items

1. **Store Channel Name**: When tourist initiates call, save `channelName` in database
2. **Reuse Channel Name**: When guide joins, read `channelName` from database
3. **Assign Different UIDs**: Tourist gets UID 1, Guide gets UID 2
4. **Generate Valid Tokens**: Both tokens must be for the same channel name

## Frontend Verification

Once backend is fixed, you should see in logs:

**Tourist:**

```
[AgoraCall] Channel Name: trip_64abc123_call_456def
[AgoraCall] UID: 1
[AgoraCall] ✅ Local user 1 joined channel: trip_64abc123_call_456def
[AgoraCall] 🎉 Remote user 2 joined channel: trip_64abc123_call_456def  // Guide!
```

**Guide (React):**

```
[Agora] Channel Name: trip_64abc123_call_456def  // Same!
[Agora] UID: 2
[Agora] ✅ Local user 2 joined
[Agora] 🎉 Remote user 1 joined  // Tourist!
```

## Summary

The issue is almost certainly in the **backend's guide join endpoint**. The backend is generating a
new channel name for the guide instead of reusing the tourist's channel name.

**Fix:** Backend must store and reuse the same `channelName` for both users.

---

**Last Updated:** December 24, 2025

