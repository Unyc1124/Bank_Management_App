import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanpayTab extends StatefulWidget {
  const ScanpayTab({super.key});

  @override
  _ScanpayTabState createState() => _ScanpayTabState();
}

class _ScanpayTabState extends State<ScanpayTab> {
  String _userName = "Loading..."; // Default name
  final String _upiId = "xxxxxx"; // Static UPI ID

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _userName = "User not logged in";
      });
      return;
    }
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      if (userDoc.exists && mounted) {
        setState(() {
          _userName = userDoc["name"] ?? "User";
        });
      } else {
        setState(() {
          _userName = "No user data found";
        });
      }
    } catch (e) {
      setState(() {
        _userName = "Error fetching name";
      });
      print("🔥 Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String upiUri = "upi://pay?pa=$_upiId&pn=$_userName&am=100&cu=INR";
    return Scaffold(
      body: Stack(
        children: [
          // Updated Background Gradient
          Container(
            decoration: const BoxDecoration(
              // gradient: LinearGradient(

              //   colors: [ 
              //             // Color(0xFFE3ECFF),
              //             Color(0xFFE3ECFF),
              //             Color(0xFF7AAEFF), // Light Blue
              //             Color(0xFFE3ECFF),

              //             Color(0xFF7AAEFF), // Light Blue

              //             // Color(0xFF2B55D0), // Medium Blue
              //             // // Color(0xFF1E3A8A), // Dark Blue
              //             // Color(0xFF2B55D0), // Medium Blue
              //             // Color(0xFF7AAEFF), // Light Blue
              //             // Color(0xFFE3ECFF),
              //             // Color(0xFFE3ECFF),
                          
              //             // Color(0xFF2B55D0), // Medium Blue
              //             ], // Royal Blue Gradient
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glassmorphism Effect for QR Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2B55D0).withOpacity(0.65),
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      QrImageView(
                        data: upiUri,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Scan to Pay $_userName",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "UPI ID: $_upiId",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    if (await canLaunchUrl(Uri.parse(upiUri))) {
                      await launchUrl(Uri.parse(upiUri));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Unable to open UPI app"))
                      );
                    }
                  },
                  child: Container(
                    width: 180,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(0.87),
                      
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "⚡ Pay Now",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
