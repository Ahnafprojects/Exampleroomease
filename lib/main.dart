import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';
import 'models/models.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/rooms_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/room_detail_screen.dart';
import 'screens/booking_form_screen.dart';
import 'screens/checkin_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/booking_success_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/qr_scan_screen.dart';
import 'screens/otp_verify_screen.dart';
import 'screens/main_screen.dart';

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

          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterScreen());

          case '/forgot-password':
            return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

          case '/otp-verify':
            final email = settings.arguments as String? ?? '';
            return MaterialPageRoute(builder: (_) => OtpVerifyScreen(email: email));

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
            return MaterialPageRoute(builder: (_) => const QrScanScreen());

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
