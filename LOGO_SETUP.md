# App Logo Setup Instructions

## 1. Adding the Logo Image

Place your app logo image file (`app_logo.png`) in the following location:
```
assets/images/app_logo.png
```

**Recommended specifications:**
- Format: PNG with transparent background
- Size: At least 512x512 pixels (square)
- File name: `app_logo.png`

## 2. App Icon Setup

### Android App Icon

To replace the Flutter default icon with your app logo, you need to generate app icons in different sizes and place them in:

```
android/app/src/main/res/
├── mipmap-mdpi/ic_launcher.png (48x48)
├── mipmap-hdpi/ic_launcher.png (72x72)
├── mipmap-xhdpi/ic_launcher.png (96x96)
├── mipmap-xxhdpi/ic_launcher.png (144x144)
└── mipmap-xxxhdpi/ic_launcher.png (192x192)
```

**Easy way to generate icons:**
1. Use an online tool like [App Icon Generator](https://appicon.co/) or [Icon Kitchen](https://icon.kitchen/)
2. Upload your `app_logo.png` (512x512 or larger)
3. Download the generated Android icons
4. Replace the existing `ic_launcher.png` files in the folders above

### iOS App Icon

For iOS, place your app icons in:
```
ios/Runner/Assets.xcassets/AppIcon.appiconset/
```

You can use the same online tools mentioned above to generate iOS icons.

### Web Favicon

Replace the favicon at:
```
web/favicon.png
```

Use a 192x192 or 512x512 PNG version of your logo.

## 3. Current Implementation

The app logo is currently used in:
- **Splash Screen** (`lib/screens/splash_screen.dart`)
- **Login Screen** (`lib/screens/login_screen.dart`)

If the logo image is not found, the app will fall back to displaying a school icon.

## 4. After Adding the Logo

1. Run `flutter pub get` to ensure assets are registered
2. Restart your app to see the logo
3. For app icons, rebuild the app completely:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## Notes

- The logo should have a transparent background for best results
- Make sure the logo is clearly visible on both light and dark backgrounds
- Test the logo on different screen sizes to ensure it looks good

