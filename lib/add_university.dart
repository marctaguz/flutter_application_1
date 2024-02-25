import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/services/firestore.dart';

class AddUniversityPage extends StatefulWidget {
  @override
  _AddUniversityPageState createState() => _AddUniversityPageState();
}

class _AddUniversityPageState extends State<AddUniversityPage> {
  final _formKey = GlobalKey<FormState>();
  String _universityName = '';
  String _address = '';
  String _selectedState = 'Select State';
  String _postcode = '';
  final List<String> _states = ['Select State', 'Selangor', 'Kuala Lumpur', 'Perak', 'Pahang', 'Negeri Sembilan', 'Kedah', 'Kelantan', 'Sabah', 'Sarawak', 'Johor', 'Penang'];

  //firestore
  final FirestoreService firestoreService = FirestoreService();


  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, show a Snackbar or proceed with your logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing Data for $_universityName')),
      );

      firestoreService.addUniversity(_universityName, _selectedState, _postcode, _address);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add University',style: TextStyle(
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
                onSaved: (value) {
                  _universityName = value!;
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
                onSaved: (value) {
                  _postcode = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
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
                onSaved: (value) {
                  _address = value!;
                },
              ),
              
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _submitForm();
                    // Process data
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