import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:yog4life/screens/feedscreen.dart';
import '../screens/chatscreen.dart';
import '../screens/profilescreen.dart';

class NavbarScreen extends StatelessWidget {
  static const routeName = '/navbarhome';
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [FeedScreen(), ChatScreen(), ProfileScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        activeColorPrimary: Colors.amber.shade300,
        activeColorSecondary: Colors.black,
        icon: const Icon(
          Icons.home,
          color: Color(0xffE40303),
        ),
        title: ("Home"),
      ),
      PersistentBottomNavBarItem(
        activeColorPrimary: Colors.amber.shade300,
        activeColorSecondary: Colors.black,
        icon: const Icon(
          Icons.chat,
          color: Color(0xffFF8C00),
        ),
        title: ("Chat"),
      ),
      PersistentBottomNavBarItem(
        activeColorPrimary: Colors.amber.shade300,
        activeColorSecondary: Colors.black,
        icon: const Icon(
          Icons.account_circle_rounded,
          color: Color(0xff008026),
        ),
        title: ("Profile"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}
