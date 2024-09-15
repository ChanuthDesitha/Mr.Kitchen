import 'package:cloud_firestore/cloud_firestore.dart';

class OrderFirestoreService {
  final CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Stream<QuerySnapshot> getOderStream() {
    final orderStream = orders.orderBy('time stamp', descending: true).snapshots();
    return orderStream;
  }

  Stream<QuerySnapshot> getItemsStream(String orderID) {
    final itemsStream = orders.doc(orderID).collection('items').snapshots();
    return itemsStream;
  }
}