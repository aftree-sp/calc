# Calculator — Google Style

A clean, Google-style calculator built with Flutter, designed for iOS.

## Features

- ➕ Basic operations: addition, subtraction, multiplication, division
- 🔄 Continuous calculation support
- 📊 Expression display (e.g. `3 + 5 =`)
- 🎨 Google-style dark theme UI
- 🔢 Adaptive font size (auto-shrinks for long numbers)
- ⌨️ Backspace, ± toggle, percentage
- 🚫 Division by zero error handling
- 🔁 Repeat last operation with repeated `=` taps

## Screenshots

> TODO: Add screenshots

## Getting Started

Make sure Flutter SDK is installed:

```bash
flutter pub get
flutter run
```

## Build IPA (for iOS)

### Via GitHub Actions (Recommended)

1. Push to GitHub
2. Go to **Actions → Build iOS IPA → Run workflow**
3. Download the `calculator-ipa` artifact when done

### Local Build

```bash
flutter build ios --release --no-codesign
mkdir -p Payload
cp -r build/ios/iphoneos/Runner.app Payload/
zip -r calculator.ipa Payload
rm -rf Payload
```

> ⚠️ The generated IPA is unsigned. You need an Apple Developer certificate to install on a real device.

## Project Structure

```
lib/
├── main.dart         # App entry point & Google-style UI
└── calculator.dart   # Calculator logic (operators, display, formatting)
```

## Testing

```bash
flutter test
```

## License

MIT
