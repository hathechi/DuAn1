import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/screen_page/cart_page.dart';
import 'package:my_app_fluter/screen_page/home_page_test.dart';
import 'package:my_app_fluter/screen_page/likes_page.dart';
import 'package:my_app_fluter/screen_page/profile_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'home_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  final _currentPage = ValueNotifier<int>(0);
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
                  SalomonBottomBarItem(
                      icon: const Icon(FontAwesomeIcons.cartShopping),
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

  void showToast(var content) {
    Fluttertoast.showToast(
        msg: content,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void showSnackBar() {
    var snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Thành Công !',
        message: 'Thêm Sản Phẩm Thành Công ',
        contentType: ContentType.success,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
