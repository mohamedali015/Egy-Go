@echo off
REM ============================================================
REM Stripe Deep Link Testing for EgyGo Flutter App
REM Run this on Windows to test deep link redirects
REM ============================================================

echo.
echo ========================================
echo   EgyGo Stripe Deep Link Tester
echo ========================================
echo.

:menu
echo Choose a test:
echo.
echo 1. Test Payment SUCCESS (with test trip ID)
echo 2. Test Payment CANCEL (with test trip ID)
echo 3. Test Payment SUCCESS (enter your trip ID)
echo 4. Test Payment CANCEL (enter your trip ID)
echo 5. Check if app is installed
echo 6. View deep link logs (live)
echo 7. Clear app data and cache
echo 8. Exit
echo.
set /p choice="Enter your choice (1-8): "

if "%choice%"=="1" goto test_success_dummy
if "%choice%"=="2" goto test_cancel_dummy
if "%choice%"=="3" goto test_success_real
if "%choice%"=="4" goto test_cancel_real
if "%choice%"=="5" goto check_app
if "%choice%"=="6" goto view_logs
if "%choice%"=="7" goto clear_data
if "%choice%"=="8" goto end
goto menu

:test_success_dummy
echo.
echo ========================================
echo Testing Payment SUCCESS
echo ========================================
echo.
echo Sending deep link: egygo://payment/success?tripId=694e30b41e835afb38e3eb90^&session_id=cs_test_dummy123
echo.
adb shell am start -a android.intent.action.VIEW -d "egygo://payment/success?tripId=694e30b41e835afb38e3eb90&session_id=cs_test_dummy123"
echo.
echo ✅ Command sent!
echo.
echo Expected behavior:
echo - App should open automatically
echo - You should see a success screen with green checkmark
echo - After 2 seconds, should navigate to trip details
echo.
echo Check logs with option 6 if app doesn't open
echo.
pause
goto menu

:test_cancel_dummy
echo.
echo ========================================
echo Testing Payment CANCEL
echo ========================================
echo.
echo Sending deep link: egygo://payment/cancel?tripId=694e30b41e835afb38e3eb90
echo.
adb shell am start -a android.intent.action.VIEW -d "egygo://payment/cancel?tripId=694e30b41e835afb38e3eb90"
echo.
echo ✅ Command sent!
echo.
echo Expected behavior:
echo - App should open automatically
echo - You should see "Payment Cancelled" snackbar at top
echo - Should navigate directly to trip details
echo.
pause
goto menu

:test_success_real
echo.
echo ========================================
echo Testing Payment SUCCESS (Custom Trip)
echo ========================================
echo.
set /p tripid="Enter your Trip ID: "
echo.
echo Sending deep link with trip ID: %tripid%
echo.
adb shell am start -a android.intent.action.VIEW -d "egygo://payment/success?tripId=%tripid%&session_id=cs_test_dummy123"
echo.
echo ✅ Command sent!
echo.
pause
goto menu

:test_cancel_real
echo.
echo ========================================
echo Testing Payment CANCEL (Custom Trip)
echo ========================================
echo.
set /p tripid="Enter your Trip ID: "
echo.
echo Sending deep link with trip ID: %tripid%
echo.
adb shell am start -a android.intent.action.VIEW -d "egygo://payment/cancel?tripId=%tripid%"
echo.
echo ✅ Command sent!
echo.
pause
goto menu

:check_app
echo.
echo ========================================
echo Checking App Installation
echo ========================================
echo.
adb shell pm list packages | findstr egy_go
if errorlevel 1 (
    echo ❌ App NOT installed!
    echo.
    echo Install with: flutter run
) else (
    echo ✅ App is installed!
    echo.
    echo App details:
    adb shell dumpsys package com.example.egy_go | findstr "versionName\|versionCode"
)
echo.
pause
goto menu

:view_logs
echo.
echo ========================================
echo Viewing Deep Link Logs (Press Ctrl+C to stop)
echo ========================================
echo.
echo Looking for: DeepLink, MyApp, PaymentReturn, egygo
echo.
adb logcat -c
adb logcat | findstr /i "DeepLink MyApp PaymentReturn egygo payment flutter"
pause
goto menu

:clear_data
echo.
echo ========================================
echo Clearing App Data
echo ========================================
echo.
set /p confirm="Are you sure? This will clear all app data (y/n): "
if /i "%confirm%"=="y" (
    adb shell pm clear com.example.egy_go
    echo ✅ App data cleared!
) else (
    echo ❌ Cancelled
)
echo.
pause
goto menu

:end
echo.
echo ========================================
echo Testing Complete
echo ========================================
echo.
echo For full payment flow testing:
echo 1. Backend must use egygo:// URLs
echo 2. Complete a real payment on Stripe
echo 3. App should automatically open after payment
echo.
echo See STRIPE_DEEP_LINK_COMPLETE.md for more info
echo.
pause
exit

REM ============================================================
REM TROUBLESHOOTING
REM ============================================================
REM
REM Issue: "App doesn't open"
REM Solution:
REM   1. Check app is installed (option 5)
REM   2. Check logs (option 6)
REM   3. Verify AndroidManifest has intent-filter
REM
REM Issue: "Error: device not found"
REM Solution:
REM   1. Connect device via USB
REM   2. Enable USB debugging
REM   3. Run: adb devices
REM
REM Issue: "Deep link received but nothing happens"
REM Solution:
REM   1. Check logs for errors
REM   2. Verify trip ID is valid
REM   3. Clear app data (option 7) and try again
REM
REM ============================================================

