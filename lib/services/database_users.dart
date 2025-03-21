import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to store user data in Firestore
  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
    required String accountNumber,
    required String? profileImageUrl,
  }) async {
    try {
      await _firestore.collection("users").doc(uid).set({
        "name": name,
        "email": email,
        "accountNumber": accountNumber,
        "profileImageUrl": profileImageUrl ?? "",
        "createdAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error creating user: $e");
    }
  }
}
