import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppb_fp/services/firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _imageFile;

  Future<void> _addMenuItem() async {
    if (_nameController.text.isNotEmpty && _priceController.text.isNotEmpty && _imageFile != null) {
      double? price = double.tryParse(_priceController.text);
      if (price != null) {
        try {
          String pictureUrl = await _firestoreService.uploadImage(_imageFile!);
          await _firestoreService.addMenuItem(_nameController.text, price, pictureUrl);
          Navigator.of(context).pop();
          _clearForm();
        } catch (e) {
          print('Error adding menu item: $e');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding menu item: $e')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid price.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields and select an image.')));
    }
  }

  Future<File?> getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      print('Picked file path: ${result.files.single.path}');
      return File(result.files.single.path!);
    } else {
      print('No file selected');
      return null;
    }
  }

  void _clearForm() {
    _nameController.clear();
    _priceController.clear();
    setState(() {
      _imageFile = null;
    });
  }

  void _showAddMenuItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Menu Item'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                _imageFile != null
                    ? Image.file(_imageFile!)
                    : Text('No image selected'),
                ElevatedButton(
                  child: Text('Upload Image'),
                  onPressed: () async {
                    File? file = await getImage();
                    if (file != null) {
                      setState(() {
                        _imageFile = file;
                        print('Image file set: ${_imageFile?.path}');
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearForm();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: _addMenuItem,
              child: Text('Add'),
            ),
          ],
        );
      },
    ).then((_) {
      _clearForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getMenuItemsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final menuItems = snapshot.data!.docs;
          return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return ListTile(
                leading: Image.network(item['pictureUrl']),
                title: Text(item['name']),
                subtitle: Text('\$${item['price']}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMenuItemDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
