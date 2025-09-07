import 'package:ecommerce/Views/pages/account_page.dart';
import 'package:ecommerce/Views/pages/cart_page.dart';
import 'package:ecommerce/Views/pages/home_page.dart';
import 'package:ecommerce/Views/pages/wishlist_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class ButtomNavBar extends StatefulWidget {
  const ButtomNavBar({super.key});

  @override
  State<ButtomNavBar> createState() => _ButtomNavBarState();
}

class _ButtomNavBarState extends State<ButtomNavBar> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: HomePage(),
          item: ItemConfig(
            icon: Icon(CupertinoIcons.home),
            title: "Home",
            activeForegroundColor: Color(0xffff6b6b),
          ),
        ),
        PersistentTabConfig(
          screen: WishlistPage(),
          item: ItemConfig(
            icon: Icon(CupertinoIcons.heart),
            title: "WishList",
            activeForegroundColor: Color(0xffff6b6b),
          ),
        ),
        PersistentTabConfig(
          screen: CartPage(),
          item: ItemConfig(
            icon: Icon(CupertinoIcons.cart),
            title: "My Cart",
            activeForegroundColor: Color(0xffff6b6b),
          ),
        ),
        PersistentTabConfig(
          screen: AccountPage(),
          item: ItemConfig(
            icon: Icon(CupertinoIcons.person),
            title: "Account",
            activeForegroundColor: Color(0xffff6b6b),
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style9BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
      ),
    );
  }
}
