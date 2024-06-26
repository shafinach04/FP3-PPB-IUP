import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageAndMore extends StatefulWidget {
  const UploadImageAndMore({super.key});

  @override
  State<UploadImageAndMore> createState() => _UploadImageAndMoreState();
}

class _UploadImageAndMoreState extends State<UploadImageAndMore> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final CollectionReference _items = FirebaseFirestore.instance.collection("Upload_Items");

  String imageUrl = '';

  Future<void> _create() async {
    _nameController.clear();
    _priceController.clear();
    imageUrl = '';

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text("Add Menu Item"),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name', hintText: 'e.g. Pizza'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price', hintText: 'e.g. Rp 10000'),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: IconButton(
                  onPressed: () async {
                    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (file == null) return;

                    String fileName = DateTime.now().microsecondsSinceEpoch.toString();

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDireImages = referenceRoot.child('images');
                    Reference referenceImageaToUpload = referenceDireImages.child(fileName);

                    try {
                      await referenceImageaToUpload.putFile(File(file.path));
                      imageUrl = await referenceImageaToUpload.getDownloadURL();
                    } catch (error) {
                      // Handle error
                    }
                  },
                  icon: const Icon(Icons.camera_alt),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      if (imageUrl.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please select and upload image")),
                        );
                        return;
                      }
                      final String name = _nameController.text;
                      final String price = _priceController.text;

                      await _items.add({"name": name, "price": price, "image": imageUrl});

                      _nameController.clear();
                      _priceController.clear();
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    } catch (e) {
                      print('Failed to add item: $e');
                    }
                  },
                  child: const Text('Create'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _update(DocumentSnapshot documentSnapshot) async {
    _nameController.text = documentSnapshot['name'];
    _priceController.text = documentSnapshot['price'];
    imageUrl = documentSnapshot['image'];

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text("Edit Menu Item"),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name', hintText: 'e.g. Pizza'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price', hintText: 'e.g. Rp 10000'),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: IconButton(
                  onPressed: () async {
                    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (file == null) return;

                    String fileName = DateTime.now().microsecondsSinceEpoch.toString();

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDireImages = referenceRoot.child('images');
                    Reference referenceImageaToUpload = referenceDireImages.child(fileName);

                    try {
                      await referenceImageaToUpload.putFile(File(file.path));
                      imageUrl = await referenceImageaToUpload.getDownloadURL();
                    } catch (error) {
                      // Handle error
                    }
                  },
                  icon: const Icon(Icons.camera_alt),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      if (imageUrl.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please select and upload image")),
                        );
                        return;
                      }
                      final String name = _nameController.text;
                      final String price = _priceController.text;

                      await _items.doc(documentSnapshot.id).update({"name": name, "price": price, "image": imageUrl});

                      _nameController.clear();
                      _priceController.clear();
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    } catch (e) {
                      print('Failed to update item: $e');
                    }
                  },
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _delete(String itemId) async {
    await _items.doc(itemId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Item deleted successfully")));
  }

  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('Upload_Items').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of Menu"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Some error occurred ${snapshot.error}"));
          }
          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> document = querySnapshot.docs;

            List<Map> items = document.map((e) => e.data() as Map).toList();

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                QueryDocumentSnapshot documentSnapshot = document[index];
                Map thisItem = items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                  child: Row(
                    children: [
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 30.0,
                        ),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _update(documentSnapshot);
                          } else if (value == 'delete') {
                            _delete(documentSnapshot.id);
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Icon(Icons.edit),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Icon(Icons.delete),
                            ),
                          ];
                        },
                        icon: const Icon(Icons.more_vert),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            "${thisItem['name']}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          subtitle: Text("Rp ${thisItem['price']}"),
                          trailing: Container(
                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: thisItem.containsKey('image')
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        "${thisItem['image']}",
                                        fit: BoxFit.cover,
                                        height: 42,
                                        width: 42,
                                      ),
                                    )
                                  : const CircleAvatar(),
                            ),
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _create();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

//old code

// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class UploadImageAndMore extends StatefulWidget {
//   const UploadImageAndMore({super.key});
//
//   @override
//   State<UploadImageAndMore> createState() => _UploadImageAndMoreState();
// }
//
// class _UploadImageAndMoreState extends State<UploadImageAndMore> {
//   // text field controller
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//
//   final CollectionReference _items = FirebaseFirestore.instance.collection("Upload_Items");
//   // collection name must be same as firebase collection name
//
//   String imageUrl = '';
//
//   Future<void> _create() async {
//     await showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (BuildContext ctx) {
//           return Padding(
//             padding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Center(
//                   child: Text("Add Menu Item"),
//                 ),
//                 TextField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(labelText: 'Name', hintText: 'e.g. Pizza'),
//                 ),
//                 TextField(
//                   controller: _priceController,
//                   decoration: const InputDecoration(labelText: 'Price', hintText: 'e.g. Rp 10000'),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Center(
//                     child: IconButton(
//                         onPressed: () async {
//                           // add the package image_picker
//                           final file = await ImagePicker().pickImage(source: ImageSource.gallery);
//                           if (file == null) return;
//
//                           String fileName = DateTime.now().microsecondsSinceEpoch.toString();
//
//                           // Get the reference to storage root
//                           // We create the image folder first and insider folder we upload the image
//                           Reference referenceRoot = FirebaseStorage.instance.ref();
//                           Reference referenceDireImages = referenceRoot.child('images');
//
//                           // we have creata reference for the image to be stored
//                           Reference referenceImageaToUpload = referenceDireImages.child(fileName);
//
//                           // For errors handled and/or success
//                           try {
//                             await referenceImageaToUpload.putFile(File(file.path));
//
//                             // We have successfully upload the image now
//                             // make this upload image link in firebase database
//
//                             imageUrl = await referenceImageaToUpload.getDownloadURL();
//                           } catch (error) {
//                             // some error
//                           }
//                         },
//                         icon: const Icon(Icons.camera_alt))),
//                 Center(
//                     child: ElevatedButton(
//                         onPressed: () async {
//                           try {
//                             if (imageUrl.isEmpty) {
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(const SnackBar(content: Text("Please select and upload image")));
//                               return;
//                             }
//                             final String name = _nameController.text;
//                             final String price = _priceController.text;
//                             // int.tryParse(_priceController.text);
//                             await _items.add({
//                               // Add items in you firebase firestore
//                               "name": name,
//                               "price": price,
//                               "image": imageUrl,
//                             });
//                             _nameController.text = '';
//                             _priceController.text = '';
//                             Navigator.of(context).pop();
//                           } catch (e) {
//                             print('Failed to add item: $e');
//                           }
//                         },
//                         child: const Text('Create')))
//               ],
//             ),
//           );
//         });
//   }
//
//   late Stream<QuerySnapshot> _stream;
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
//           stream: _stream,
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (snapshot.hasError) {
//               return Center(
//                 child: Text("Some error occured${snapshot.error}"),
//               );
//             }
//             // Now , Check if data arrived?
//             if (snapshot.hasData) {
//               QuerySnapshot querySnapshot = snapshot.data;
//               List<QueryDocumentSnapshot> document = querySnapshot.docs;
//
//               // We need to Convert your documnets to Maps to display
//               List<Map> items = document.map((e) => e.data() as Map).toList();
//
//               //At Last, Display the list of items
//               return ListView.builder(
//                   itemCount: items.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     Map thisItems = items[index];
//                     return ListTile(
//                         title: Text(
//                           "${thisItems['name']}",
//                           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
//                         ),
//                         subtitle: Text("Rp ${thisItems['price']}"),
//                         trailing: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.black,
//                               borderRadius: BorderRadius.circular(20)
//                           ),
//                           child: SizedBox(
//                             height: 100,
//                             width: 100,
//                             child: thisItems.containsKey('image')
//                                 ? ClipRRect(
//                               borderRadius: BorderRadius.circular(20),
//                               child: Image.network(
//                                 "${thisItems['image']}",
//                                 fit: BoxFit.cover,
//                                 height: 42,
//                                 width: 42,
//                               ),
//                             )
//                                 : const CircleAvatar(),
//                           ),
//                         ));
//                   });
//             }
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _create();
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
