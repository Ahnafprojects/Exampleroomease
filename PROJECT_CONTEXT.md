# RoomEase — Project Context & Handoff

> **Cara pakai file ini:** Paste isi file ini di awal sesi Claude baru, lalu langsung kasih instruksi tanpa perlu jelasin ulang dari awal. AI akan langsung paham konteks penuh proyek ini.

---

## Apa itu RoomEase?
Aplikasi mobile Flutter untuk booking ruangan meeting di kantor. Bahasa Indonesia. Android only.

---

## Stack & Tools
- **Flutter** (Android only, `--platforms android`)
- **Dart SDK** ^3.10.4
- **Google Fonts** — font Sora
- **shared_preferences** — simpan state
- **intl** — format tanggal
- **Icons** — Material Icons (BUKAN emoji, bukan Phosphor)
- **Target device** — Pixel 9 Pro XL emulator (emulator-5556, Android 16 API 36)

---

## Design System
| Token | Value |
|---|---|
| Navy (primary) | `#1C2B4A` |
| Amber (accent) | `#F59E0B` |
| Background | `#F5F4F0` |
| Surface (card) | `#FFFFFF` |
| Green (success) | `#16A34A` |
| Red (error) | `#DC2626` |
| Orange (warning) | `#D97706` |
| Text primary | `#111827` |
| Text secondary | `#6B7280` |
| Border | `#E5E7EB` |

**Font:** Sora (Google Fonts), semua text pakai `GoogleFonts.sora()`
**Border radius:** Card = 16, Button = 12, Pill = 99
**Dark mode:** tersedia, toggle di halaman Profil

---

## Struktur File
```
roomease/lib/
├── main.dart                    # App entry + route generator
├── theme.dart                   # AppColors, buildLightTheme(), buildDarkTheme()
├── models/
│   └── models.dart              # Room, Booking, NotificationItem, UserModel, enums
├── data/
│   └── mock_data.dart           # AppData (rooms, bookings, notifications, user, timeSlots)
├── widgets/
│   └── widgets.dart             # Semua widget reusable
└── screens/
    ├── main_screen.dart         # Scaffold + IndexedStack + BottomNav
    ├── s1_splash.dart           # Splash + progress bar
    ├── s2_login.dart            # Login form + SSO
    ├── s3_onboarding.dart       # 3 slide onboarding
    ├── s4_home.dart             # Home dashboard
    ├── s5_rooms.dart            # Cari & filter ruangan
    ├── s6_calendar.dart         # Kalender + timeline
    ├── s7_bookings.dart         # List booking (Aktif & Riwayat tab)
    ├── s8_reports.dart          # Laporan admin + heatmap
    ├── s9_profile.dart          # Profil + dark mode toggle
    ├── s10_room_detail.dart     # Detail ruangan + slot waktu
    ├── s11_booking_form.dart    # Form booking
    ├── s12_checkin.dart         # Check-in + countdown timer
    ├── s13_notifications.dart   # Notifikasi
    ├── s14_booking_success.dart # Sukses booking
    ├── s16_forgot_password.dart # Reset password
    └── s17_edit_profile.dart    # Edit profil
```

---

## Routing (main.dart `onGenerateRoute`)
| Route | Screen | Argument |
|---|---|---|
| `/` | SplashScreen | - |
| `/onboarding` | OnboardingScreen | - |
| `/login` | LoginScreen | - |
| `/forgot-password` | ForgotPasswordScreen | - |
| `/main` | MainScreen | `Map? {tab: int}` |
| `/rooms` | RoomsScreen | - |
| `/calendar` | CalendarScreen | - |
| `/notifications` | NotificationsScreen | - |
| `/room-detail` | RoomDetailScreen | `Room` |
| `/booking-form` | BookingFormScreen | `Map? {room: Room, time: String}` |
| `/checkin` | CheckInScreen | `Booking` |
| `/booking-success` | BookingSuccessScreen | `Booking` |
| `/qr-scan` | QrScanPlaceholder | - |
| `/edit-profile` | EditProfileScreen | - |

---

## Models (models.dart)

### Enums
```dart
enum RoomStatus  { available, booked, checkedin, maintenance }
enum RoomType    { boardroom, meetingRoom, huddleSpace, training }
enum BookingStatus { booked, checkedin, done, cancelled, noshow }
```

### Room
`id, name, type(RoomType), capacity, floor, building, status(RoomStatus), facilities(List<String>), rating, reviews`

