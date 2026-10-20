import 'package:evetick/core/di/dependency_injection.dart';
import 'package:evetick/core/services/push_notifications/push_notifications_service.dart';
import 'package:evetick/features/animated_navbar/animated_navbar.dart';
import 'package:evetick/features/animated_navbar/navbar_item.dart';
import 'package:evetick/features/favorites/logic/favorites_cubit.dart';
import 'package:evetick/features/favorites/ui/screens/favorites_screen.dart';
import 'package:evetick/features/home/logic/home_cubit.dart';
import 'package:evetick/features/home/ui/screens/home_screen.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_cubit.dart';
import 'package:evetick/features/my_tickets/ui/screens/my_tickets_screen.dart';
import 'package:evetick/features/profile/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  static const int _homeTabIndex = 0;
  static const int _favoritesTabIndex = 1;
  static const int _ticketsTabIndex = 2;

  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    FavoritesScreen(),
    MyTicketsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<PushNotificationsService>().onHomeReady();
    });
  }

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
          switch (index) {
            case _homeTabIndex:
              context.read<HomeCubit>().load(silent: true);
            case _favoritesTabIndex:
              context.read<FavoritesCubit>().load(silent: true);
            case _ticketsTabIndex:
              context.read<MyTicketsCubit>().load(silent: true);
          }
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
