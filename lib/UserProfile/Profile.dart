import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/services/firestore.dart';
import '../screen/Register.dart';
import 'UserProfileUpdate.dart';
import 'user_orders.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = '';
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [

                  globalUserID.isNotEmpty
                      ?
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance.collection('users').doc(globalUserID).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final userDetails = snapshot.data!.data();
                        username = userDetails?['username'];
                        email = userDetails?['email'];

                        return Column(
                          children: [
                            // SizedBox(height: 20.0,),
                            //
                            // CircleAvatar(
                            //   radius: 70.0,
                            //   backgroundImage: imageURL.isEmpty
                            //       ?
                            //   const ResizeImage(
                            //       AssetImage("images/profile.jpg"),
                            //       width: 350,
                            //       height: 350
                            //   )
                            //       :
                            //   ResizeImage(
                            //       NetworkImage(imageURL),
                            //       width: 350,
                            //       height: 350
                            //   ),
                            // ),
                            //
                            // SizedBox(height: 10.0,),

                            Text(
                              "$username",
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5.0),

                            Text(
                              "$email",
                              style: const TextStyle(),
                            ),
                          ],
                        );
                      }

                      return const Center(child: CircularProgressIndicator(color: Colors.black,));
                    },
                  )
                      :
                  Column(
                    children: [
                      // SizedBox(height: 20.0,),
                      //
                      // CircleAvatar(
                      //   radius: 70.0,
                      //   backgroundImage: ResizeImage(
                      //       AssetImage("images/profile.jpg"),
                      //       width: 350,
                      //       height: 350
                      //   ),
                      // ),
                      //
                      // SizedBox(height: 10.0,),

                      Text(
                        "Welcome!",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                          "Please Sign In"
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton.extended(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  UserProfileUpdate()), // Corrected typo in route name
                             );
                            },
                          heroTag: 'Profile Update',
                          elevation: 0,
                          label: const Text("Profile Update"),
                          icon: const Icon(Icons.update),
                        ),

                        const SizedBox(height: 16.0),

                        FloatingActionButton.extended(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UserOrderHistory()),
                            );
                          },
                          heroTag: 'order history',
                          elevation: 0,
                          backgroundColor: Colors.deepOrange.shade400,
                          label: const Text("Order History"),
                          icon: const Icon(Icons.history),
                        ),

                        const SizedBox(height: 16.0),

                        FloatingActionButton.extended(
                          onPressed: () {
                            setState(() {
                              globalUserID = '';
                            });
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Register()),
                                  (Route<dynamic> route) => false,
                            );
                          },
                          heroTag: 'Sign out',
                          elevation: 0,
                          backgroundColor: Colors.red.shade400,
                          label: Text(globalUserID.isNotEmpty ? "Sign out" : "sign in"),
                          icon: Icon(globalUserID.isNotEmpty ? Icons.logout : Icons.login),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        item.value.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ),
    Text(
      item.title,
      style: Theme.of(context).textTheme.caption,
    )
  ],
);

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.deepOrange, Colors.white], // Specify colors as a list
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),


        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person, // Replace with the icon you want to use for the profile
                    size: 50, // Adjust the size of the profile icon as needed
                    color: Colors.white, // Set the color of the profile icon
                  ),
                ),


                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
