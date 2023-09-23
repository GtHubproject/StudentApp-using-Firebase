import 'package:cloud_firestore/cloud_firestore.dart';
class FirestoreServices {
  static saveUser(String name, String email, String phoneNumber,int age, String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'age': age,
      // 'imageUrl': imageUrl,
    });
  }

  static updateUser(String uid, Map<String, dynamic> updatedUserData) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update(updatedUserData);
  }

  static deleteUser(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
  }
}
