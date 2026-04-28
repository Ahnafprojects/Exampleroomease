import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';
import 'screens/s1_splash.dart';
import 'screens/s2_login.dart';
import 'screens/s3_onboarding.dart';
import 'screens/s5_rooms.dart';
import 'screens/s6_calendar.dart';
import 'screens/s10_room_detail.dart';
import 'screens/s11_booking_form.dart';
import 'screens/s12_checkin.dart';
import 'screens/s13_notifications.dart';
import 'screens/s14_booking_success.dart';
import 'screens/s16_forgot_password.dart';
import 'screens/s17_edit_profile.dart';
import 'screens/main_screen.dart';
import 'models/models.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const RoomEaseApp());
}

class RoomEaseApp extends StatefulWidget {
  const RoomEaseApp({super.key});

  @override
  State<RoomEaseApp> createState() => _RoomEaseAppState();
}

class _RoomEaseAppState extends State<RoomEaseApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoomEase',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashScreen());

          case '/onboarding':
            return MaterialPageRoute(builder: (_) => const OnboardingScreen());

          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());

          case '/forgot-password':
            return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

          case '/main':
            final args = settings.arguments as Map<String, dynamic>?;
            final tab = (args?['tab'] as int?) ?? 0;
            return MaterialPageRoute(
              builder: (_) => MainScreen(
                initialTab: tab,
                isDarkMode: _isDarkMode,
                onDarkModeToggle: () => setState(() => _isDarkMode = !_isDarkMode),
              ),
            );

          case '/rooms':
            return MaterialPageRoute(builder: (_) => const RoomsScreen());

          case '/calendar':
            return MaterialPageRoute(builder: (_) => const CalendarScreen());

          case '/notifications':
            return MaterialPageRoute(builder: (_) => const NotificationsScreen());

          case '/room-detail':
            final room = settings.arguments as Room;
            return MaterialPageRoute(builder: (_) => RoomDetailScreen(room: room));

          case '/booking-form':
            final args = settings.arguments as Map<String, dynamic>?;
            final room = args?['room'] as Room?;
            final time = args?['time'] as String?;
            return MaterialPageRoute(
              builder: (_) => BookingFormScreen(room: room, preTime: time),
            );

          case '/checkin':
            final booking = settings.arguments as Booking;
            return MaterialPageRoute(builder: (_) => CheckInScreen(booking: booking));

          case '/booking-success':
            final booking = settings.arguments as Booking;
            return MaterialPageRoute(builder: (_) => BookingSuccessScreen(booking: booking));

          case '/qr-scan':
            return MaterialPageRoute(builder: (_) => const QrScanPlaceholder());

          case '/edit-profile':
            return MaterialPageRoute(builder: (_) => const EditProfileScreen());

          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Center(child: Text('404'))),
            );
        }
      },
    );
  }
}

class QrScanPlaceholder extends StatelessWidget {
  const QrScanPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 240, height: 240,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.amber, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, size: 80, color: AppColors.amber),
                  SizedBox(height: 16),
                  Text(
                    'Arahkan kamera\nke QR Code',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.green,
                          content: const Text('QR Code berhasil discan!'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                    child: Container(
                      height: 52, width: 200,
                      decoration: BoxDecoration(color: AppColors.amber, borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                        child: Text(
                          'Simulasi Scan',
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
