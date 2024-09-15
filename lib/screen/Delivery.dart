import 'package:flutter/material.dart';

class Delivery extends StatelessWidget {

  @override

  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: Text(
            "Delivery",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.orangeAccent,
        ),

        body: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Colors.white54,
              margin: const EdgeInsets.only(top: 10.0),
              padding: const EdgeInsets.all(25.0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    "assets/delivery.png",
                    height: 275,
                  ),

                  SizedBox(height: 25),
                  Text(
                    "Delivery",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),

                  SizedBox(height: 10),
                  Text(
                    "A courier is a person or organisation that delivers a message, package, or letter from one place or person to another. In the parcel delivery industry, this means sending a parcel, via a company, to a recipient.",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),

                  SizedBox(height: 25),
                  Text(
                    "Contact Information:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),

                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.phone),
                      SizedBox(width: 10),
                      Text(
                        "071 111 222 3",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Icon(Icons.phone),
                      SizedBox(width: 10),
                      Text(
                        "071 111 222 4",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Text(
                    "___________________________________________",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      );
  }
}
