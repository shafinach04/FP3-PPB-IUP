import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ppb_fp/services/firestore.dart';

class StaffManagementPage extends StatefulWidget {
  const StaffManagementPage({super.key});

  @override
  State<StaffManagementPage> createState() => _StaffManagementState();
}

class _StaffManagementState extends State<StaffManagementPage> {
  final FirestoreService firestoreService = FirestoreService();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter an email address";
    }

    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value.isNotEmpty && !regex.hasMatch(value) ? 'Please enter a valid email address' : null;
  }

  Future<void> _addStaff(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final TextEditingController staffName = TextEditingController();
    final TextEditingController staffEmail = TextEditingController();
    final TextEditingController staffPassword = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(8),
            scrollable: true,
            title: const Text(
              "Add new staff",
              style: TextStyle(fontSize: 16.0),
            ),
            content: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: staffName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a name";
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Name",
                      icon: Icon(Icons.account_circle),
                    ),
                  ),
                  TextFormField(
                    controller: staffEmail,
                    validator: validateEmail,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      icon: Icon(Icons.email),
                    ),
                  ),
                  TextFormField(
                    controller: staffPassword,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a password";
                      }

                      if (value.length < 6) {
                        return "Must be atleast 6 characters";
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Password",
                      icon: Icon(Icons.lock),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    firestoreService.addStaff(staffName.text, staffEmail.text, staffPassword.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Add Staff"),
              ),
            ],
          );
        });
  }

  Future<void> _editStaff(BuildContext context, DocumentSnapshot staff) async {
    final formKey = GlobalKey<FormState>();
    final TextEditingController staffName = TextEditingController(text: staff["staffName"]);
    final TextEditingController staffEmail = TextEditingController(text: staff["staffEmail"]);
    final TextEditingController staffPassword = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(8),
            scrollable: true,
            title: const Text(
              "Edit staff",
              style: TextStyle(fontSize: 16.0),
            ),
            content: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: staffName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a name";
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Name",
                      icon: Icon(Icons.account_circle),
                    ),
                  ),
                  TextFormField(
                    controller: staffEmail,
                    validator: validateEmail,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      icon: Icon(Icons.email),
                    ),
                  ),
                  TextFormField(
                    controller: staffPassword,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a password";
                      }

                      if (value.length < 6) {
                        return "Must be atleast 6 characters";
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Password",
                      icon: Icon(Icons.lock),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    firestoreService.editStaff(staff, staffName.text, staffEmail.text, staffPassword.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Save Change"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Management"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _addStaff(context);
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('staff').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No staff yet'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              return ListTile(
                leading: const Icon(
                  Icons.account_circle,
                  size: 60,
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case "Edit":
                        _editStaff(context, doc);
                        break;
                      case "Delete":
                        firestoreService.deleteStaff(doc);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {"Edit", "Delete"}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                  icon: const Icon(Icons.more_vert),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                title: Text(data["staffName"]),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data["staffEmail"]),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
