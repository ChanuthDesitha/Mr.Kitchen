import 'package:flutter/material.dart';
import 'package:restaurant_app/screen/Burger.dart';
import 'package:restaurant_app/screen/Chicken.dart';
import 'package:restaurant_app/screen/Chips.dart';
import 'package:restaurant_app/screen/Drinks.dart';
import 'package:restaurant_app/screen/Other.dart';
import 'package:restaurant_app/screen/PizzMenuPage.dart';
import 'package:restaurant_app/screen/Salad.dart';
import 'package:restaurant_app/screen/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Mr.Kitchen  👨🏻‍🍳",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 40, 50, 35), // left, top, right, bottom
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        Search()), // Corrected typo in route name
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.deepOrange, Colors.white],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    border: Border.all(
                      color: Colors.deepOrange, // Border color
                      width: 2, // Border width
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          iconSize: 30,
                          icon: Icon(Icons.search, color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  Search()), // Corrected typo in route name
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom: 5, left: 20),
              child: Center(
                child: Text(
                  "...Our Menu...",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 20),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: Colors.deepOrange,
                        thickness: 2,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust horizontal margin as needed
                      child: Text(
                        "👇",
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 25,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Divider(
                        color: Colors.deepOrange,
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10), // left, top, right, bottom
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      SizedBox(width: 15.0),
                      Image.asset("assets/p4.png"),
                      Image.asset("assets/b4.png"),
                      Image.asset("assets/s1.png"),
                      Image.asset("assets/o3.png"),
                      Image.asset("assets/d1.png"),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.all(15), // Add margin of 10
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),

                    tileColor: Colors.deepOrangeAccent,
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.local_pizza,
                        color: Colors.white,
                      ),
                    ),

                    title: Text(
                      "Pizza",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white, // Added text color
                      ),
                    ),

                    subtitle: Text(
                      "Choose your favorite pizza...",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white, // Changed text color
                      ),
                    ),

                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            PizzMenuPage()), // Corrected typo in route name
                      );
                    },
                  ),


                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    tileColor: Colors.white,
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.food_bank,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      "Burger",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "Choose your favorite Burger...",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Burger()),
                      );
                    },
                  ),

                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    tileColor: Colors.deepOrangeAccent,
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.local_drink_rounded,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      "French fries",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "Choose your favorite French fries...",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Chips()),
                      );
                    },
                  ),

                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    tileColor: Colors.white,
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Icon(
                        Icons.rice_bowl,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      "Salads",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "Choose your favorite Salads...",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Salad()),
                      );
                    },
                  ),

                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    tileColor: Colors.deepOrangeAccent,
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.fastfood,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      "Special items",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "Choose your favorite Special items...",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Other()),
                      );
                    },
                  ),

                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    tileColor: Colors.white,
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.food_bank,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      "Chicken items",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "Choose your favorite Chicken items...",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Chicken()),
                      );
                    },
                  ),

                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    tileColor: Colors.deepOrangeAccent,
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.emoji_food_beverage,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      "Beverages",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "Choose your favorite Beverages...",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Drinks()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
