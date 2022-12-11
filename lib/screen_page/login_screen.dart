import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app_fluter/screen_page/forgotpassword_screen.dart';
import 'package:my_app_fluter/screen_page/register_screen.dart';
import 'package:my_app_fluter/utils/push_screen.dart';

import '../utils/showToast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _isShow = false;
  bool checkbox = false;
  final _controllerEmail = TextEditingController();
  final _controllerPass = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          log('User is currently signed out!');
        } else {
          log('User is signed in!');
          showLoading(2);
          pushAndRemoveUntil();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: Image.asset("assets/images/logo_login.png")),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Container(
                        child: Text(
                          "Login now to experience",
                          style: GoogleFonts.comfortaa(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 38,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                        child: TextFormField(
                          controller: _controllerEmail,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Không Bỏ Trống Email";
                            }
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return "Nhập Đúng Định Dạng Email";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 245, 245, 245),
                              prefixIcon: Icon(
                                FontAwesomeIcons.user,
                                size: 18,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              labelText: 'EMAIL',
                              labelStyle: TextStyle(fontSize: 12)),
                        )),
                    Container(
                        child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Không Bỏ Trống Mật Khẩu";
                        }
                        if (value.length < 6) {
                          return "Mật Khẩu Phải Hơn 5 Ký Tự";
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _controllerPass,
                      obscureText: _isShow,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 245, 245, 245),
                          prefixIcon: const Icon(
                            FontAwesomeIcons.lock,
                            size: 16,
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                _clickShowPass();
                              },
                              child: _isShow
                                  ? const Icon(
                                      Icons.visibility,
                                    )
                                  : const Icon(
                                      Icons.visibility_off,
                                    )),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          labelText: 'PASSWORD',
                          labelStyle: const TextStyle(fontSize: 12)),
                    )),
                    // Container(
                    //   padding: const EdgeInsets.only(top: 10),
                    //   alignment: Alignment.centerLeft,
                    //   child: CheckboxListTile(
                    //     onChanged: (value) {
                    //       setState(() {
                    //         checkbox = value!;
                    //         print(checkbox);
                    //       });
                    //     },
                    //     value: checkbox,
                    //     title: Text(
                    //       'Remember me',
                    //       style: GoogleFonts.comfortaa(
                    //           fontSize: 16, fontWeight: FontWeight.bold),
                    //     ),
                    //     activeColor: Colors.black,
                    //     controlAffinity: ListTileControlAffinity.leading,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              elevation: 8,
                              shape: (RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(130)))),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              onClickSignIn();
                            }
                          },
                          child: const Text(
                            'SIGN IN',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '------ or continue with ------',
                        style:
                            GoogleFonts.comfortaa(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 80,
                            height: 70,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: const Color.fromARGB(255, 199, 198, 198),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                FontAwesomeIcons.google,
                                size: 40,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 70,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: const Color.fromARGB(255, 199, 198, 198),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                FontAwesomeIcons.facebook,
                                size: 40,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 70,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: const Color.fromARGB(255, 199, 198, 198),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                FontAwesomeIcons.apple,
                                size: 42,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()),
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.comfortaa(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: 'NEW USER? ',
                                    ),
                                    TextSpan(
                                      text: 'SIGN UP',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassWord()),
                                );
                              },
                              child: Text(
                                "FORGOT PASSWORD",
                                style: GoogleFonts.comfortaa(
                                  fontSize: 13,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void _clickShowPass() {
    setState(() {
      _isShow = !_isShow;
    });
  }

  void onClickSignIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPass.text);
    } on FirebaseAuthException catch (e) {
      // showToast(e.code, Colors.red);
      showToast('Sai Tài Khoản Hoặc Mật Khẩu', Colors.red);
    }
  }
}