### Booking
`id, roomId, roomName, roomType, floor, date, dateShort, time, endTime, duration, keperluan, status(BookingStatus), facilities`

### NotificationItem
`id, type(1-4), read, title, body, time, bookingId, roomId, group(today/yesterday)`

### UserModel
`name, initials, role, dept, email, phone, floor, isAdmin`

---

## Mock Data (AppData class — static, mutable)
- **4 rooms**: Boardroom A, Meeting Room B, Huddle Space C, Training Room D
- **5 bookings**: berbagai status (booked, checkedin, done, cancelled, noshow)
- **5 notifications**: berbagai tipe
- **1 user**: Andi Santoso (default non-admin)
- **Admin login**: `admin@perusahaan.com` / `admin123`
- **User login**: email apapun + password >= 3 karakter (bukan "wrong")

---

## Reusable Widgets (widgets.dart)
| Widget | Kegunaan |
|---|---|
| `StatusPill` | Badge status (tersedia/penuh/dll) — param `bookingStatus` atau `roomStatus` |
| `RoomIconBlock` | Icon kotak per tipe ruangan, size adjustable |
| `RoomCard` | Card ruangan dengan icon, status, fasilitas |
| `BookingCardH` | Card booking horizontal (untuk home scroll) |
| `SectionHeader` | Judul section + tombol action |
| `ShimmerBox` | Animasi shimmer loading |
| `SkeletonRoomCard` | Skeleton loader card ruangan |
| `SkeletonStatCard` | Skeleton loader stat |
| `RoomEaseAppBar` | AppBar custom dengan back button + optional right icon |
| `FacilityChip` | Chip fasilitas (TV, WiFi, dll) dengan icon |
| `AppInputField` | Input form dengan label, icon, error state, focus style |
| `BottomNav` | Bottom navigation 5 tab (4 jika admin) |
| `PrimaryButton` | Tombol utama dengan loading state |

---

## Bottom Navigation Tabs
| Index | Label | Screen | Kondisi |
|---|---|---|---|
| 0 | Beranda | HomeScreen | Selalu |
| 1 | Booking | BookingsScreen | Selalu |
| 2 | Kalender | CalendarScreen | Selalu |
| 3 | Laporan | ReportsScreen | **Hanya admin** |
| 3/4 | Profil | ProfileScreen | Selalu (index menyesuaikan) |

---

## Status & Bug Saat Ini
### Bug yang perlu diperbaiki:
1. **`SkeletonStatCard` error** — `Expanded` dipakai di luar `Row/Column`, muncul di `s4_home.dart` skeleton loading. Fix: ganti `Expanded` jadi `SizedBox` dengan lebar fixed di dalam `SkeletonStatCard`.
2. **RenderFlex overflow 8px** — di beberapa screen ada overflow kecil, perlu dicek satu per satu.
3. **`Incorrect use of ParentDataWidget`** — terkait bug no.1 di atas.

### Status build:
- `flutter build apk --debug` — BERHASIL
- App bisa install & jalan di emulator Pixel 9 Pro XL
- Ada beberapa layout error (lihat bug di atas) yang muncul di runtime tapi app tidak crash

---

## Hal yang Belum Diimplementasi
- Real QR scanner (saat ini placeholder simulasi)
- Persistensi data (SharedPreferences belum dipakai, semua masih in-memory)
- Push notification real
- Backend/API (semua mock)
- S15 QR Code display screen
- Animasi konfetti di booking success

---

## Cara Run
```bash
cd /Users/muhammadahnaf/PENS/PDBL/roomease
flutter run -d emulator-5556
```

## Cara Build APK
```bash
flutter build apk --debug
# output: build/app/outputs/flutter-apk/app-debug.apk
```

---

## Handoff — Riwayat Keputusan & Aturan Penting

### Aturan yang WAJIB diikuti AI
1. **Jangan pakai emoji di kode** — semua icon pakai Material Icons (`Icons.xxx`), bukan emoji unicode
2. **Semua text UI pakai `GoogleFonts.sora()`** — jangan pakai font default Flutter
3. **Warna harus sesuai `AppColors`** — jangan hardcode warna baru, selalu pakai konstanta di `theme.dart`
4. **Android only** — jangan tambah platform iOS/web/desktop
5. **Bahasa Indonesia** — semua label, teks UI, pesan error, snackbar dalam Bahasa Indonesia
6. **Jangan buat file baru kalau bisa edit yang sudah ada** — hindari file bloat
7. **Mock data ada di `AppData` (static, mutable)** — kalau butuh tambah data, tambah di `mock_data.dart`

