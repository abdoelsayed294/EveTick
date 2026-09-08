import 'package:evetick/features/animated_navbar/animated_navbar.dart';
import 'package:evetick/features/animated_navbar/navbar_item.dart';
import 'package:evetick/features/home/home_screen.dart';
import 'package:evetick/features/profile/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    Center(child: Text('Favorites Screen')),
    Center(child: Text('Tickets Screen')),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AnimatedSpotlightNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
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
    );
  }
}
