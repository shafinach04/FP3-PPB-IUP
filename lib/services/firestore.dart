import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


class FirestoreService{
  final CollectionReference menu = FirebaseFirestore.instance.collection('menu');
  final FirebaseStorage storage = FirebaseStorage.instance;

  //Create
  Future<void> addMenuItem(String name, double price, String pictureUrl){
    return menu.add({
      'name': name,
      'price': price,
      'pictureUrl': pictureUrl,
      'timestamp': Timestamp.now(),
    });
  }

  //Read
  Stream<QuerySnapshot> getMenuItemsStream() {
    final menuStream  =
    menu.orderBy('timestamp', descending: true).snapshots();
    return menuStream ;

  }

  //update
  Future<void> updateMenuItem(String docID, String newName, double newPrice, String newPictureUrl){
    return menu.doc(docID).update( {
      'name': newName,
      'price': newPrice,
      'pictureUrl': newPictureUrl,
      'timestamp': Timestamp.now(),
    });
  }

  //delete
  Future<void> deleteMenuItem(String docID){
    return menu.doc(docID).delete();
  }

  //upload image
  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      print('Uploading to: menu_images/$fileName');
      Reference reference = storage.ref().child('menu_images/$fileName');
      UploadTask uploadTask = reference.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print('Upload successful, download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow; // Re-throw the error to handle it further up the call stack
    }
  }

  
}