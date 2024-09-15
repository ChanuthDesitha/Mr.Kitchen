import 'package:flutter/material.dart';
import 'package:restaurant_app/admin/ViewUser.dart';
import 'package:restaurant_app/admin/update.dart';
import '../screen/Register.dart';
import '../screen/search.dart';
import 'Add.dart';
import 'OrderHandling.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              floating: false,
              pinned: false,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
                background: Image.asset(
                  "assets/mr.png",
                  fit: BoxFit.cover,
                ),
              ),
              iconTheme: IconThemeData(
                  color: Colors.white), // Set icon color to white
            ),
          ];
        },

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: (){
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Register()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    icon: Icon(Icons.logout_rounded)
                  ),
                ],
              ),

              const Text(
                "Admin Panel",
                textAlign: TextAlign.center, // Set the text alignment to center
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

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
                      padding: EdgeInsets.only(left: 10, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
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

              _buildListItem(
                imagePath: "assets/admin.png",
                icon: Icons.remove_red_eye_rounded,
                title: "View users",
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewUser()),
                  );
                },
              ),

              _buildListItem(
                imagePath: "assets/admin.png",
                icon: Icons.add_circle,
                title: "Add Items",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Add()),
                  );
                },
              ),

              _buildListItem(
                imagePath: "assets/admin.png",
                icon: Icons.update,
                title: "Update & Remove Items",
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Update()),
                  );
                },
              ),

              _buildListItem(
                imagePath: "assets/admin.png",
                icon: Icons.drag_handle_outlined,
                title: "Order Handling",
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderHandling()),
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem({
    required String imagePath,
    required IconData icon,
    required String title,
    required VoidCallback onTap, // Adding onTap callback
  }) {

    return Center(
      child: Card(
        elevation: 6,
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Adding rounded corners to the card
        ),
        color: Colors.deepOrange.shade400,

        child: ListTile(
          contentPadding: EdgeInsets.all(15),
          // Adding padding to the ListTile content
          onTap: onTap,
          // Assigning onTap callback
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(15), // Adding border radius to the leading image
            child: Image.asset(
              imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),

          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Changing text color to blue
            ),
          ),

          trailing: Icon(
            icon,
            color: Colors.white, // Changing icon color to green
            size: 30, // Adjusting icon size
          ),
        ),
      ),
    );
  }
}

Widget _buildListItem({
  required String imagePath,
  required IconData icon,
  required String title,
  required VoidCallback onTap, // Adding onTap callback
}) {
  return Card(
    elevation: 6,
    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0), // Adding rounded corners to the card
    ),
    color: Colors.blueGrey,
    child: ListTile(
      contentPadding: EdgeInsets.all(15),
      // Adding padding to the ListTile content
      onTap: onTap,
      // Assigning onTap callback
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(15), // Adding border radius to the leading image
        child: Image.asset(
          imagePath,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Changing text color to blue
        ),
      ),
      trailing: Icon(
        icon,
        color: Colors.white, // Changing icon color to green
        size: 30, // Adjusting icon size
      ),
    ),
  );
}