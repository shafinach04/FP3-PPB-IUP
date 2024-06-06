import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppb_fp/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:ppb_fp/pages/menu_page.dart';
import 'package:ppb_fp/pages/reservation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant X'),
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              // Handle login action
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Menu'),
            Tab(text: 'Reservation'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // UploadImageAndMore(),
          ReservationPage(),
        ],
      ),
    );
  }
}
