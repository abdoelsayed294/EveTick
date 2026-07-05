import 'package:evetick/features/animated_navbar/animated_navbar.dart';
import 'package:evetick/features/animated_navbar/navbar_item.dart';
import 'package:flutter/material.dart';

class TestNav extends StatefulWidget {
  const TestNav({super.key});

  @override
  State<TestNav> createState() => _TestNavState();
}

class _TestNavState extends State<TestNav> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SizedBox(),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedSpotlightNavbar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: const [
            AnimatedNavbarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
            ),
            AnimatedNavbarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
            ),
            AnimatedNavbarItem(
              icon: Icon(Icons.confirmation_number_outlined),
              activeIcon: Icon(Icons.confirmation_number),
            ),
            AnimatedNavbarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}