import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestore.dart'; 
import 'package:flutter_application_1/add_user.dart';
import 'package:flutter_application_1/edit_user.dart';


class ManageUserPage extends StatefulWidget {
  @override
  _ManageUserPageState createState() => _ManageUserPageState();
}

class _ManageUserPageState extends State<ManageUserPage> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(237, 235, 222, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(28,68,64,1),
        title: Text('Manage Users',style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<DocumentSnapshot> userDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: userDocs.length,
            itemBuilder: (context, index) {
              // Assuming your User model has a named constructor that accepts a Map
              User user = User.fromDocument(userDocs[index]);
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Color.fromRGBO(28, 68, 64, 1)),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => EditUserPage(user: user),
                            ));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Implement deletion from Firestore here
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddUserPage()));
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromRGBO(28, 68, 64, 1),
      ),
    );
  }
}