### Keputusan desain yang sudah diambil
- Phosphor Icons dari desain web diganti ke Material Icons karena Flutter tidak punya package Phosphor yang stabil
- Emoji di desain asli (HTML) sengaja TIDAK diikuti, diganti icon material
- `AppData` sengaja dibuat mutable (bukan final) supaya bisa simulasi perubahan state (cancel booking, checkin, dll)
- `BottomNav` index admin-aware: kalau `isAdmin=true` ada tab Laporan di index 3, Profil geser ke 4
- `MainScreen` pakai `IndexedStack` bukan `PageView` supaya state tiap tab tidak reset saat pindah tab
- Dark mode state disimpan di root `_RoomEaseAppState`, diteruskan via constructor ke `MainScreen` → `ProfileScreen`

### Keputusan teknis yang sudah diambil
- Routing pakai `onGenerateRoute` di `main.dart` (bukan go_router) — cukup untuk skala ini
- Semua screen punya file sendiri `s{nomor}_{nama}.dart` mengikuti penamaan desain asli
- `widgets.dart` satu file untuk semua widget reusable — jangan dipecah kecuali sudah sangat besar
- `AppData.user` adalah object tunggal global yang di-mutasi saat login (bukan state management library)

---

## Handoff — Sesi Sebelumnya (Ringkasan Chat)

### Sesi 1 — Setup & Implementasi Penuh
**Apa yang dikerjakan:**
- Baca desain dari file `RoomEase-print.html` (bundle HTML/CSS/JS dari claude.ai/design)
- Desain punya 20 screen: S1–S17 + beberapa overlay (S18/S19/S20)
- Dibuat Flutter project baru Android only: `flutter create roomease --platforms android`
- Diimplementasi 17 screen lengkap (S15 QR display & S18/S19/S20 overlay belum dibuat screen terpisah)
- Bug ditemukan saat runtime di emulator tapi tidak sempat diperbaiki

**Sumber desain asli:**
- URL: `https://api.anthropic.com/v1/design/h/sFnhq82RswBAyn-ehQa2LQ?open_file=RoomEase-print.html`
- Format: tar.gz berisi HTML prototypes + React components
- Desain pakai: font Sora, warna Navy/Amber, Phosphor Icons, dark mode, Bahasa Indonesia

**Alur navigasi utama (sesuai desain):**
```
S1 Splash → S3 Onboarding (3 slide) → S2 Login → S4 Home (main screen)
S4 → S5 Cari Ruangan → S10 Detail Ruangan → S11 Form Booking → S14 Sukses
S7 Booking Saya → S12 Check-in → (scan QR S15 atau manual)
S9 Profil → S17 Edit Profil
S2 → S16 Lupa Password
```

**Masalah emulator pertama:**
- Emulator lama (emulator-5554) storage penuh → `INSTALL_FAILED_INSUFFICIENT_STORAGE`
- Solusi: buat emulator baru Pixel 9 Pro XL → berhasil install (emulator-5556)

**Bug runtime yang muncul (belum diperbaiki):**
- `SkeletonStatCard` pakai `Expanded` di luar `Row` → `Incorrect use of ParentDataWidget`
- `RenderFlex overflowed by 8.0 pixels` di beberapa screen

---

## Prioritas Pekerjaan Selanjutnya (Backlog)

### P0 — Bug harus fix dulu
- [ ] Fix `SkeletonStatCard` di `widgets.dart` — ganti `Expanded` jadi `SizedBox(width: ..., child: ...)`
- [ ] Fix overflow di screen yang belum diketahui — jalankan app dan cek satu per satu

### P1 — Fitur belum ada
- [ ] Tambah screen S15 — QR Code display (tampilkan QR booking ID setelah checkin)
- [ ] Tambah overlay S18 — Confirm Cancel (bottom sheet sudah ada inline di s7, tapi bisa dipisah)
- [ ] Tambah overlay S20 — Booking Conflict (muncul kalau slot sudah diambil orang lain)

### P2 — Enhancement
- [ ] Pakai SharedPreferences untuk simpan dark mode preference
- [ ] Animasi konfetti di BookingSuccessScreen
- [ ] Real QR scanner (pakai package `mobile_scanner`)
- [ ] Pull-to-refresh di HomeScreen dan BookingsScreen

### P3 — Nanti
- [ ] Integrasi backend/API real
- [ ] Push notification
- [ ] Onboarding skip state (jangan tampil lagi kalau sudah pernah lihat)
