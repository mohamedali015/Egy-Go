# Backend Connection Issue - DevTunnel Expired

## Problem

Your backend server at `1p1jgw5z-5001.euw.devtunnels.ms` is not reachable.

**Error:** `Failed host lookup: '1p1jgw5z-5001.euw.devtunnels.ms'`

## Why This Happens

DevTunnels are **temporary development tunnels** that:

- Expire after a certain time (usually 24-48 hours)
- Stop when the backend server restarts
- Require the tunnel to be actively running

## IMMEDIATE SOLUTION

### Option 1: Get New DevTunnel URL (Recommended)

Ask your backend team to:

1. Restart the DevTunnel on their machine
2. Get the new tunnel URL (e.g., `https://xxxxxxx-5001.euw.devtunnels.ms`)
3. Send you the new URL

Then update this file:

```dart
// lib/core/network/end_points.dart
abstract class EndPoints {
  static const String baseUrl = 'https://NEW-TUNNEL-URL/api/';
  // Replace NEW-TUNNEL-URL with the actual new tunnel URL
}
```

### Option 2: Use Local Backend (If Backend is on Same Network)

If the backend is running locally, use:

```dart
static const String baseUrl = 'http://BACKEND-IP-ADDRESS:5001/api/';
// Example: 'http://192.168.1.100:5001/api/'
```

### Option 3: Deploy Backend to Production Server

For permanent solution, backend should be deployed to:

- Heroku
- Railway
- Render
- DigitalOcean
- AWS/Azure/GCP

Then use:

```dart
static const String baseUrl = 'https://your-app.herokuapp.com/api/';
```

## Socket URL Update Needed Too

Also update socket URL in:

```dart
// lib/core/network/socket_service.dart
String get _socketUrl {
  const baseUrl = 'https://NEW-TUNNEL-URL'; // Update here too
  return baseUrl;
}
```

## Quick Test

After backend team restarts the tunnel, test if it's working:

```bash
curl https://NEW-TUNNEL-URL/api/
```

---

**Current Status:** Backend is DOWN or tunnel expired
**Action Required:** Get new tunnel URL from backend team

