import 'package:cloud_firestore/cloud_firestore.dart';

class University {
  final String id;
  final String name;
  final String state;
  final String postcode;
  final String address;

  University({
    required this.id,
    required this.name,
    required this.state,
    required this.postcode,
    required this.address,
  });

  factory University.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return University(
      id: doc.id,
      name: data['universityName'] ?? '',
      state: data['state'] ?? '',
      postcode: data['postcode'] ?? '',
      address: data['address'] ?? '',
    );
  }
}

class User {
  String id;
  String name;
  String studentID;
  String password;
  int age;
  String email;
  String university;

  User({
    required this.id,
    required this.name,
    required this.studentID,
    required this.password,
    required this.age,
    required this.email,
    required this.university,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return User(
      id: doc.id,
      name: data['name'] ?? '',
      studentID: data['studentID'] ?? '',
      password: data['password'] ?? '',
      age: data['age'] ?? 0,
      email: data['email'] ?? '',
      university: data['university'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'studentID': studentID,
      'password': password,
      'age': age,
      'email': email,
      'university': university,
    };
  }
}

class Vendor {
  String id;
  String name;
  String vendorID;
  String password;
  String email;
  String university;

  Vendor({
    required this.id,
    required this.name,
    required this.vendorID,
    required this.password,
    required this.email,
    required this.university,
  });

  factory Vendor.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Vendor(
      id: doc.id,
      name: data['name'] ?? '',
      vendorID: data['vendorID'] ?? '',
      password: data['password'] ?? '',
      email: data['email'] ?? '',
      university: data['university'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'vendorID': vendorID,
      'password': password,
      'email': email,
      'university': university,
    };
  }
}

class FirestoreService {
  // get collection of data
  final CollectionReference universities =
    FirebaseFirestore.instance.collection('universities');

  //CREATE
  Future<void> addUniversity(String universityName, String state, String postcode, String address) {
    return universities.add({
      'universityName': universityName,
      'state': state,
      'postcode': postcode,
      'address': address,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  //READ
  Stream<QuerySnapshot> getUniversitiesStream() {
    final universitiesStream = universities.orderBy('timestamp', descending: true).snapshots();

    return universitiesStream;
  }

  Future<List<String>> getUniversityNames() async {
  QuerySnapshot querySnapshot = await universities.get();
  return querySnapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .where((data) => data['universityName'] != null) // Ensure 'universityName' is not null
      .map((data) => data['universityName'] as String) // Safely cast as String
      .toList();
}


  //UPDATE
  Future<void> editUniversity(String docID, Map<String, dynamic> newUniversity) {
    return universities.doc(docID).update(newUniversity);
  }

  //DELETE
  Future<void> deleteUniversity(String docID) {
    return universities.doc(docID).delete();
  }


  //USER CRUD OPERATIONS
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(User user) {
    return users.add(user.toMap());
  }

  Stream<QuerySnapshot> getUsersStream() {
    return users.snapshots();
  }

  Future<void> updateUser(String docID, Map<String, dynamic> newData) {
    return users.doc(docID).update(newData);
  }

  Future<void> deleteUser(String docID) {
    return users.doc(docID).delete();
  }

//VENDOR CRUD OPERATIONS
  final CollectionReference vendors = FirebaseFirestore.instance.collection('users');

  Future<void> addVendors(User user) {
    return users.add(user.toMap());
  }

  Stream<QuerySnapshot> getVendorsStream() {
    return users.snapshots();
  }

  Future<void> updateVendor(String docID, Map<String, dynamic> newData) {
    return users.doc(docID).update(newData);
  }

  Future<void> deleteVendor(String docID) {
    return users.doc(docID).delete();
  }
}