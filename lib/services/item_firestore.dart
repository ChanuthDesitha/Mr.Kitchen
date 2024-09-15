import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

String generateUniqueId() {
  final now = DateTime.now();
  return '${now.millisecondsSinceEpoch}-${Random().nextInt(10000)}';
}

class ItemFireStoreService {
  final CollectionReference items = FirebaseFirestore.instance.collection('items');

  Future<void> addItem(String imageURL, String itemName, String category, String regularPrice, String mediumPrice, String largePrice) {
    final itemId = generateUniqueId();

    return items.doc(itemId).set({
      'itemId': itemId,
      'imageURL': imageURL,
      'itemName': itemName,
      'category': category,
      'regularPrice': regularPrice,
      'mediumPrice': mediumPrice,
      'largePrice': largePrice
    });
  }

  Stream<QuerySnapshot> getItemsStream() {
    final itemsStream = items.snapshots();
    return itemsStream;
  }

  Future<void> updateItem(String itemId, String imageURL, String itemName, String category, String regularPrice, String mediumPrice, String largePrice) {
    return items.doc(itemId).update({
      'itemId': itemId,
      'imageURL': imageURL,
      'itemName': itemName,
      'category': category,
      'regularPrice': regularPrice,
      'mediumPrice': mediumPrice,
      'largePrice': largePrice
    });
  }

  Future<void> removeItem(String itemId) {
    return items.doc(itemId).delete();
  }
}

