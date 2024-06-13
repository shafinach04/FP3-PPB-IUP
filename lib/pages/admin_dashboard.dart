import 'package:flutter/material.dart';
import 'package:ppb_fp/pages/staff_management_page.dart';
import 'package:ppb_fp/pages/reservation_list_page.dart';
import 'package:ppb_fp/pages/menu_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

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
      body: Padding(
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
      ),
    );
  }
}