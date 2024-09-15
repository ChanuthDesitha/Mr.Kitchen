import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/admin/AdminPage.dart';
import 'package:restaurant_app/screen/MainPage.dart';

import '../services/firestore.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true; // Variable to toggle password visibility

  void clearFields() {
    _emailController.clear();
    _passwordController.clear();
  }

  String _hashPassword(String password) {
    // Create a SHA-256 hasher
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> validateUser() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.deepOrange.shade50,
          title: const Text('Error!!!'),
          content: const Text('Please enter your user credentials!'),
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
    } else if(_emailController.text == "admin@gmail.com" && _passwordController.text == "admin123") {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AdminPage()),
            (Route<dynamic> route) => false,
      );
    } else {
      final user = await FirebaseFirestore.instance.collection('users').doc(_emailController.text).get();

      final userDetails = user.data();

      final hashedPassword = _hashPassword(_passwordController.text);

      if (user.exists && userDetails?['password'] == hashedPassword) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainPage()),
              (Route<dynamic> route) => false,
        );

        globalUserID = userDetails?['email'];

        clearFields();
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.deepOrange.shade50,
            title: const Text('Error!!!'),
            content: const Text('Invalid email or password!'),
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(),

      body: Container(
        margin: const EdgeInsets.only(top: 100.0),
        padding: const EdgeInsets.all(20.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Sign in',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(top: 100.0),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                        ),
                      ),

                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscure,
                        // Use _isObscure to toggle password visibility
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepOrange),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),

                          suffixIcon: IconButton(
                            icon: Icon(_isObscure ? Icons.visibility : Icons
                                .visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure =
                                !_isObscure; // Toggle password visibility
                              });
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 25.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: validateUser,

                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
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
      ),
    );
  }
}
