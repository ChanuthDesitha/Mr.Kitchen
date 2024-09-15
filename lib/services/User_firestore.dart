import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

String generateUniqueId() {
  final now = DateTime.now();
  return '${now.millisecondsSinceEpoch}-${Random().nextInt(10000)}';
}

class UserFireStoreService {
  final CollectionReference users = FirebaseFirestore.instance.collection(
      'users');


  Stream<QuerySnapshot> getUserStream() {
    final usersStream = users.snapshots();
    return usersStream;
  }
}