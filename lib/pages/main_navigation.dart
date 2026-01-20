import 'package:flutter/material.dart';
import 'package:dyota/components/bottom_navigation_bar_component.dart';
import 'package:dyota/pages/Home/home_page.dart';
import 'package:dyota/pages/Cart/cart.dart';
import 'package:dyota/pages/Profile/profile_page.dart';

/// Main navigation wrapper that handles bottom navigation bar
/// using IndexedStack for instant tab switching without animations
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({Key? key}) : super(key: key);

  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  
  // All pages are created once and kept in memory
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const Cart(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}