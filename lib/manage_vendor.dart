import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestore.dart'; 
import 'package:flutter_application_1/add_vendor.dart';
import 'package:flutter_application_1/edit_vendor.dart';


class ManageVendorPage extends StatefulWidget {
  @override
  _ManageVendorPageState createState() => _ManageVendorPageState();
}

class _ManageVendorPageState extends State<ManageVendorPage> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(237, 235, 222, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(28,68,64,1),
        title: Text('Manage Vendors',style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getVendorsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<DocumentSnapshot> vendorDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: vendorDocs.length,
            itemBuilder: (context, index) {
              Vendor vendor = Vendor.fromDocument(vendorDocs[index]);
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(vendor.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Color.fromRGBO(28, 68, 64, 1)),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => EditVendorPage(vendor: vendor),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddVendorPage()));
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromRGBO(28, 68, 64, 1),
      ),
    );
  }
}
