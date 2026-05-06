# RoomEase — Reference App

> **Ini adalah aplikasi referensi / contoh desain.**
> Project ini dibuat sebagai blueprint visual dan arsitektur untuk pengembangan aplikasi RoomEase yang sesungguhnya. Developer dapat melihat, mempelajari, dan meng-copy struktur, komponen, serta alur dari project ini ke project Flutter baru yang real.

---

## Tujuan Project Ini

| | Deskripsi |
|---|---|
| **Tipe** | Reference / Example App |
| **Fungsi** | Blueprint desain & arsitektur untuk project real |
| **Data** | Semua data adalah mock (dummy), tidak ada koneksi backend |
| **Status** | Lengkap sebagai prototipe — tidak untuk production |

Ketika memulai project real baru:
1. Buat Flutter project baru
2. Gunakan `lib/widgets/` sebagai design system
3. Gunakan `lib/theme.dart` sebagai color & typography token
4. Gunakan `lib/models/` sebagai referensi data model
5. Copy screen yang dibutuhkan dari `lib/screens/`

---

## Alur Aplikasi

```
Splash → Onboarding → Login / Register → OTP Verify → Home
                                                       ↓
                                 Booking · Kalender · Laporan · Profil
```

### Login Demo

| Role | Email | Password |
|---|---|---|
| Admin GA | `admin@perusahaan.com` | `admin123` |
| Karyawan | email apapun | password ≥ 3 karakter |

### OTP Demo
Kode apapun kecuali `000000` akan dianggap valid.

---

## Persyaratan

- Flutter **3.38.5** (stable) / Dart **3.10.4**
- Android Studio atau VS Code
- Android SDK (untuk build Android)

---

## Setup & Menjalankan

```bash
# 1. Clone
git clone https://github.com/Ahnafprojects/Exampleroomease.git
cd Exampleroomease

# 2. Install dependencies
flutter pub get

# 3. Jalankan
flutter run
```

> Cek device: `flutter devices`

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
├── main.dart                        # Router & entry point
├── theme.dart                       # Color tokens & typography
│
├── models/
│   ├── models.dart                  # Barrel export
│   ├── enums.dart                   # RoomStatus, RoomType, BookingStatus
│   ├── room.dart                    # Room model
│   ├── booking.dart                 # Booking model
│   ├── notification.dart            # NotificationItem model
│   └── user.dart                    # UserModel
│
├── data/
│   └── mock_data.dart               # Semua data dummy (rooms, bookings, dll)
│
├── screens/
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── otp_verify_screen.dart       # Verifikasi OTP setelah register
│   ├── forgot_password_screen.dart
│   ├── main_screen.dart             # Shell + bottom navigation
│   ├── home_screen.dart
│   ├── rooms_screen.dart
│   ├── calendar_screen.dart
│   ├── bookings_screen.dart
│   ├── reports_screen.dart          # Khusus Admin GA
│   ├── profile_screen.dart
│   ├── room_detail_screen.dart
│   ├── booking_form_screen.dart
│   ├── checkin_screen.dart
│   ├── notifications_screen.dart
│   ├── booking_success_screen.dart
│   ├── edit_profile_screen.dart
│   └── qr_scan_screen.dart
│
└── widgets/
    ├── widgets.dart                 # Barrel export (import ini saja)
    ├── app_bar.dart                 # RoomEaseAppBar
    ├── auth_shell.dart              # Layout shell login & register
    ├── booking_card.dart            # BookingCardH
    ├── bottom_nav.dart              # BottomNav
    ├── buttons.dart                 # PrimaryButton, AuthCTAButton
    ├── input_field.dart             # AppInputField
    ├── room_card.dart               # RoomCard, RoomIconBlock
    ├── skeleton.dart                # ShimmerBox, SkeletonRoomCard, dll
    └── status_pill.dart             # StatusPill, FacilityChip, SectionHeader
```

---

## Design System

Semua warna, ukuran, dan style ada di `lib/theme.dart`. Gunakan `AppColors.*` di mana pun.

| Token | Nilai | Penggunaan |
|---|---|---|
| `AppColors.navy` | `#1C2B4A` | Primary, header, button |
| `AppColors.amber` | `#F59E0B` | Accent, CTA, highlight |
| `AppColors.bg` | `#F5F4F0` | Background halaman |
| `AppColors.surface` | `#FFFFFF` | Card, modal |
| `AppColors.t1` | `#111827` | Teks utama |
| `AppColors.t2` | `#6B7280` | Teks sekunder |
| `AppColors.t3` | `#9CA3AF` | Placeholder, hint |
| `AppColors.border` | `#E5E7EB` | Border input & card |

Font: **Sora** (via `google_fonts`)

---

## Dependencies

| Package | Versi | Kegunaan |
|---|---|---|
| `google_fonts` | ^6.2.1 | Font Sora |
| `intl` | ^0.19.0 | Format tanggal & angka |
| `shared_preferences` | ^2.3.2 | Penyimpanan lokal |

---

## Catatan untuk Developer

- Semua navigasi menggunakan **named routes** (lihat `main.dart`)
- Import widget cukup dengan `import '../widgets/widgets.dart'`
- Import model cukup dengan `import '../models/models.dart'`
- Tidak ada state management library — gunakan `setState` atau ganti dengan Riverpod/Bloc di project real
- Tidak ada koneksi API — semua data dari `lib/data/mock_data.dart`
