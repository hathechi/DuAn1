import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'home_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  bool _isShow = false;
  final _controllerUser = TextEditingController();
  final _controllerPass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        body: Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Container(
                          width: 70,
                          height: 70,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 232, 229, 230)),
                          child: const FlutterLogo()),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                      child: Container(
                        child: const Text(
                          "HELLO\nWELCOME BACK !",
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            color: Colors.black,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                        child: TextFormField(
                          controller: _controllerUser,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Không Bỏ Trống Tài Khoản";
                            }
                            if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                              return "Tên Không Chứa Ký Tự Đặc Biệt Hoặc Số";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              labelText: 'USERNAME',
                              labelStyle: TextStyle(fontSize: 14)),
                        )),
                    Container(
                        child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Không Bỏ Trống Mật Khẩu";
                        }
                        if (value.length < 6) {
                          return "Mật Khẩu Phải Hơn 6 Ký Tự";
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _controllerPass,
                      obscureText: _isShow,
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                _clickShowPass();
                              },
                              child: _isShow
                                  ? Icon(
                                      Icons.visibility,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                    )),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: 'PASSWORD',
                          labelStyle: const TextStyle(fontSize: 14)),
                    )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 30),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(130)))),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text(
                              "NEW USER? SIGN UP ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "FORGOT PASSWORD",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            )
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

  void onClickSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyClass()),
    );
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: "This is Center Short Toast",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
