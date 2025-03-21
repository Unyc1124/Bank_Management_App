import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bankapp/screens/home_page.dart';
import 'package:bankapp/screens/login_page_1.dart';

class LoginPage2 extends StatefulWidget {
  const LoginPage2({super.key});

  @override
  State<LoginPage2> createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
  final LocalAuthentication auth = LocalAuthentication();
  String userName = "User"; // Default name

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedName = prefs.getString('userName');

    User? user = FirebaseAuth.instance.currentUser;
    if (storedName != null) {
      // Use stored name if available
      setState(() {
        userName = storedName;
      });
    } else if (user != null) {
      // Fetch user data from Firestore
      String uid = user.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'] ?? "User";
        });

        // Save name to SharedPreferences for future use
        prefs.setString('userName', userName);
      }
    }
  }

  Future<void> _authenticate() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Authenticate to continue',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Biometric authentication failed")),
      );
    }

    if (isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear stored preferences
    await FirebaseAuth.instance.signOut(); // Sign out from Firebase

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.person, size: 100, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                "Welcome back, $userName 👋", // Displays the username from Firestore
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.fingerprint),
                label: const Text("Login with Biometrics"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _logout,
                child: const Text("Logout", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
