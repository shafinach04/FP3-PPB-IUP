import 'package:flutter/material.dart';
import 'package:ppb_fp/pages/staff_management_page.dart';
import 'package:ppb_fp/pages/reservation_list_page.dart';
import 'package:ppb_fp/pages/menu_page.dart';
import 'package:ppb_fp/pages/profile_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    AdminDashboardContent(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Management App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle logout action
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class AdminDashboardContent extends StatelessWidget {
  const AdminDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.people, size: 50),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StaffManagementPage()),
                      );
                    },
                  ),
                  const Text('Staff Management'),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.book, size: 50),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReservationListPage()),
                      );
                    },
                  ),
                  const Text('Reservation'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 50),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.menu_book, size: 50),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UploadImageAndMore()),
                  );
                },
              ),
              const Text('Manage Menu'),
            ],
          ),
        ],
      ),
    );
  }
}
