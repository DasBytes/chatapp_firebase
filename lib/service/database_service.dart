import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collection

  final CollectionReference userCollection = 
   FirebaseFirestore.instance.collection("users");

    final CollectionReference groupCollection = 
   FirebaseFirestore.instance.collection("groups");



  // updating the userdata

  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic" : "",
      "uid": uid,
    });

  }
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();

    return snapshot;
  }

  //get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }
}