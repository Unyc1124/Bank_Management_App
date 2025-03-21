import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:bankapp/screens/account_model.dart';
import 'package:bankapp/screens/savings_account_card.dart';
import 'package:bankapp/screens/qr_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _userName = "User"; // Default value
  String _lastLogin = "Loading..."; // Placeholder text
  final PageController _pageController =
      PageController(); // PageView Controller
  int _currentPage = 0; // Current page index

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch Firestore data on startup
  }

  void _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        _lastLogin = DateFormat('MMM dd, yyyy hh:mm a')
            .format(user.metadata.lastSignInTime ?? DateTime.now());
      });

      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _userName = userDoc['name'] ?? "User";
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }
  void _onItemTapped(int index) {
    if (index == 2) {
      // Navigate to QR Scanner when "Scan & Pay" is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScanQRPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
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
                Text("Welcome, $_userName",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text("Last login: $_lastLogin",
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
            Expanded(child: _buildAccountSection()),
            const SizedBox(height: 10),
            Expanded(child: _buildPageView()),
            const SizedBox(height: 10),
            _buildDotIndicator(),
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

  // ✅ Account Section (Reused Component)
  Widget _buildAccountSection() {
    AccountModel myAccount = AccountModel(
      accountType: "Savings Account",
      accountNumber: "0457104000208536",
      branchName: "Downtown Branch",
      availableBalance: 12500.75,
    );

    return SavingsAccountCard(account: myAccount);
  }

  // ✅ PageView for Different Sections
  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      children: [
        _buildFavoritesSection(),
        _buildPayNowSection(),
      ],
    );
  }

  // ✅ Dot Indicator for PageView
  Widget _buildDotIndicator() {
    return SmoothPageIndicator(
      controller: _pageController,
      count: 2,
      effect: ExpandingDotsEffect(
        activeDotColor: Colors.blue.shade900,
        dotColor: Colors.grey.shade300,
        dotHeight: 8,
        dotWidth: 8,
      ),
    );
  }

  // ✅ "My Favorites" Section
  Widget _buildFavoritesSection() {
    return _buildFeatureGrid("My Favorites", [
      _buildFeatureItem(Icons.payment, "IMPS Payment"),
      _buildFeatureItem(Icons.account_balance, "IDBI Bank Transfer"),
      _buildFeatureItem(Icons.payment, "BHIM UPI"),
      _buildFeatureItem(Icons.savings, "Open FD"),
      _buildFeatureItem(Icons.attach_money, "Mutual Fund"),
      _buildFeatureItem(Icons.travel_explore, "Travel & Shop"),
    ]);
  }

  // ✅ "Pay Now" Section
  Widget _buildPayNowSection() {
    return _buildFeatureGrid("Pay Now", [
      _buildFeatureItem(Icons.send, "Self Account Transfer"),
      _buildFeatureItem(Icons.account_balance_wallet, "IDBI Bank Transfer"),
      _buildFeatureItem(Icons.sync_alt, "NEFT Payment"),
      _buildFeatureItem(Icons.payment, "IMPS Payment"),
      _buildFeatureItem(Icons.local_offer, "Deals & Delights"),
      _buildFeatureItem(Icons.credit_card, "IDBI Card Payment"),
    ]);
  }

  // 🔹 Reusable Feature Grid
  Widget _buildFeatureGrid(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: children,
          ),
        ),
      ],
    );
  }

  // 🔹 Reusable Feature Item
  Widget _buildFeatureItem(IconData icon, String title) {
    return _buildFavoriteCard(icon, title);
  }

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
