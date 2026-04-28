# RoomEase

Aplikasi booking ruangan berbasis Flutter — manajemen reservasi ruangan jadi mudah.

---

## Persyaratan

- Flutter **3.38.5** (stable)
- Dart **3.10.4**
- Android Studio / VS Code
- Android SDK (untuk build Android)

---

## Setup & Instalasi

### 1. Clone Repository

```bash
git clone https://github.com/Ahnafprojects/Exampleroomease.git
cd Exampleroomease
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Jalankan Aplikasi

```bash
flutter run
```

> Pastikan emulator/device sudah terhubung. Cek dengan `flutter devices`.

---

## Build APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

---

## Struktur Project

```
lib/
├── main.dart               # Entry point
├── theme.dart              # Tema & warna global
├── models/
│   └── models.dart         # Data models
├── data/
│   └── mock_data.dart      # Data dummy
├── screens/
│   ├── s1_splash.dart
│   ├── s2_login.dart
│   ├── s3_onboarding.dart
│   ├── s4_home.dart
│   ├── s5_rooms.dart
│   ├── s6_calendar.dart
│   ├── s7_bookings.dart
│   ├── s8_reports.dart
│   ├── s9_profile.dart
│   ├── s10_room_detail.dart
│   ├── s11_booking_form.dart
│   ├── s12_checkin.dart
│   ├── s13_notifications.dart
│   ├── s14_booking_success.dart
│   ├── s16_forgot_password.dart
│   └── s17_edit_profile.dart
└── widgets/
    └── widgets.dart        # Widget reusable
```

---

## Dependencies

| Package | Versi | Kegunaan |
|---|---|---|
| `google_fonts` | ^6.2.1 | Font kustom |
| `intl` | ^0.19.0 | Format tanggal & angka |
| `shared_preferences` | ^2.3.2 | Penyimpanan lokal |

---

## Flutter Version

Project ini menggunakan Flutter `3.38.5` dan Dart `3.10.4`.

Untuk memastikan versi Flutter kamu sesuai:

```bash
flutter --version
```

Jika belum install Flutter, ikuti panduan resmi: https://docs.flutter.dev/get-started/install
