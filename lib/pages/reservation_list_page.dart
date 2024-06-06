import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReservationListPage extends StatelessWidget {

  //delete reservation
  void _deleteReservation(DocumentSnapshot reservation) {
    FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
      await myTransaction.delete(reservation.reference);
    });
  }

  //edit reservation
  void _editReservation(BuildContext context, DocumentSnapshot reservation) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: reservation['name']);
    final _phoneController = TextEditingController(text: reservation['phone']);
    DateTime? _selectedDate = reservation['date'].toDate();
    String? _selectedTime = reservation['time'];
    int _partySize = reservation['party'];

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2030),
      );
      if (picked != null && picked != _selectedDate) {
        _selectedDate = picked;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Reservation"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  ListTile(
                    title: Text("Date: ${_selectedDate == null ? '' : DateFormat.yMMMd().format(_selectedDate!)}"),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Time'),
                    value: _selectedTime,
                    items: [
                      for (var i = 10; i <= 22; i++)
                        DropdownMenuItem(value: '$i:00', child: Text('$i:00')),
                    ],
                    onChanged: (value) {
                      _selectedTime = value;
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
                      Text('Party Size: $_partySize'),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (_partySize > 1) {
                                _partySize--;
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              _partySize++;
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
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
                    myTransaction.update(reservation.reference, {
                      'name': _nameController.text,
                      'phone': _phoneController.text,
                      'date': _selectedDate,
                      'time': _selectedTime,
                      'party': _partySize,
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Upcoming Reservations'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('reservations').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No reservations found.'));
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
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editReservation(context, doc);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
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