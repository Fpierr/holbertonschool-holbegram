import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/screens/pages/feed.dart';
import 'package:holbegram/screens/pages/search.dart';
import 'package:holbegram/screens/pages/add_image.dart';
import 'package:holbegram/screens/pages/favorite.dart';
import 'package:holbegram/screens/pages/profile_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: const [
          Feed(),
          Search(),
          AddImage(),
          Favorite(),
          Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: [
          _buildNavItem(Icons.home, "Home"),
          _buildNavItem(Icons.search, "Search"),
          _buildNavItem(Icons.add_a_photo, "Add"),
          _buildNavItem(Icons.favorite, "Favorite"),
          _buildNavItem(Icons.person, "Profile"),
        ],
      ),
    );
  }

  BottomNavyBarItem _buildNavItem(IconData icon, String title) {
    return BottomNavyBarItem(
      icon: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(fontSize: 25, fontFamily: 'Billabong'),
      ),
      activeColor: Colors.red,
      inactiveColor: Colors.black,
      textAlign: TextAlign.center,
    );
  }
}
