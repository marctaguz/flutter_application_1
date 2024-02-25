import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/services/firestore.dart';


class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  late String _studentID;
  late String _password;
  late String _email;
  late String _name;
  late int _age;
  String? _selectedUniversity = '';

  final FirestoreService firestoreService = FirestoreService();

  List<String> _universityNames = []; //list to store university options
  @override
  void initState() {
    super.initState();
    _fetchUniversityNames();
  }

  //Fetch university names from Firestore
  void _fetchUniversityNames() async {
    List<String> universityNames = await firestoreService.getUniversityNames();
    setState(() {
      _universityNames = universityNames;
      if(_universityNames.isNotEmpty) {
        _selectedUniversity = _universityNames.first;
      } else {
      _selectedUniversity = null; // Explicitly handle the case of an empty list
    }
    });
  }


  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {

      User newUser = User(
        id: '',
        name: _name,
        studentID: _studentID,
        password: _password,
        age: _age,
        email: _email,
        university: _selectedUniversity ?? 'N/A',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing Data for $_name')),
      );
      firestoreService.addUser(newUser);
      Navigator.pop(context);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User',style: TextStyle(
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
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  _studentID = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter user password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter full name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number, // Use number input type
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow digits only
                  LengthLimitingTextInputFormatter(2), // Limit to 5 characters
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the age';
                  }
                  return null;
                },
                onSaved: (value) {
                  _age = int.tryParse(value!) ?? 0;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter user email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'University',
                  border: OutlineInputBorder(),
                ),
                value: _selectedUniversity!.isEmpty ? null : _selectedUniversity,
                items: _universityNames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUniversity = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a university';
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