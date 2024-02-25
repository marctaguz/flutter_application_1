import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestore.dart'; // Adjust the import path as needed
import 'package:flutter_application_1/add_university.dart';
import 'package:flutter_application_1/edit_university.dart';

class ManageUniversityPage extends StatefulWidget {
  @override
  _ManageUniversityPageState createState() => _ManageUniversityPageState();
}

class _ManageUniversityPageState extends State<ManageUniversityPage> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(237, 235, 222, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(28, 68, 64, 1),
        title: Text('Manage Universities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getUniversitiesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Extracting documents from the snapshot
          List<DocumentSnapshot> universitiesList = snapshot.data!.docs;

          // Displaying documents as a list
          return ListView.builder(
            itemCount: universitiesList.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = universitiesList[index];
              Map<String, dynamic> university = document.data()! as Map<String, dynamic>;

              // Displaying as a list tile
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(university['universityName'], style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Color.fromRGBO(28, 68, 64, 1)),
                        onPressed: () {
                          University selectedUniversity = University.fromDocument(universitiesList[index]);
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => EditUniversityPage(university: selectedUniversity)));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          firestoreService.deleteUniversity(document.id)
                            .then((_) {
                              // Optionally, show a success message
                            })
                            .catchError((error) {
                              // Handle error
                            });
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddUniversityPage()));
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromRGBO(28, 68, 64, 1),
      ),
    );
  }
}
