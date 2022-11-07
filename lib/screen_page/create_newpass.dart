import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/screen_page/login_screen.dart';

class CreateNewPass extends StatefulWidget {
  const CreateNewPass({super.key});

  @override
  State<CreateNewPass> createState() => _CreateNewPassState();
}

class _CreateNewPassState extends State<CreateNewPass> {
  final _formKey = GlobalKey<FormState>();
  final _controllerPassFogot = TextEditingController();
  final _controllerCFPassFogot = TextEditingController();
  bool _isShow = false;
  bool _isVisibility = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: const Text(
            'Create New PassWord',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset('assets/images/createnewpass.png'),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: const Text(
                          'Create Your New Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
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
                        controller: _controllerPassFogot,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            labelText: 'PASSWORD',
                            labelStyle: const TextStyle(fontSize: 12)),
                      )),
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Không Bỏ Trống Xác Nhận Mật Khẩu";
                              }
                              if (value.length < 6) {
                                return "Xác Nhận Mật Khẩu Phải Hơn 6 Ký Tự";
                              }
                              if (value != _controllerPassFogot.text) {
                                return "Hai Mật Khẩu Phải Giống Nhau";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _controllerCFPassFogot,
                            obscureText: _isShow,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 245, 245, 245),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                labelText: 'COMFIRM PASSWORD',
                                labelStyle: const TextStyle(fontSize: 12)),
                          )),
                      Visibility(
                        visible: !_isVisibility,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 60, 0, 30),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  elevation: 8,
                                  shape: (RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(130)))),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  showSnackBar('Lấy Lại Mật Khẩu Thành Công');
                                  setState(() {
                                    _isVisibility = !_isVisibility;
                                  });
                                }
                              },
                              child: const Text(
                                'CONTINUE',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _isVisibility,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 60, 0, 30),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  elevation: 8,
                                  shape: (RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(130)))),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()));
                              },
                              child: const Text(
                                'SIGN IN',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBar(String message) {
    var snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Thành Công !',
        message: message,
        contentType: ContentType.success,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _clickShowPass() {
    setState(() {
      _isShow = !_isShow;
    });
  }
}
