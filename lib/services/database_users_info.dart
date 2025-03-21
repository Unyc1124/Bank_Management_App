import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseUserInfo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to store user information in Firestore under "users/{uid}/user_information/{info_id}"
  Future<void> createUserInfo({
    required String uid,
    required String name,
    required String accountNumber,
    required String address,
    required String branch,
    required String panNumber,
    required double balance,
    required String registeredMobileNumber,
  }) async {
    try {
      // Generating a unique document ID inside the user_information sub-collection
      String infoId = _firestore.collection("users").doc(uid).collection("user_information").doc().id;

      await _firestore.collection("users").doc(uid).collection("user_information").doc(infoId).set({
        "name": name,
        "accountNumber": accountNumber,
        "address": address,
        "branch": branch,
        "panNumber": panNumber,
        "balance": balance,
        "registeredMobileNumber": registeredMobileNumber,
        "createdAt": FieldValue.serverTimestamp(),
      });

      print("User information added successfully!");
    } catch (e) {
      print("Error adding user information: $e");
    }
  }

  // Function to get user information
  Future<DocumentSnapshot?> getUserInfo(String uid) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection("users").doc(uid).collection("user_information").get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first; // Returning first document (Assuming only one info doc per user)
      }
      return null;
    } catch (e) {
      print("Error fetching user information: $e");
      return null;
    }
  }
}
