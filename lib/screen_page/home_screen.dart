import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'home_page.dart';

class MyClass extends StatefulWidget {
  const MyClass({super.key});

  @override
  State<MyClass> createState() => _MyClassState();
}

class _MyClassState extends State<MyClass> {
  int _curentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _curentIndex,
        children: [
          const PageHome(),
          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.pink,
          ),
          Container(
            color: Colors.green,
          ),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
          currentIndex: _curentIndex,
          onTap: (index) {
            setState(() {
              _curentIndex = index;
            });
          },
          items: [
            SalomonBottomBarItem(
                icon: const Icon(FontAwesomeIcons.house),
                title: const Text('Home'),
                selectedColor: Colors.pinkAccent,
                unselectedColor: const Color.fromARGB(255, 243, 135, 171)),
            SalomonBottomBarItem(
                icon: const Icon(FontAwesomeIcons.cartShopping),
                title: const Text('Cart'),
                selectedColor: Colors.pinkAccent,
                unselectedColor: const Color.fromARGB(255, 243, 135, 171)),
            SalomonBottomBarItem(
                icon: const Icon(FontAwesomeIcons.solidHeart),
                title: const Text('Likes'),
                selectedColor: Colors.pinkAccent,
                unselectedColor: const Color.fromARGB(255, 243, 135, 171)),
            SalomonBottomBarItem(
                icon: const Icon(FontAwesomeIcons.solidUser),
                title: const Text('Profile'),
                selectedColor: Colors.pinkAccent,
                unselectedColor: const Color.fromARGB(255, 243, 135, 171)),
          ]),
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
