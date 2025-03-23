import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF1E3A8A),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.banknote), label: 'Accounts'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.scan), label: 'Scan & Pay'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.creditCard), label: 'Cards'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.settings), label: 'Services'),
      ],
    );
  }
}
