import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app_fluter/screen_page/home_screen.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:my_app_fluter/utils/showToast.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _controllerName = TextEditingController();
  //Lấy hình từ thư viện máy
  File? image;

  Future getImage() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 10);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('false');
    }
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
    super.initState();
    _controllerName.text = getNameUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        // alignment: Alignment.center,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _avatar(),
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
                        : getAvatar(),
                  ),
                ),
                const Positioned(
                  bottom: 10,
                  right: 10,
                  child: Icon(FontAwesomeIcons.camera),
                ),
              ],
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
            Form(
              key: navKey1,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: TextFormField(
                  controller: _controllerName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Không Bỏ Trống ";
                    }
                    if (!RegExp(
                            r'^[0-9A-Za-zÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚÝàáâãèéêìíòóôõùúýĂăĐđĨĩŨũƠơƯưẠ-ỹ ]+$')
                        .hasMatch(value)) {
                      return "Tên Không Chứa Ký Tự Đặc Biệt ";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 240, 240, 240),
                      prefixIcon: Icon(
                        FontAwesomeIcons.tags,
                        size: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      labelText: 'NAME',
                      labelStyle: TextStyle(fontSize: 12)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      elevation: 8,
                      shape: (RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(130)))),
                  onPressed: () {
                    if (navKey1.currentState!.validate()) {
                      if (_controllerName.text == 'admin') {
                        showToast('Tên Này Đã Được Sử Dụng', Colors.red);
                        return;
                      }
                      editProfile();
                    }
                  },
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void editProfile() async {
    if (_auth.currentUser != null) {
      String? urlImage;
      if (image == null) {
        try {
          hideKeyboard();
          showLoading(2);
          urlImage = _auth.currentUser!.photoURL!;
          await _auth.currentUser!.updateDisplayName(_controllerName.text);
          await _auth.currentUser!.updatePhotoURL(urlImage);
          showToast('Sửa Thông Tin Thành Công', Colors.green);
          profileUpdateChanged.sink.add(true);
          pop();
        } on FirebaseAuthException catch (e) {
          if (e.message == null) return;
          log(e.message!);
          showToast(e.message!, Colors.red);
        }
      } else {
        hideKeyboard();
        showLoading(4);
        String timeNow = DateFormat('kk:mm:ss').format(DateTime.now());
        final ref = FirebaseStorage.instance
            .ref()
            .child("images")
            .child(timeNow + '.jpg');
        await ref.putFile(image!);
        urlImage = await ref.getDownloadURL();
        try {
          await _auth.currentUser!.updateDisplayName(_controllerName.text);
          await _auth.currentUser!.updatePhotoURL(urlImage);

          showToast('Sửa Thông Tin Thành Công', Colors.green);
        } on FirebaseAuthException catch (e) {
          if (e.message == null) return;
          log(e.message!);
          showToast(e.message!, Colors.red);
        }
      }
    }
  }
}
