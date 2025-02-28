import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:bankapp/screens/account_model.dart';
import 'package:bankapp/screens/savings_account_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _quitApp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Quit"),
          content: const Text("Are you sure you want to quit the app?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text("Quit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userName =
        user?.displayName ?? user?.email?.split('@').first ?? "User";
    String lastLogin = DateFormat('MMM dd, yyyy hh:mm a')
        .format(user?.metadata.lastSignInTime ?? DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF2B55D0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome, $userName",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text("Last login: $lastLogin",
                    style:
                        const TextStyle(fontSize: 14, color: Colors.white70)),
              ],
            ),
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(LucideIcons.alignLeft,
                    color: Colors.white, size: 30),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.logOut, color: Colors.white),
                onPressed: _quitApp,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
                child:
                    _buildAccountSection()), // 🟢 Equal Space for Savings Account
            const SizedBox(height: 10), // 🔸 Spacing
            Expanded(
                child: _buildFavoritesSection()) // 🟢 Equal Space for Favorites
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E3A8A),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.banknote), label: 'Accounts'),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.scan), label: 'Scan & Pay'),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.creditCard), label: 'Cards'),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.settings), label: 'Services'),
        ],
      ),
    );
  }

  // ✅ Enhanced Savings Account Section
  // Widget _buildAccountSection() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10, spreadRadius: 2),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text("Saving Account",
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
  //         const SizedBox(height: 5),
  //         const Text("0457104000208536", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //         const Spacer(),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             ElevatedButton(
  //               onPressed: () {},
  //               style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
  //               child: const Text("Transfer"),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {},
  //               style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
  //               child: const Text("Mini Statement"),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  // ✅ Using the _buildAccountSection() function
  Widget _buildAccountSection() {
    AccountModel myAccount = AccountModel(
      accountType: "Savings Account",
      accountNumber: "0457104000208536",
      branchName: "Downtown Branch",
      availableBalance: 12500.75,
    );

    return SavingsAccountCard(account: myAccount);
  }

  // ✅ Enhanced Favorites Section
  Widget _buildFavoritesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("My Favorites",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                  icon: const Icon(Icons.edit, color: Colors.red),
                  onPressed: () {}),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildFavoriteCard(Icons.payment, "IMPS Payment"),
                _buildFavoriteCard(Icons.account_balance, "IDBI Bank Transfer"),
                _buildFavoriteCard(Icons.payment, "BHIM UPI"),
                _buildFavoriteCard(Icons.savings, "Open FD"),
                _buildFavoriteCard(Icons.attach_money, "Mutual Fund"),
                _buildFavoriteCard(Icons.travel_explore, "Travel & Shop"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Reusable Favorite Card Widget
  Widget _buildFavoriteCard(IconData icon, String title) {
    return Card(
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: const Color(0xFF1E3A8A)),
          const SizedBox(height: 8),
          Text(title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
