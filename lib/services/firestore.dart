import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ppb_fp/services/firebase_auth_service.dart';
import 'dart:io';

class FirestoreService {
  final CollectionReference menu = FirebaseFirestore.instance.collection('menu');
  final FirebaseStorage storage = FirebaseStorage.instance;
  final CollectionReference staff = FirebaseFirestore.instance.collection("staff");

  //Create
  Future<void> addMenuItem(String name, double price, String pictureUrl) {
    return menu.add({
      'name': name,
      'price': price,
      'pictureUrl': pictureUrl,
      'timestamp': Timestamp.now(),
    });
  }

  //Read
  Stream<QuerySnapshot> getMenuItemsStream() {
    final menuStream = menu.orderBy('timestamp', descending: true).snapshots();
    return menuStream;
  }

  //update
  Future<void> updateMenuItem(String docID, String newName, double newPrice, String newPictureUrl) {
    return menu.doc(docID).update({
      'name': newName,
      'price': newPrice,
      'pictureUrl': newPictureUrl,
      'timestamp': Timestamp.now(),
    });
  }

  //delete
  Future<void> deleteMenuItem(String docID) {
    return menu.doc(docID).delete();
  }

  Future<void> addStaff(String name, String email, String password) {
    FirebaseAuthService auth = FirebaseAuthService();
    auth.staffSignUp(email, password);

    return staff.add({
      "staffName": name,
      "staffEmail": email,
      "staffPassword": password,
    });
  }

  Future<void> editStaff(DocumentSnapshot staff, name, String email, String password) async {
    FirebaseFirestore.instance.runTransaction((Transaction t) async {
      return t.update(staff.reference, {
        "staffName": name,
        "staffEmail": email,
        "staffPassword": password,
      });
    });
  }

  Future<void> deleteStaff(DocumentSnapshot staff) async {
    FirebaseFirestore.instance.runTransaction((Transaction t) async {
      t.delete(staff.reference);
    });
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
