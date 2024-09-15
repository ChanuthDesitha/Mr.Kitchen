import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/screen/SignIn.dart';

import '../services/firestore.dart';

class UserProfileUpdate extends StatefulWidget {
  const UserProfileUpdate({Key? key}) : super(key: key);

  @override
  State<UserProfileUpdate> createState() => _UserProfileUpdateState();
}

class _UserProfileUpdateState extends State<UserProfileUpdate> {
  final _fireStoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').doc(globalUserID).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            final userDetails = snapshot.data!.data();
            final username = userDetails!['username'];
            final email = userDetails['email'];
            final mobileNo = userDetails['mobileNo'];
            final address = userDetails['address'];

            late final _usernameController = TextEditingController()..text = username;
            late final _emailController = TextEditingController()..text = email;
            late final _mobileNoController = TextEditingController()..text = mobileNo;
            late final _addressController = TextEditingController()..text = address;

            final _formKey = GlobalKey<FormState>(); // Form Key


            Future<void> updateUser() async {
              if (_formKey.currentState?.validate() ?? false) {
                _fireStoreService.updateUser(
                    _usernameController.text,
                    _emailController.text,
                    _mobileNoController.text,
                    _addressController.text
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('User Updated successfully!'),
                  ),
                );

                Navigator.pop(context);
              }
            }

            return Container(
              margin: const EdgeInsets.only(top: 50.0),
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Profile Update',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(top: 50.0), // Add margin here
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.deepOrange),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                errorStyle: const TextStyle(color: Colors.red),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a username';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),
                            TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.deepOrange),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  errorStyle: const TextStyle(color: Colors.red),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an email';
                                  }
                                  // Add email validation logic
                                  if (!RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                }
                            ),

                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _mobileNoController,
                              decoration: InputDecoration(
                                labelText: 'Mobile No',
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.deepOrange),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                errorStyle: const TextStyle(color: Colors.red),
                                suffixIcon: Icon(Icons.phone),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a mobile no';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                labelText: 'Address',
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.deepOrange),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                errorStyle: const TextStyle(color: Colors.red),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an address';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 50),
                            ElevatedButton(
                              onPressed: () => updateUser(),
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange.shade400,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator(color: Colors.black,),);
          }
        },
      )
    );
  }
}