import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/firestore.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final _cartFireStoreService = FirestoreService();
  late Stream<QuerySnapshot> _cartStream;

  @override
  void initState() {
    super.initState();
    _cartStream = _cartFireStoreService.getCartStream();
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
        child: StreamBuilder(
          stream: _cartStream,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              List cartList = snapshot.data!.docs;

              if(cartList.isNotEmpty) {
                int totalQuantity = 0;
                int totalPrice = 0;

                for (var item in cartList) {
                  totalQuantity += item['qty'] as int;
                  totalPrice += item['price'] * item['qty'] as int;
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartList.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = cartList[index];
                          String itemId = document.id;

                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          String imageURL = data['imageURL'];
                          String itemName = data['itemName'];
                          int price = data['price'];
                          int qty = data['qty'];
                          String size = data['size'];

                          int itemTotal = price * qty;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[200]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Image.network(
                                      imageURL,
                                      width: 100.0,
                                      height: 100.0,
                                      fit: BoxFit.cover,
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
                                                Text(
                                                  "Qty x $qty"
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
                              ),
                            ),
                          );
                        },
                      ),
                    ),

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
                      onPressed: (){},
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepOrange.shade400),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                  children: [
                    Text(
                      "Your cart is empty!",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                );
              }
            } else {
              return Center(child: CircularProgressIndicator(color: Colors.black,));
            }
          }
        ),
      ),
    );
  }
}
