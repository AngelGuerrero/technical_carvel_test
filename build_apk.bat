@echo off
echo Building release APK...
flutter build apk --release

if %errorlevel% equ 0 (
    echo ✅ APK build successful!
    
    rem APK location
    set APK_PATH=build\app\outputs\flutter-apk\app-release.apk
    
    rem Copy APK to current directory for easy access
    copy "%APK_PATH%" "carvel_home_assessment.apk"
    
    echo 📱 APK available at: %APK_PATH%
    echo 📁 Copied to: carvel_home_assessment.apk
    echo.
    echo 📋 To share the APK:
    echo    1. Send the file 'carvel_home_assessment.apk' to testers
    echo    2. Testers need to enable 'Unknown sources' in Android settings
    echo    3. They can install by opening the APK file
    echo.
    echo 🔒 For production, remember to:
    echo    - Use a secure password for the keystore
    echo    - Keep the keystore file safe (it's in android\app\upload-keystore.jks)
    echo    - Update version numbers in pubspec.yaml before production releases
) else (
    echo ❌ APK build failed!
    exit /b 1
)