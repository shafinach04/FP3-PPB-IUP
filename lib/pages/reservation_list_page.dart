import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReservationListPage extends StatelessWidget {
  const ReservationListPage({super.key});

  //delete reservation
  void _deleteReservation(DocumentSnapshot reservation) {
    FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
      myTransaction.delete(reservation.reference);
    });
  }

  //edit reservation
  void _editReservation(BuildContext context, DocumentSnapshot reservation) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: reservation['name']);
    final phoneController = TextEditingController(text: reservation['phone']);
    DateTime? selectedDate = reservation['date'].toDate();
    String? selectedTime = reservation['time'];
    int partySize = reservation['party'];

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2030),
      );
      if (picked != null && picked != selectedDate) {
        selectedDate = picked;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Reservation"),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  ListTile(
                    title: Text("Date: ${selectedDate == null ? '' : DateFormat.yMMMd().format(selectedDate!)}"),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => selectDate(context),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Time'),
                    value: selectedTime,
                    items: [
                      for (var i = 10; i <= 22; i++) DropdownMenuItem(value: '$i:00', child: Text('$i:00')),
                    ],
                    onChanged: (value) {
                      selectedTime = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a time';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Party Size: $partySize'),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (partySize > 1) {
                                partySize--;
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              partySize++;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
                    myTransaction.update(reservation.reference, {
                      'name': nameController.text,
                      'phone': phoneController.text,
                      'date': selectedDate,
                      'time': selectedTime,
                      'party': partySize,
                    });
                  }).then((value) {
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    print("Failed to update reservation: $error");
                  });
                }
              },
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Upcoming Reservations'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('reservations').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No reservations found.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat.yMMMd().format(data['date'].toDate())),
                    Text('${data['time']}'),
                    Text('${data['party']} pax'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editReservation(context, doc);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteReservation(doc);
                      },
                    ),
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
