import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestore.dart'; 

class EditUserPage extends StatefulWidget {
  final User user;

  EditUserPage({required this.user}); // Modify constructor to accept a user

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;


  final List<String> _states = ['Select State', 'Selangor', 'Kuala Lumpur', 'Perak', 'Pahang', 'Negeri Sembilan', 'Kedah', 'Kelantan', 'Sabah', 'Sarawak', 'Johor', 'Penang'];

  @override
  void initState() {
    super.initState();
    // Initialize the form fields with the data of the user that's being edited
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);

  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Function to handle form submission
  void _submitForm() {
  if (_formKey.currentState!.validate()) {
    // Access values directly from the controllers
    String userName = _nameController.text;
    String email = _emailController.text;
    // Use these values as needed

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Processing Data for $userName')),
    );
    // Add your logic to update the user information here
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User',style: TextStyle(
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
                  labelText: 'User Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the user name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the user email';
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