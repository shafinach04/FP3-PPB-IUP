import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppb_fp/pages/auth_page.dart';
import 'package:ppb_fp/pages/reservation_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          color: Colors.blueGrey,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ShowMenu(), // ShowMenu will be the grid view displaying menu items
    Container(
      color: Colors.grey[850],
      child: const Center(
        child: Text(
          'Profile Page Content',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  ];

  void _navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          size: 28,
          color: Colors.white,
        ),
        title: const Text(
          'Restaurant FaFiFa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle_rounded,
            ),
            onPressed: () {
              // Handle login action
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthPage()),
              );
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
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Restaurant FaFiFa',
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
                _navigateToHome(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Reservation'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReservationPage()),
                ).then((_) {
                  setState(() {
                    _selectedIndex = 0; // Ensure HomePage is selected
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ShowMenu extends StatefulWidget {
  const ShowMenu({super.key});

  @override
  State<ShowMenu> createState() => _ShowMenuState();
}

class _ShowMenuState extends State<ShowMenu> {
  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('Upload_Items').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Some error occurred ${snapshot.error}"));
          }
          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            List<Map> items = documents.map((e) => e.data() as Map).toList();

            return GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 2 / 3,
              ),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                Map thisItem = items[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                          ),
                          child: Image.network(
                            "${thisItem['image']}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${thisItem['name']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Rp ${thisItem['price']}",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:ppb_fp/pages/auth_page.dart';
// import 'package:ppb_fp/pages/manage_menu_page.dart';
// import 'package:ppb_fp/pages/reservation_page.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark().copyWith(
//         primaryColor: Colors.blueGrey,
//         scaffoldBackgroundColor: Colors.black,
//         appBarTheme: AppBarTheme(
//           color: Colors.blueGrey,
//         ),
//       ),
//       home: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _pages = [
//     Container(
//       color: Colors.grey[850],
//       child: Center(
//         child: Text(
//           'Home Page Content',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     ),
//     //add pic slide of menu
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   void _navigateToHome(BuildContext context) {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => HomePage()),
//           (route) => false,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Restaurant X'),
//         backgroundColor: Colors.blueGrey,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.account_circle_rounded),
//             onPressed: () {
//               // Handle login action
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => AuthPage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: _pages[_selectedIndex],
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blueGrey,
//               ),
//               child: Container(
//                 alignment: Alignment.center,
//                 child: Text(
//                   'Restaurant X',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                   ),
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.home),
//               title: const Text('Home'),
//               onTap: () {
//                 _navigateToHome(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.menu_book),
//               title: const Text('Menu'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ShowMenu()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.book),
//               title: const Text('Reservation'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ReservationPage()),
//                 ).then((_) {
//                   setState(() {
//                     _selectedIndex = 0; // Ensure HomePage is selected
//                   });
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }