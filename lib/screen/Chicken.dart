import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/firestore.dart';
import '../services/item_firestore.dart';

class Chicken extends StatefulWidget {
  const Chicken({Key? key}) : super(key: key);

  @override
  State<Chicken> createState() => _ChickenState();
}

class _ChickenState extends State<Chicken> {
  final _itemFireStoreService = ItemFireStoreService();
  late Stream<QuerySnapshot> _itemsStream;

  String selectedSize = 'regular';

  @override
  void initState() {
    super.initState();
    _itemsStream = _itemFireStoreService.getItemsStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
                background: Image.asset(
                  "assets/cover6.png",
                  fit: BoxFit.cover,
                ),
              ),
              iconTheme: IconThemeData(
                  color: Colors.white), // Set icon color to white
            ),
          ];
        },

        body: StreamBuilder<QuerySnapshot>(
          stream: _itemsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List itemsList = snapshot.data!.docs;

              itemsList = itemsList.where((item) {
                return item["category"] == "chicken items";
              }).toList();

              return ListView.builder(
                  itemCount: itemsList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = itemsList[index];
                    String itemId = document.id;

                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    String imageURL = data['imageURL'];
                    String itemName = data['itemName'];
                    String regularPrice = data['regularPrice'];
                    String mediumPrice = data['mediumPrice'];
                    String largePrice = data['largePrice'];

                    Future<void> addItemToCart() async {
                      int price = 0;

                      if(selectedSize == 'regular') {
                        price = int.parse(regularPrice);
                      } else if(selectedSize == 'medium') {
                        price = int.parse(mediumPrice);
                      } else {
                        price = int.parse(largePrice);
                      }

                      if(globalUserID.isEmpty){
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.deepOrange.shade50,
                            title: const Text('Error!!!'),
                            content: const Text('Sign in required!'),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        int qty = 1;
                        final cart = FirebaseFirestore.instance.collection('users').doc(globalUserID).collection('cart').doc(itemId + selectedSize);

                        final item = await cart.get();
                        final itemDetails = item.data();
                        if(item.exists){
                          int existQty = itemDetails?['qty'];
                          int updatedQty = existQty + 1;

                          cart.update({
                            'qty': updatedQty
                          });
                        } else {
                          await cart.set({
                            'itemId': itemId,
                            'imageURL': imageURL,
                            'itemName': itemName,
                            'qty': qty,
                            'price': price,
                            'size': selectedSize
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Item added to cart!'),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Item added to cart!'),
                            ),
                          );
                        }
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
                                      height: 125.0,
                                      width: 125.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),


                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Radio<String>(
                                              activeColor: const Color.fromRGBO(197, 110, 51, 1.0),
                                              value: 'regular',
                                              groupValue: selectedSize,
                                              onChanged: (value) => setState(() => selectedSize = value!),
                                            ),

                                            Text("Regular"),

                                            Spacer(),

                                            Padding(
                                              padding: const EdgeInsets.only(right: 10.0),
                                              child: Text(
                                                regularPrice.isNotEmpty ? "Rs. $regularPrice" : "Rs. -",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            )
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            Radio<String>(
                                              activeColor: const Color.fromRGBO(197, 110, 51, 1.0),
                                              value: 'medium',
                                              groupValue: selectedSize,
                                              onChanged: (value) => setState(() => selectedSize = value!),
                                            ),

                                            Text("Medium"),

                                            Spacer(),

                                            Padding(
                                              padding: const EdgeInsets.only(right: 10.0),
                                              child: Text(
                                                mediumPrice.isNotEmpty ? "Rs. $mediumPrice" : "Rs. -",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            )
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            Radio<String>(
                                              activeColor: const Color.fromRGBO(197, 110, 51, 1.0),
                                              value: 'large',
                                              groupValue: selectedSize,
                                              onChanged: (value) => setState(() => selectedSize = value!),
                                            ),

                                            Text("Large"),

                                            Spacer(),

                                            Padding(
                                              padding: const EdgeInsets.only(right: 10.0),
                                              child: Text(
                                                largePrice.isNotEmpty ? "Rs. $largePrice" : "Rs. -",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: [
                                    Text(
                                      itemName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    Spacer(),

                                    TextButton(
                                      onPressed: addItemToCart,
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
                                        "Add",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
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
    );
  }
}
