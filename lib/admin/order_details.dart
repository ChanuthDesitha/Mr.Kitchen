import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/orders_firestore.dart';

class OrderDetails extends StatefulWidget {
  final Map<String, dynamic> data;
  const OrderDetails({super.key, required this.data});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final _orderFireStoreService = OrderFirestoreService();
  late Stream<QuerySnapshot> _orderStream;
  String userId = '';
  String orderID = '';
  String status = '';
  String timeStamp = '';
  int total = 0;
  int qty = 0;
  String cusName = '';
  String email = '';
  String mobileNumber = '';

  @override
  void initState() {
    super.initState();
    userId = widget.data['userID'] ?? '';
    orderID = widget.data['orderID'] ?? '';
    status = widget.data['status'] ?? '';
    timeStamp = widget.data['time stamp'] ?? '';
    total = widget.data['total'] ?? '';
    qty = widget.data['total qty'] ?? '';

    _getUserDetails();
    _orderStream = _orderFireStoreService.getItemsStream(orderID);
  }

  Future<void> _getUserDetails() async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      final userData = userDoc.data()!;
      setState(() {
        cusName = userData['username'] ?? '';
        email = userData['email'] ?? '';
        mobileNumber = userData['mobileNo'] ?? '';
      });
    } else {
      print('User document not found');
    }
  }

  Future<void> updateStatus() async {
    final order = FirebaseFirestore.instance.collection('orders').doc(orderID);

    await order.update({
      'status': status
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('Order $status!'),
      ),
    );

    Navigator.of(context).pop();
  }

  Future<void> cancelOrder() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.deepOrange.shade50,
          title: const Text('Cancel Order'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to cancel this order?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              onPressed: () {
                setState(() {
                  status = "Cancelled";
                });
                updateStatus();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Yes',
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
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  orderID,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),

                Spacer(),

                Text(
                  status
                )
              ],
            ),

            Divider(),

            Text(
              "Customer Name: $cusName"
            ),

            Text(
              "Email: $email"
            ),

            Text(
              "Mobile Number: $mobileNumber"
            ),

            Divider(),

            StreamBuilder<QuerySnapshot>(
                stream: _orderStream,
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    final itemList = snapshot.data!.docs;

                    List<Widget> itemWidgets = [];
                    for (var doc in itemList) {
                      final itemData = doc.data()! as Map<String, dynamic>;
                      itemWidgets.add(_buildOrderItem(itemData));
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                                "Item Count: $qty"
                            ),
                          ),

                          Column(
                            children: itemWidgets,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator(
                      color: Colors.black,
                    ));
                  }
                }
            ),

            Spacer(),

            const Divider(),

            Row(
              children: <Widget>[
                const Text(
                    "Total",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                    )
                ),

                const Spacer(),

                Text(
                    "Rs. $total.00",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                    )
                ),
              ],
            ),

            if(status == "Pending")
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      if(status == "Pending") {
                        status = "Approved";
                      }
                    });
                    updateStatus();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.deepOrange.shade400),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(color: Colors.deepOrange.shade400),
                      ),
                    ),
                  ),
                  child: Text(
                    status == "Pending" ? "Approve" : "",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: TextButton(
                    onPressed: cancelOrder,
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> itemData) {
    final itemName = itemData['itemName'];
    final size = itemData['size'];
    final qty = itemData['qty'];
    final price = itemData['price'];

    return Column(
      children: [
        Row(
          children: <Widget>[
            Text(
              itemName,
              style: const TextStyle(
                  fontSize: 17.0
              ),
            ),

            Text(
              " ($size)"
            ),

            const SizedBox(width: 10.0,),

            const Text(
                "X"
            ),

            const SizedBox(width: 10.0,),

            Text(
              "$qty",
              style: const TextStyle(
                  fontSize: 17.0
              ),
            ),

            const Spacer(),

            Text(
                "Rs. $price.00"
            ),
          ],
        ),
      ],
    );
  }
}
