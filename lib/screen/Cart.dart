import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/firestore.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final _cartFireStoreService = FirestoreService();
  late Stream<QuerySnapshot> _cartStream;
  List<dynamic> _itemsList = [];

  @override
  void initState() {
    super.initState();
    if(globalUserID.isNotEmpty) {
      _cartStream = _cartFireStoreService.getCartStream();
      _cartStream.listen((snapshot) {
        setState(() {
          _itemsList =
            snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: globalUserID.isNotEmpty
            ?
        StreamBuilder(
            stream: _cartStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (_itemsList.isNotEmpty) {
                  int totalQuantity = 0;
                  int totalPrice = 0;

                  for (var item in _itemsList) {
                    totalQuantity += item['qty'] as int;
                    totalPrice += item['price'] * item['qty'] as int;
                  }

                  String generateUniqueId() {
                    final now = DateTime.now();
                    return '${now.millisecondsSinceEpoch}-${Random().nextInt(10000)}';
                  }
                  final orderId = generateUniqueId();

                  Future<void> placeOrder() async {
                    final order = FirebaseFirestore.instance.collection('orders').doc(orderId);
                    final cart = FirebaseFirestore.instance.collection('users').doc(globalUserID).collection('cart');
                    final cartSnapshot = await cart.get();

                    final batch = FirebaseFirestore.instance.batch();

                    Timestamp timestamp = Timestamp.now();

                    DateTime dateTime = timestamp.toDate();

                    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
                    String formattedTime = DateFormat('HH:mm:ss').format(dateTime);

                    try {
                      batch.set(order, {
                        'orderID': orderId,
                        'userID': globalUserID,
                        'total': totalPrice,
                        'total qty': totalQuantity,
                        'status': "Pending",
                        'time stamp': "$formattedDate $formattedTime",
                      });

                      for (var itemDoc in cartSnapshot.docs) {
                        final itemData = itemDoc.data();
                        final item = order.collection('items').doc(itemData['itemId'] + itemData['size']);
                        batch.set(item, itemData);
                      }

                      await batch.commit();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Order Placed Successfully!'),
                        ),
                      );

                      for (var itemDoc in cartSnapshot.docs) {
                        await itemDoc.reference.delete();
                      }
                    } catch (e) {
                      print('Error placing order: $e');
                    }
                  }

                  Future<void> confirmOrder() async {
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.deepOrange.shade50,
                          title: const Text('Confirm Order'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Column(
                                  children: _itemsList.map((item) =>
                                      Row(
                                        children: [
                                          Text(
                                              item['itemName'] + " x " +
                                                  item['qty'].toString()
                                          ),

                                          Spacer(),

                                          Text(
                                              "Rs. " +
                                                  (item['price'] * item['qty'])
                                                      .toString() + ".00"
                                          )
                                        ],
                                      )
                                  ).toList(),
                                ),

                                Divider(),

                                Row(
                                  children: [
                                    Text(
                                      "Total",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),

                                    Spacer(),

                                    Text(
                                      "Rs. $totalPrice.00",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () async {
                                await placeOrder();
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Place Order',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }

                  return Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: _itemsList.map((item) =>
                              _buildItem(item, context)).toList(),
                        ),
                      ),

                      Spacer(),

                      Divider(),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Text(
                              "Total:",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),

                            Spacer(),

                            Text(
                              "Rs. $totalPrice.00",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 15.0,
                      ),

                      ElevatedButton(
                        onPressed: confirmOrder,
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(
                              Colors.deepOrange.shade400),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(color: Colors.orange),
                            ),
                          ),
                        ),
                        child: Text(
                          "Place Order",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Your cart is empty!",
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.deepOrange.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  );
                }
              } else {
                return Center(
                    child: CircularProgressIndicator(color: Colors.black,));
              }
            }
        )
            :
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Please Sign in!",
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.deepOrange.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  Widget _buildItem(Map<String, dynamic> item, BuildContext context) {
    final int index = _itemsList.indexOf(item);
    String itemId = _itemsList[index]['itemId'];
    String imageURL = _itemsList[index]["imageURL"];
    String itemName = _itemsList[index]["itemName"];
    String size = _itemsList[index]["size"];
    int qty = _itemsList[index]["qty"];
    int price = _itemsList[index]["price"];

    final cart = FirebaseFirestore.instance.collection('users').doc(
        globalUserID).collection('cart').doc(itemId + size);

    int itemTotal = price * qty;

    Future<void> removeItem() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.deepOrange.shade50,
            title: const Text('Confirm Remove'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure to remove this item?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  cart.delete();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Remove',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[200]
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        imageURL,
                        height: 100.0,
                        width: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemName,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),

                            SizedBox(height: 10.0,),

                            Text(
                                size
                            ),

                            SizedBox(height: 10.0,),

                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      if (qty == 1) {
                                        removeItem();
                                      } else {
                                        int updatedQty = qty - 1;

                                        cart.update({
                                          'qty': updatedQty
                                        });
                                      }
                                    },
                                    icon: Icon(
                                        qty == 1 ? Icons.delete : Icons.remove)
                                ),

                                Text(
                                    "$qty"
                                ),

                                IconButton(
                                    onPressed: () {
                                      int updatedQty = qty + 1;

                                      cart.update({
                                        'qty': updatedQty
                                      });
                                    },
                                    icon: Icon(Icons.add)
                                ),

                                Spacer(),

                                Text(
                                  "Rs. $itemTotal.00",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
          ),
        ),
      ),
    );
  }
}
