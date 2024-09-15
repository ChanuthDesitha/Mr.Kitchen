import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:restaurant_app/UserProfile/Profile.dart';
import 'package:restaurant_app/screen/Cart.dart';
import 'package:restaurant_app/screen/HomePage.dart';
import 'package:restaurant_app/screen/Settings.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var pageController = PageController();

  late List<Widget> _pages = [
    HomePage(),
    Cart(),
    Profile(),
    Settings()
  ];

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;

    return Scaffold(
      body: PageView(
        children: _pages,
        onPageChanged: (i) {
          setState(() {
            _selectedIndex = i;
          });
        },
        controller: pageController,
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
          color: Colors.orangeAccent.shade200,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: GNav(
            backgroundColor: Colors.orangeAccent.shade200,
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.deepOrange[400],
            iconSize: 28,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[200]!,
            color: Colors.black,

            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.shopping_cart_outlined,
                text: 'Cart',
              ),
              GButton(
                icon: Icons.person_outline,
                text: 'Profile',
              ),
              GButton(
                icon: Icons.settings_outlined,
                text: 'Settings',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (i) {
              setState(() {
                _selectedIndex = i;
                pageController.animateToPage(
                    _selectedIndex,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear
                );
              });
            },
          ),
        ),
      ),

    );
  }
}
