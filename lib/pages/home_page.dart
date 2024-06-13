import 'package:flutter/material.dart';
import 'package:ppb_fp/pages/reservation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Container(
      color: Colors.grey[900],
      child: Center(
        child: Text(
          'Home Page Content',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          color: Colors.blueGrey,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Restaurant X'),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle_rounded),
              onPressed: () {
                // Handle login action
              },
            ),
          ],
        ),
        body: _pages[_selectedIndex],
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Restaurant X',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text('Menu'),
                onTap: () {
                  _onItemTapped(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Reservation'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReservationPage()),
                  ).then((_) {
                    // Ensure the drawer closes when coming back from ReservationPage
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

