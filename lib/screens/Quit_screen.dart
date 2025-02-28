import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuitScreen extends StatelessWidget {
  const QuitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? exitApp = await _showExitDialog(context);
        return exitApp ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E3A8A),
          title: const Text('Are You Sure You Want to Quit?'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              bool? exitApp = await _showExitDialog(context);
              if (exitApp != null && exitApp) {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            child: const Text('Exit App'),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showExitDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return AlertDialog(
          title: const Text('Quit App'),
          content: const Text('Are you sure you want to quit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
