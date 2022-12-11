import 'dart:async';
import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/modal/cart.dart';
import 'package:my_app_fluter/screen_page/cart_page.dart';
import 'package:my_app_fluter/screen_page/likes_page.dart';
import 'package:my_app_fluter/screen_page/profile_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'home_page.dart';

final profileUpdateChanged = StreamController<bool>.broadcast();

class HomeScreen extends StatefulWidget {
  int? currentPageIndex;

  HomeScreen({super.key, this.currentPageIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Đường dẫn
  final CollectionReference _receipt =
      FirebaseFirestore.instance.collection('cart');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Cart> listCart = [];
  final _pageController = PageController();
  final _currentPage = ValueNotifier<int>(0);
  @override
  void initState() {
    super.initState();
    if (_auth.currentUser != null) {
      countCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const BouncingScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          _currentPage.value = index;
        },
        children: [
          PageHome(pageController: _pageController),
          const CartPage(fromToDetail: false),
          const LikesPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: _currentPage,
          builder: (context, value, child) {
            return SalomonBottomBar(
                currentIndex: value,
                onTap: (index) {
                  _pageController.jumpToPage(index);
                },
                items: [
                  SalomonBottomBarItem(
                      icon: const Icon(FontAwesomeIcons.house),
                      title: const Text('Home'),
                      selectedColor: Colors.pinkAccent,
                      unselectedColor:
                          const Color.fromARGB(255, 243, 135, 171)),
                  listCart.isEmpty
                      ? SalomonBottomBarItem(
                          icon: const Icon(FontAwesomeIcons.cartShopping),
                          title: const Text('Cart'),
                          selectedColor: Colors.pinkAccent,
                          unselectedColor:
                              const Color.fromARGB(255, 243, 135, 171))
                      : SalomonBottomBarItem(
                          icon: Badge(
                            padding: const EdgeInsets.all(6),
                            position: BadgePosition.topEnd(top: -18, end: -18),
                            badgeContent: Text(
                              listCart.length.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            badgeColor: Colors.black,
                            child: const Icon(FontAwesomeIcons.cartShopping),
                          ),
                          title: const Text('Cart'),
                          selectedColor: Colors.pinkAccent,
                          unselectedColor:
                              const Color.fromARGB(255, 243, 135, 171)),
                  SalomonBottomBarItem(
                      icon: const Icon(FontAwesomeIcons.solidHeart),
                      title: const Text('Likes'),
                      selectedColor: Colors.pinkAccent,
                      unselectedColor:
                          const Color.fromARGB(255, 243, 135, 171)),
                  SalomonBottomBarItem(
                      icon: const Icon(FontAwesomeIcons.solidUser),
                      title: const Text('Profile'),
                      selectedColor: Colors.pinkAccent,
                      unselectedColor:
                          const Color.fromARGB(255, 243, 135, 171)),
                ]);
          }),
    );
  }

  void countCart() {
    // log(_auth.currentUser!.uid);
    _receipt
        .doc(_auth.currentUser!.uid)
        .collection('cart')
        .snapshots()
        .listen((data) {
      listCart.clear();
      for (int i = 0; i < data.docs.length; i++) {
        var item = Cart.fromMap(data.docs[i].data());
        listCart.add(item);
      }
      log(listCart.length.toString());
    });
  }
}
