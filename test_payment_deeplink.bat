@echo off
REM Stripe Payment Deep Link Testing Script for Android
REM Use this to manually test deep link handling without going through Stripe

echo ============================================
echo Stripe Payment Deep Link Tester
echo ============================================
echo.

:menu
echo Choose a test:
echo 1. Test Payment Success
echo 2. Test Payment Cancel
echo 3. Test with Real Trip ID
echo 4. Check if app is installed
echo 5. View app logs
echo 6. Exit
echo.
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto test_success
if "%choice%"=="2" goto test_cancel
if "%choice%"=="3" goto test_real
if "%choice%"=="4" goto check_app
if "%choice%"=="5" goto view_logs
if "%choice%"=="6" goto end

:test_success
echo.
echo Testing Payment Success with dummy trip ID...
adb shell am start -a android.intent.action.VIEW -d "egygo://payment/success?trip_id=694e30b41e835afb38e3eb90&session_id=cs_test_dummy123"
echo.
echo If app opened, check for:
echo - Green success screen
echo - "Payment Successful!" message
echo - Auto-navigation to trip details
echo.
pause
goto menu

:test_cancel
echo.
echo Testing Payment Cancel with dummy trip ID...
adb shell am start -a android.intent.action.VIEW -d "egygo://payment/cancel?trip_id=694e30b41e835afb38e3eb90"
echo.
echo If app opened, check for:
echo - Orange cancel screen
echo - "Payment Cancelled" message
echo - "Try Again" button
echo.
pause
goto menu

:test_real
echo.
set /p tripid="Enter your real Trip ID: "
echo.
echo Testing with trip ID: %tripid%
adb shell am start -a android.intent.action.VIEW -d "egygo://payment/success?trip_id=%tripid%&session_id=cs_test_dummy123"
echo.
pause
goto menu

:check_app
echo.
echo Checking if EgyGo app is installed...
adb shell pm list packages | findstr egy_go
echo.
if errorlevel 1 (
    echo App NOT found! Install with: flutter run
) else (
    echo App found!
)
echo.
pause
goto menu

:view_logs
echo.
echo Viewing app logs (Press Ctrl+C to stop)...
echo.
adb logcat | findstr /i "deeplink egygo payment flutter"
pause
goto menu

:end
echo.
echo Goodbye!
exit
