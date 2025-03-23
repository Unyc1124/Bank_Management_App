import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bankapp/screens/signup_page.dart';
import 'package:bankapp/screens/login_page_2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sensors_plus/sensors_plus.dart'; // Import for shake detection
import 'package:flutter/services.dart'; // For closing the app
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BankApp());
}

class BankApp extends StatelessWidget {
  const BankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank App',
      theme: ThemeData.light(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const double SHAKE_THRESHOLD = 20.0; // Adjust for sensitivity
  int shakeCount = 0;
  AccelerometerEvent? _lastEvent;
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    _listenToShake();
  }

  /// Detects shakes by monitoring accelerometer events
  void _listenToShake() {
    accelerometerEvents.listen((event) {
      if (_lastEvent != null) {
        double deltaX = event.x - _lastEvent!.x;
        double deltaY = event.y - _lastEvent!.y;
        double deltaZ = event.z - _lastEvent!.z;

        double speed = sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ);

        if (speed > SHAKE_THRESHOLD) {
          shakeCount++;
          if (shakeCount >= 2) {
            _closeApp();
          }
        }
      }

      _lastEvent = event;

      _resetTimer?.cancel();
      _resetTimer = Timer(const Duration(seconds: 1), () {
        shakeCount = 0; // Reset shake count after 1 second
      });
    });
  }

  /// Closes the app when a shake is detected
  void _closeApp() {
    SystemNavigator.pop(); // Exits the app
  }

  /// Navigates to Login or Signup page based on saved preference
  Future<void> _navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage2()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignupPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.white,
      Colors.purple,
      Colors.blue,
      Colors.white,
      Colors.yellow,
      Colors.red,
      Colors.white,
    ];
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Opacity
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.jpg'), // Your background image
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.4), // Color overlay for opacity
            ),
          ),
          // Foreground Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
                DefaultTextStyle(
                  style: GoogleFonts.ribeyeMarrow(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText(
                        'Welcome to',
                        textStyle: GoogleFonts.ribeyeMarrow(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),
                      ColorizeAnimatedText(
                        '🏦 WORLD BANK',
                        textStyle: GoogleFonts.ribeyeMarrow(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                        colors: colorizeColors,
                      ),
                    ],
                    isRepeatingAnimation: true,
                  ),
                ),
                const SizedBox(height: 30),
                Icon(
                  Icons.business_center_outlined,
                  size: 150.0,
                  color: Colors.white.withOpacity(0.85),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _navigateToNextScreen, // Navigates only when tapped
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.85),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(color: Color.fromARGB(255, 21, 21, 22)),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Shake to Exit",
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
