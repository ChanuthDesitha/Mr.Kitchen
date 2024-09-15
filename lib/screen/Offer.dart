import 'package:flutter/material.dart';

class Offer extends StatelessWidget {
  const Offer({Key? key}) : super(key: key);

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
                  "assets/off1.png",
                  fit: BoxFit.cover,
                ),
              ),
              iconTheme: IconThemeData(color: Colors.black), // Set icon color to white
            ),
          ];
        },

        body: Container(
          color: Colors.white12, // Setting background color to yellow
          child: ListView(
            padding: EdgeInsets.all(5.0),
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 25),
                    Text(
                      "Special Offers",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                      ),
                    ),
                  ],
                ),
              ),

              _buildListItem(
                imagePath: "assets/p1.png",
                title: "BBQ Remedy",
                subtitle: "Rs.899",
                sizes: ["Regular", "Large"],
              ),

              _buildListItem(
                imagePath: "assets/p2.png",
                title: "Spicy Chicken",
                subtitle: "Rs.899",
                sizes: ["Regular", "Large"],
              ),

              _buildListItem(
                imagePath: "assets/p3.png",
                title: "Hot Veg",
                subtitle: "Rs.899",
                sizes: ["Regular", "Large"],
              ),

              _buildListItem(
                imagePath: "assets/p4.png",
                title: "Cheesy Loaded",
                subtitle: "Rs.899",
                sizes: ["Regular", "Large"],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem({
    required String imagePath,
    required String title,
    required String subtitle,
    required List<String> sizes,
  })  {

    return Card(
        elevation: 6,
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: SizedBox(
          height: 150,
          child: ListTile(
            leading: Image.asset(
              imagePath,
              width: 80,
              height: 80,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: sizes.map((size) {
                    return Container(
                      margin: EdgeInsets.only(right: 5),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        size,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                // Add functionality here
              },
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.orange),
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
            ),
            onTap: () {
              // Add functionality here
            },
          ),
        )
    );
  }
}