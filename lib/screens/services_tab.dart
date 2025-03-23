
import 'package:flutter/material.dart';
class ServicesTab extends StatelessWidget {
  const ServicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Meals'),
      ),
      body: const Center(child: Text('Track your meals here')),
    );
  }
}