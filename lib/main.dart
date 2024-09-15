import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/UserProfile/Profile.dart';
import 'package:restaurant_app/UserProfile/UserProfileUpdate.dart';
import 'package:restaurant_app/admin/AdminPage.dart';
import 'package:restaurant_app/screen/MainPage.dart';
import 'package:restaurant_app/screen/Register.dart';
import 'package:restaurant_app/screen/Cart.dart';
import 'screen/HomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA7PFBZ608Xk9VvPztKfc_ZOzySLcaf_VE",
      appId: "1:968993120539:web:8f4d6f4f8024a557aff3be",
      messagingSenderId: "968993120539",
      projectId: "resturentapp-653b4",
      storageBucket: "gs://resturentapp-653b4.appspot.com"
    )
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Resturent App",
      // home: MainPage(),
      home: Register(),
      // home: AdminPage(),
      // home: UserProfileUpdate()
    );
  }
}