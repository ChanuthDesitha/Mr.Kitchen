import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

String globalUserID = '';

String generateUniqueId() {
  final now = DateTime.now();
  return '${now.millisecondsSinceEpoch}-${Random().nextInt(10000)}';
}

class FirestoreService {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String username, String email, String mobileNo, String password) {
    final userId = generateUniqueId();
    return users.doc(email).set({
      'userId': userId,
      'username': username,
      'email': email,
      'mobileNo': mobileNo,
      'password': password,
      'address': ''
    });
  }

  Future<void> updateUser(String username, String email, String mobileNo, String address) {
    return users.doc(email).update({
      'username': username,
      'email': email,
      'mobileNo': mobileNo,
      'address': address,
    });
  }

  Stream<QuerySnapshot> getCartStream() {
    final cartStream = users.doc(globalUserID).collection('cart').snapshots();
    return cartStream;
  }
}

