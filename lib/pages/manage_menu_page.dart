// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ShowMenu extends StatefulWidget {
//   const ShowMenu({super.key});
//
//   @override
//   State<ShowMenu> createState() => _ShowMenuState();
// }
//
// class _ShowMenuState extends State<ShowMenu> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//
//   final CollectionReference _items = FirebaseFirestore.instance.collection("Upload_Items");
//
//   String imageUrl = '';
//
//   late Stream<QuerySnapshot> _stream;
//
//   @override
//   void initState() {
//     super.initState();
//     _stream = FirebaseFirestore.instance.collection('Upload_Items').snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("List of Menu"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _stream,
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text("Some error occurred ${snapshot.error}"));
//           }
//           if (snapshot.hasData) {
//             QuerySnapshot querySnapshot = snapshot.data;
//             List<QueryDocumentSnapshot> document = querySnapshot.docs;
//
//             List<Map> items = document.map((e) => e.data() as Map).toList();
//
//             return ListView.builder(
//               itemCount: items.length,
//               itemBuilder: (BuildContext context, int index) {
//                 QueryDocumentSnapshot documentSnapshot = document[index];
//                 Map thisItem = items[index];
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
//                   child: Row(
//                     children: [
//                       PopupMenuButton<String>(
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(
//                           minWidth: 30.0,
//                         ),
//                         itemBuilder: (BuildContext context) {
//                           return [
//                             PopupMenuItem(
//                               value: 'edit',
//                               child: Icon(Icons.edit),
//                             ),
//                             PopupMenuItem(
//                               value: 'delete',
//                               child: Icon(Icons.delete),
//                             ),
//                           ];
//                         },
//                         icon: const Icon(Icons.more_vert),
//                       ),
//                       Expanded(
//                         child: ListTile(
//                           title: Text(
//                             "${thisItem['name']}",
//                             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
//                           ),
//                           subtitle: Text("Rp ${thisItem['price']}"),
//                           trailing: Container(
//                             decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
//                             child: SizedBox(
//                               height: 100,
//                               width: 100,
//                               child: thisItem.containsKey('image')
//                                   ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(20),
//                                 child: Image.network(
//                                   "${thisItem['image']}",
//                                   fit: BoxFit.cover,
//                                   height: 42,
//                                   width: 42,
//                                 ),
//                               )
//                                   : const CircleAvatar(),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           }
//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//
//     );
//   }
// }
//
//
