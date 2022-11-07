import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_app_fluter/screen_page/add_brand.dart';
import 'package:my_app_fluter/screen_page/add_product.dart';
import 'package:my_app_fluter/screen_page/login_screen.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:my_app_fluter/utils/show_bottom_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //Lấy hình từ thư viện máy
  File? image;
  List<_ItemMenu> listMenu = [];

  @override
  void initState() {
    _createMenu();
    super.initState();
  }

  void _createMenu() {
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
      const Icon(FontAwesomeIcons.chartLine),
      'Sales Statistics',
      onTap: () {},
    ));
    listMenu.add(
      _ItemMenu(
        const Icon(FontAwesomeIcons.windowRestore),
        'Receipt',
        onTap: () {},
      ),
    );
  }

  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('false');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  dialogModalBottomsheet(context, 'Logout',
                      () => pushReplacement(context, const Login()));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatar() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () {
          getImage();
        },
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: (70),
                  backgroundColor: const Color.fromARGB(255, 222, 222, 222),
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadiusDirectional.all(Radius.circular(100)),
                    child: image != null
                        ? Image.file(
                            image!,
                            fit: BoxFit.cover,
                            height: 200,
                            width: 200,
                          )
                        : Image.asset(
                            "assets/images/khi.png",
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const Positioned(
                  bottom: 10,
                  right: 10,
                  child: Icon(FontAwesomeIcons.camera),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Andrew Ainsley',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.wavy),
              ),
            )
          ],
        ),
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
}

class _ItemMenu {
  final Widget icon;
  final String title;
  final Function? onTap;

  _ItemMenu(this.icon, this.title, {this.onTap});
}
