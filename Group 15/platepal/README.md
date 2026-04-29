# 🍱 PlatePal — Food Waste Reduction Platform

A Flutter app that connects users with local restaurants and bakeries selling surplus food in "surprise bags" at up to 70% off, reducing food waste while making meals affordable.

---

## 📱 Screens & Features

| Screen | Description |
|--------|-------------|
| **Splash** | Animated logo + tagline |
| **Onboarding** | 3-page intro carousel |
| **Discover (Home)** | Bag listings with search, category filter, promo banner |
| **Bag Detail** | Full info: image, price, pickup window, impact stats, reserve button |
| **Map** | Simulated geo map with price markers and nearby bag list |
| **My Bags** | Active & past reservations with pickup codes |
| **Impact Dashboard** | Bar chart, stat grid, achievements, community stats |
| **Profile** | User info, quick stats, settings menu |
| **Retailer Listing** | Form for businesses to post surplus bags |

---

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK ≥ 3.0.0 — [Install Flutter](https://docs.flutter.dev/get-started/install)
- Dart SDK ≥ 3.0.0 (comes with Flutter)
- Android Studio / VS Code with Flutter extension
- An Android emulator or physical device (iOS simulator works too)

### 1. Add Google Fonts (Nunito)

In `pubspec.yaml`, add the `google_fonts` package or download **Nunito** locally:

Option A — use `google_fonts` package (add to pubspec.yaml):
```yaml
dependencies:
  google_fonts: ^6.2.1
```

Then in `app_theme.dart`, replace `fontFamily: 'Nunito'` with:
```dart
import 'package:google_fonts/google_fonts.dart';
// In ThemeData:
textTheme: GoogleFonts.nunitoTextTheme(),
```

Option B — embed locally:
```
assets/fonts/Nunito-Regular.ttf
assets/fonts/Nunito-Bold.ttf
assets/fonts/Nunito-ExtraBold.ttf
```

### 2. Install Dependencies
```bash
cd platepal
flutter pub get
```

### 3. Run the App
```bash
# List available devices
flutter devices

# Run on a specific device
flutter run -d <device_id>

# Run in release mode
flutter run --release
```

---

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `fl_chart` | Bar charts in Impact dashboard |
| `google_maps_flutter` | (Optional) Replace simulated map with real Google Maps |
| `geolocator` | (Optional) Get real user location |
| `intl` | Date/time formatting |
| `shared_preferences` | Persist user data locally |
| `cached_network_image` | Efficient image loading |

---

## 🗂 Project Structure

```
lib/
├── main.dart                    # App entry point
├── app_theme.dart               # Colors, typography, theme
├── app_provider.dart            # Global state (ChangeNotifier)
├── models/
│   └── models.dart              # FoodBag, Reservation, ImpactStats
├── data/
│   └── mock_data.dart           # Sample data for 6 food bags
├── screens/
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── main_shell.dart          # Bottom nav shell
│   ├── home_screen.dart         # Discover tab
│   ├── bag_detail_screen.dart   # Bag detail + reservation
│   ├── map_screen.dart          # Geo map view
│   ├── reservations_screen.dart # My bags
│   ├── impact_screen.dart       # Impact dashboard
│   ├── profile_screen.dart      # User profile
│   └── retailer_screen.dart     # Business listing form
└── widgets/
    ├── bag_card.dart            # Reusable food bag card
    └── category_chip.dart       # Reusable filter chip
```

---

## 🌐 Adding Real Google Maps

1. Get a Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_API_KEY"/>
```
3. Replace `MapScreen`'s simulated map with `GoogleMap` widget:
```dart
GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(19.2403, 73.1305),
    zoom: 14,
  ),
  markers: _buildMarkers(bags),
)
```

---

## 🎯 Goals Addressed

| Goal | Implementation |
|------|---------------|
| ≥30% daily food waste reduction | Surplus bag listings with pickup windows |
| Affordable meals for students | 60–70% discounted bags clearly shown |
| Environmental awareness | CO₂ + kg saved per bag + dashboard |
| Drive foot traffic | Geo discovery + map integration |

---

## 🔮 Future Enhancements

- [ ] Firebase Auth + Firestore backend
- [ ] Real-time bag availability updates
- [ ] Push notifications for new nearby bags
- [ ] In-app payment (Razorpay / UPI)
- [ ] Retailer analytics dashboard
- [ ] Social sharing of impact milestones
- [ ] Multi-language support (Hindi, Marathi)
- [ ] Rating & review system for bags

---

## 📄 License
MIT — Free to use, modify, and distribute.
