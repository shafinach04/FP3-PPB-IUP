import 'package:flutter/material.dart';
import 'package:ppb_fp/pages/staff_management_page.dart';
import 'package:ppb_fp/pages/reservation_list_page.dart';
import 'package:ppb_fp/pages/manage_menu_page.dart';
import 'package:ppb_fp/pages/menu_page.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Management App'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
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
                      icon: Icon(Icons.people, size: 50),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StaffManagementPage()),
                        );
                      },
                    ),
                    Text('Staff Management'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.book, size: 50),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReservationListPage()),
                        );
                      },
                    ),
                    Text('Reservation'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.menu_book, size: 50),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadImageAndMore()),
                    );
                  },
                ),
                Text('Manage Menu'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}