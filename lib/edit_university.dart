import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/services/firestore.dart';


class EditUniversityPage extends StatefulWidget {
  final University university;

  const EditUniversityPage({Key? key, required this.university}) : super(key: key);

  @override
  _EditUniversityPageState createState() => _EditUniversityPageState();
}

class _EditUniversityPageState extends State<EditUniversityPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _postcodeController;
  late String _selectedState;

  //firestore
  final FirestoreService firestoreService = FirestoreService();

  final List<String> _states = ['Select State', 'Selangor', 'Kuala Lumpur', 'Perak', 'Pahang', 'Negeri Sembilan', 'Kedah', 'Kelantan', 'Sabah', 'Sarawak', 'Johor', 'Penang'];

  @override
  void initState() {
    super.initState();
    // Initialize the form fields with the data of the university that's being edited
    _nameController = TextEditingController(text: widget.university.name);
    _addressController = TextEditingController(text: widget.university.address);
    _postcodeController = TextEditingController(text: widget.university.postcode);
    _selectedState = widget.university.state; // Correctly initialize with the university's current state

  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    _nameController.dispose();
    _addressController.dispose();
    _postcodeController.dispose();
    super.dispose();
  }

  // Function to handle form submission
  void _submitForm() {
  if (_formKey.currentState!.validate()) {
    Map<String, dynamic> updatedUniversity = {
      'universityName': _nameController.text,
      'state': _selectedState,
      'postcode': _postcodeController.text,
      'address': _addressController.text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Call the editUniversity function
    firestoreService.editUniversity(widget.university.id, updatedUniversity)
      .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('University updated successfully')),
        );
        Navigator.pop(context);
      })
      .catchError((error) {
        // Handle any errors here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update university')),
        );
      });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit University',style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),),
        backgroundColor: Color.fromRGBO(28, 68, 64, 1),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'University Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the university name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
                value: _selectedState,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedState = newValue!;
                  });
                },
                items: _states.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) => value == 'Select State' ? 'Please select a state' : null,
                menuMaxHeight: 200,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _postcodeController,
                decoration: InputDecoration(
                  labelText: 'Postcode',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number, // Use number input type
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow digits only
                  LengthLimitingTextInputFormatter(5), // Limit to 5 characters
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the postcode';
                  } else if (value.length != 5) {
                    return 'Postcode must be 5 digits long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _submitForm();
                    //process data here
                  }
                },
                child: Text('Submit',
                style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, //button color
                  backgroundColor: Color.fromRGBO(28, 68, 64, 1), // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Border radius
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Button padding
                  elevation: 5, // Button shadow
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}