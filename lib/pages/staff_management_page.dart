import 'package:flutter/material.dart';
import 'package:ppb_fp/services/firestore.dart';

class StaffManagementPage extends StatefulWidget {
  const StaffManagementPage({super.key});

  @override
  State<StaffManagementPage> createState() => _StaffManagementState();
}

class _StaffManagementState extends State<StaffManagementPage> {
  final TextEditingController _staffName = TextEditingController();
  final TextEditingController _staffUsername = TextEditingController();
  final TextEditingController _staffPassword = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  Future<void> _showDialog(BuildContext context) async {
    _staffName.clear();
    _staffUsername.clear();
    _staffPassword.clear();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Staff"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text("Staff Name"),
              ),
              TextField(
                controller: _staffName,
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.topLeft,
                child: Text("Staff Username"),
              ),
              TextField(
                controller: _staffUsername,
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.topLeft,
                child: Text("Staff Password"),
              ),
              TextField(
                obscureText: true,
                controller: _staffPassword,
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                firestoreService.addStaff(_staffName.text, _staffUsername.text, _staffPassword.text);
                Navigator.pop(context);
              },
              child: const Text("Add Staff"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Management"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
