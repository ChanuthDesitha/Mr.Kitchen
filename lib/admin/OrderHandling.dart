import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/orders_firestore.dart';
import 'order_details.dart';

class OrderHandling extends StatefulWidget {
  @override
  _OrderHandlingState createState() => _OrderHandlingState();
}

class _OrderHandlingState extends State<OrderHandling> {
  final _itemFireStoreService = OrderFirestoreService();
  late Stream<QuerySnapshot> orderStream;
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    orderStream = _itemFireStoreService.getOderStream();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Handling",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.0,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: DropdownMenu(
              width: screenWidth - 20.0,
              label: Text(
                "Select Category",
                style: TextStyle(
                    color: Colors.black
                ),
              ),
              onSelected: (category) {
                if(category != null) {
                  setState(() {
                    selectedCategory = category;
                  });
                }
              },
              dropdownMenuEntries: <DropdownMenuEntry<String>>[
                DropdownMenuEntry(value: "pending", label: "Pending"),
                DropdownMenuEntry(value: "approved", label: "Approved"),
                DropdownMenuEntry(value: "cancelled", label: "Cancelled")
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: orderStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List orderList = snapshot.data!.docs;

                  switch(selectedCategory) {
                    case "pending":
                      orderList = orderList.where((item) {
                        return item["status"] == "Pending";
                      }).toList();
                      break;
                    case "approved":
                      orderList = orderList.where((item) {
                        return item["status"] == "Approved";
                      }).toList();
                      break;
                    case "cancelled":
                      orderList = orderList.where((item) {
                        return item["status"] == "Cancelled";
                      }).toList();
                      break;
                    default:
                      null;
                  }

                  return ListView.builder(
                      itemCount: orderList.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = orderList[index];
                        String itemId = document.id;

                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        String orderID = data['orderID'];
                        String status = data['status'];
                        String timeStamp = data['time stamp'];
                        int total = data['total'];
                        int qty = data['total qty'];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => OrderDetails(data: data)),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[200]
                              ),
                              child: Padding(
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
                                        ),
                                      ],
                                    ),
                            
                                    Text(
                                      "Date & Time: $timeStamp"
                                    ),
                            
                                    Text(
                                      "Item count: $qty"
                                    ),
                            
                                    Text(
                                      "Total: Rs. $total.00",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  );
                } else {
                  return const Center(child: CircularProgressIndicator(color: Colors.black,));
                }
              },
            ),
          ),
        ],
      ),

    );
  }
}

void main() {
  runApp(MaterialApp(
    home: OrderHandling(),
  ));
}
