import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/admin/Update_item.dart';

import '../services/item_firestore.dart';

class Update extends StatefulWidget {
  const Update({Key? key}) : super(key: key);

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final _itemFireStoreService = ItemFireStoreService();
  late Stream<QuerySnapshot> _itemsStream;

  String selectedSize = 'medium';
  String selectedCategory = "";

  @override
  void initState() {
    super.initState();
    _itemsStream = _itemFireStoreService.getItemsStream();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update & Remove Items",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
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
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
              child: Text(
                  "Select a category to filter items",
                style: TextStyle(
                    color: Colors.deepOrange.shade800,
                  fontSize: 20.0,
                ),
              ),
            ),
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
                DropdownMenuEntry(value: "pizza", label: "Pizza"),
                DropdownMenuEntry(value: "burger", label: "Burger"),
                DropdownMenuEntry(value: "french fries", label: "French fries"),
                DropdownMenuEntry(value: "salad", label: "Salad"),
                DropdownMenuEntry(value: "special items", label: "Special items"),
                DropdownMenuEntry(value: "chicken items", label: "Chicken items"),
                DropdownMenuEntry(value: "beverages", label: "Beverages"),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _itemsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List itemsList = snapshot.data!.docs;

                  switch(selectedCategory) {
                    case "pizza":
                      itemsList = itemsList.where((item) {
                        return item["category"] == "pizza";
                      }).toList();
                      break;
                    case "burger":
                      itemsList = itemsList.where((item) {
                        return item["category"] == "burger";
                      }).toList();
                      break;
                    case "french fries":
                      itemsList = itemsList.where((item) {
                        return item["category"] == "french fries";
                      }).toList();
                      break;
                    case "salad":
                      itemsList = itemsList.where((item) {
                        return item["category"] == "salad";
                      }).toList();
                      break;
                    case "special items":
                      itemsList = itemsList.where((item) {
                        return item["category"] == "special items";
                      }).toList();
                      break;
                    case "chicken items":
                      itemsList = itemsList.where((item) {
                        return item["category"] == "chicken items";
                      }).toList();
                      break;
                    case "beverages":
                      itemsList = itemsList.where((item) {
                        return item["category"] == "beverages";
                      }).toList();
                      break;
                    default:
                      null;
                  }
            
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
                                      _itemFireStoreService.removeItem(itemId);

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text('Item Removed Successfully!'),
                                        ),
                                      );
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
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
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

                                              SizedBox(height: 10.0,),

                                              Row(
                                                children: [
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

                                              SizedBox(height: 10.0,),

                                              Row(
                                                children: [
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
                                          onPressed: removeItem,
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
                                            "Remove",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: 5.0,),

                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => UpdateItem(data: data)),
                                            );
                                          },
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
                                            "Update",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
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
        ],
      ),
    );
  }
}
