import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedTime;
  int _partySize = 1;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitReservation() {
    if (_formKey.currentState?.validate() ?? false) {
      FirebaseFirestore.instance.collection('reservations').add({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'date': _selectedDate,
        'time': _selectedTime,
        'party': _partySize,
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your reservation is successful')),
        );

        //clear reservation form
        _formKey.currentState?.reset();
        _nameController.clear();
        _phoneController.clear();
        setState(() {
          _selectedDate = null;
          _selectedTime = null;
          _partySize = 1;
        });
      }).catchError((error) {
        print("Failed to add reservation: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to make a reservation')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
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
                title: Text("Date: ${_selectedDate == null ? '' : DateFormat.yMd().format(_selectedDate!)}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Time'),
                value: _selectedTime,
                items: [
                  for (var i = 10; i <= 22; i++) DropdownMenuItem(value: '$i:00', child: Text('$i:00')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedTime = value;
                  });
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
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (_partySize > 1) _partySize--;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _partySize++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReservation,
                child: const Text('Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
