import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/item_firestore.dart';

class UpdateItem extends StatefulWidget {
  final Map<String, dynamic> data;
  const UpdateItem({super.key, required this.data});

  @override
  _UpdateItemState createState() => _UpdateItemState();
}

class _UpdateItemState extends State<UpdateItem> {
  String itemId = '';
  String imageURL = '';
  String itemName = '';
  String regularPrice = '';
  String mediumPrice = '';
  String largePrice = '';
  String selectedCategory = '';

  bool isRegularChecked = false;
  bool isMediumChecked = false;
  bool isLargeChecked = false;

  @override
  void initState() {
    super.initState();
    itemId = widget.data['itemId'] ?? '';
    itemName = widget.data['itemName'] ?? '';
    imageURL = widget.data['imageURL'] ?? '';
    selectedCategory = widget.data['category'] ?? '';
    regularPrice = widget.data['regularPrice'] ?? '';
    mediumPrice = widget.data['mediumPrice'] ?? '';
    largePrice = widget.data['largePrice'] ?? '';

    if(regularPrice.isNotEmpty) {
      setState(() {
        isRegularChecked = true;
      });
    }

    if(mediumPrice.isNotEmpty) {
      setState(() {
        isMediumChecked = true;
      });
    }

    if(largePrice.isNotEmpty) {
      setState(() {
        isLargeChecked = true;
      });
    }
  }

  late final itemNameController = TextEditingController()..text = itemName;
  late final regularPriceController = TextEditingController()..text = regularPrice;
  late final mediumPriceController = TextEditingController()..text = mediumPrice;
  late final largePriceController = TextEditingController()..text = largePrice;

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

  Future<void> _updateItem() async {
    final updatedImageURL = await uploadImage();

    if(imageURL.isNotEmpty) {
      await _fireStoreService.updateItem(
        itemId,
        updatedImageURL.isNotEmpty ? updatedImageURL : imageURL,
        itemNameController.text,
        selectedCategory,
        regularPriceController.text,
        mediumPriceController.text,
        largePriceController.text
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Item updated successfully!'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Items",
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
              Image.network(
                imageURL,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
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
              controller: itemNameController,
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
              onPressed: _updateItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Center(
                child: Text('Update Item'),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
