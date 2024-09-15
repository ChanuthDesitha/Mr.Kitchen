import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../services/item_firestore.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  String itemName = '';
  bool isRegularChecked = false;
  bool isMediumChecked = false;
  bool isLargeChecked = false;

  final regularPriceController = TextEditingController();
  final mediumPriceController = TextEditingController();
  final largePriceController = TextEditingController();

  String selectedCategory = "";
  PlatformFile? pickedFile;
  Uint8List? _imageBytes;
  final _fireStoreService = ItemFireStoreService();

  Future<void> getImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
        _imageBytes = pickedFile?.bytes;
      });
    }
  }

  Future<String> uploadImage() async {
    if (pickedFile == null) {
      return "";
    }
    try {
      final fileBytes = pickedFile?.bytes;
      final fileName = pickedFile?.name;
      final imageRef = FirebaseStorage.instance.ref('images/$fileName');
      await imageRef.putData(fileBytes!);
      final downloadUrl = await imageRef.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      print(e.message);
      return "";
    }
  }

  Future<void> _addItem() async {
    final imageURL = await uploadImage();

    if(imageURL.isNotEmpty) {
      await _fireStoreService.addItem(
        imageURL,
        itemName,
        selectedCategory,
        regularPriceController.text,
        mediumPriceController.text,
        largePriceController.text
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Item added successfully!'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Items",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: getImage,
              child: pickedFile == null
                  ?
              Container(
                width: 100,
                height: 100,
                color: Colors.grey,
                child: Icon(Icons.add_a_photo),
              )
                  :
              Image.memory(
                _imageBytes!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Item Name'),
              onChanged: (value) {
                setState(() {
                  itemName = value;
                });
              },
            ),

            SizedBox(height: 20.0),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: DropdownMenu(
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

            SizedBox(height: 20.0),

            Text(
              'Select Size:',
              style: TextStyle(fontSize: 16.0),
            ),

            SizedBox(height: 10.0),

            //regular
            Row(
              children: [
                Checkbox(
                  value: isRegularChecked,
                  onChanged: (value) {
                    setState(() {
                      isRegularChecked = !isRegularChecked;
                    });
                  },
                ),

                Text(
                    "Regular"
                ),

                Spacer(),

                if(isRegularChecked)
                Container(
                  width: 200.0,
                  child: TextField(
                    controller: regularPriceController,
                  ),
                )
              ],
            ),

            //medium
            Row(
              children: [
                Checkbox(
                  value: isMediumChecked,
                  onChanged: (value) {
                    setState(() {
                      isMediumChecked = !isMediumChecked;
                    });
                  },
                ),

                Text(
                    "Medium"
                ),

                Spacer(),

                if(isMediumChecked)
                  Container(
                    width: 200.0,
                    child: TextField(
                      controller: mediumPriceController,
                    ),
                  )
              ],
            ),

            //large
            Row(
              children: [
                Checkbox(
                  value: isLargeChecked,
                  onChanged: (value) {
                    setState(() {
                      isLargeChecked = !isLargeChecked;
                    });
                  },
                ),

                Text(
                    "Large"
                ),

                Spacer(),

                if(isLargeChecked)
                  Container(
                    width: 200.0,
                    child: TextField(
                      controller: largePriceController,
                    ),
                  )
              ],
            ),

            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Center(
                child: Text('Add Item'),
              ),
            ),

          ],
        ),
      ),
    );
  }
}


