import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/screen_page/add_brand.dart';
import 'package:my_app_fluter/screen_page/add_product.dart';
import 'package:my_app_fluter/screen_page/edit_profile_screen.dart';
import 'package:my_app_fluter/screen_page/login_screen.dart';
import 'package:my_app_fluter/screen_page/receipt_screen.dart';
import 'package:my_app_fluter/screen_page/statistic_page.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:my_app_fluter/utils/show_bottom_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  List<_ItemMenu> listMenu = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool ischeckLogin() {
    if (_auth.currentUser == null) {
      return false;
    }
    return true;
  }

  String getNameUser() {
    if (_auth.currentUser?.displayName == null) {
      return 'Guest';
    }
    return _auth.currentUser!.displayName!;
  }

  Widget getAvatar() {
    if (_auth.currentUser?.photoURL == null) {
      return Image.asset(
        'assets/images/avatar.jpg',
        fit: BoxFit.cover,
      );
    }
    return Image.network(
      _auth.currentUser!.photoURL!,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }

  @override
  void initState() {
    _createMenu();
    super.initState();
  }

  void _createMenu() {
    if (ischeckLogin() &&
        _auth.currentUser!.email == 'thechi1832000@gmail.com') {
      listMenu.add(_ItemMenu(
        const Icon(FontAwesomeIcons.gears),
        'Product Management ',
        onTap: () {
          pushScreen(context, const AddProduct());
        },
      ));
      listMenu.add(_ItemMenu(
        const Icon(FontAwesomeIcons.gears),
        'Brand Management ',
        onTap: () {
          pushScreen(context, const AddBrand());
        },
      ));
      listMenu.add(_ItemMenu(
        const Icon(FontAwesomeIcons.userPen),
        'Edit Profile',
        onTap: () {
          pushScreen(
            context,
            const EditProfile(),
          );
        },
      ));
      listMenu.add(_ItemMenu(
        const Icon(FontAwesomeIcons.chartLine),
        'Sales Statistics',
        onTap: () {
          pushScreen(
            context,
            const StatisticScreen(),
          );
        },
      ));
      listMenu.add(
        _ItemMenu(
          const Icon(FontAwesomeIcons.windowRestore),
          'Receipt',
          onTap: () {
            pushScreen(
              context,
              const ReceiptScreen(),
            );
          },
        ),
      );
    } else {
      listMenu.add(_ItemMenu(
        const Icon(FontAwesomeIcons.userPen),
        'Edit Profile',
        onTap: () {
          pushScreen(
            context,
            const EditProfile(),
          );
        },
      ));
      listMenu.add(
        _ItemMenu(
          const Icon(FontAwesomeIcons.windowRestore),
          'Receipt',
          onTap: () {
            pushScreen(
              context,
              const ReceiptScreen(),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              FontAwesomeIcons.ellipsis,
              color: Colors.black,
            ),
          ),
        ],
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _avatar(),
              const SizedBox(
                height: 40,
              ),
              //ListView Menu
              _buildMenu(),
              InkWell(
                onTap: () {
                  dialogModalBottomsheet(context, 'Logout', () async {
                    if (_auth.currentUser != null) {
                      await _auth.signOut();
                      pushAndRemoveUntil(child: const Login());
                    } else {
                      pushAndRemoveUntil(child: const Login());
                    }
                  });
                },
                child: Visibility(
                  visible: ischeckLogin(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 238, 238, 238),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: [
                        Row(
                          children: const [
                            Icon(
                              FontAwesomeIcons.rightFromBracket,
                              color: Colors.red,
                            ),
                            SizedBox(width: 24),
                            Text(
                              'Logout',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  dialogModalBottomsheet(context, 'Login', () async {
                    if (_auth.currentUser != null) {
                      await _auth.signOut();
                      pushReplacement(context, const Login());
                    } else {
                      pushAndRemoveUntil(child: const Login());
                    }
                  });
                },
                child: Visibility(
                  visible: !ischeckLogin(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 238, 238, 238),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: [
                        Row(
                          children: const [
                            Icon(
                              FontAwesomeIcons.rightFromBracket,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 24),
                            Text(
                              'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatar() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: (70),
            backgroundColor: const Color.fromARGB(255, 222, 222, 222),
            child: ClipRRect(
              borderRadius:
                  const BorderRadiusDirectional.all(Radius.circular(100)),
              child: getAvatar(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              getNameUser(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: listMenu.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (BuildContext context, int index) {
        var item = listMenu[index];
        return InkWell(
          onTap: () {
            if (item.onTap != null) {
              item.onTap!();
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 238, 238, 238),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      item.icon,
                      const SizedBox(width: 24),
                      Text(
                        item.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ItemMenu {
  final Widget icon;
  final String title;
  final Function? onTap;

  _ItemMenu(this.icon, this.title, {this.onTap});
}
