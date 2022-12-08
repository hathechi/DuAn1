import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/DAO/cartDAO.dart';
import 'package:my_app_fluter/DAO/receiptDAO.dart';
import 'package:my_app_fluter/PDF/print_pdf.dart';
import 'package:my_app_fluter/modal/cart.dart';
import 'package:my_app_fluter/notification/notification.dart';
import 'package:my_app_fluter/screen_page/home_screen.dart';
import 'package:my_app_fluter/screen_page/receipt_screen.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:my_app_fluter/utils/showToast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterPin extends StatefulWidget {
  List<Cart> listCart = [];
  double tongtien;
  String address;
  String phoneNumber;
  String phantramgiam;
  EnterPin(
      {super.key,
      required this.listCart,
      required this.tongtien,
      required this.address,
      required this.phoneNumber,
      required this.phantramgiam});

  @override
  State<EnterPin> createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {
  // late final FlutterLocalNotificationsPlugin service;
  final pinController = TextEditingController();
  @override
  void initState() {
    PushNotification.intialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Enter Pin',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Image.asset('assets/images/forgotpass.png'),
              const Text('Enter your PIN to comfirm to payment'),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                child: PinCodeTextField(
                  length: 4,
                  obscuringWidget: const Icon(
                    FontAwesomeIcons.faceAngry,
                    size: 30,
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  textStyle: const TextStyle(fontSize: 30),
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(20),
                      fieldHeight: 60,
                      fieldWidth: 80,
                      borderWidth: 1,
                      activeColor: Colors.black,
                      inactiveColor: const Color.fromARGB(255, 216, 215, 215),
                      inactiveFillColor: Colors.black,
                      selectedColor: Colors.white,
                      activeFillColor: Colors.white,
                      disabledColor: Colors.red,
                      selectedFillColor: Colors.black),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.white,
                  enableActiveFill: true,
                  // errorAnimationController: errorController,
                  controller: pinController,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      // currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                  appContext: context,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          elevation: 8,
                          shape: (RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(130)))),
                      onPressed: () async {
                        if (pinController.text.length < 4) {
                          showToast('PIN code isEmpty', Colors.red);
                          return;
                        }
                        await addReceipt(
                            widget.listCart,
                            widget.tongtien,
                            widget.phoneNumber,
                            widget.address,
                            widget.phantramgiam);

                        deleteAllCart(widget.listCart);
                        await PushNotification.showNotification(
                            id: 1,
                            body:
                                'Bạn Đã Thanh Toán \$${widget.tongtien.toStringAsFixed(2)} Thành Công, Hãy Kiểm Tra Lại Hóa Đơn Nhé',
                            title: 'Thanh Toán Thành Công !');
                        showAlertDialog();
                      },
                      label: const Text(
                        'Continue',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      icon: const Icon(
                        FontAwesomeIcons.chevronRight,
                        size: 18,
                      ),
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

  showAlertDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 80,
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 100,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Orther successful!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'You have succsessfuly make orther ',
                style: TextStyle(fontSize: 14),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        elevation: 8,
                        shape: (RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(130),
                        )),
                      ),
                      onPressed: () {
                        pushScreen(context, const ReceiptScreen());
                      },
                      child: const Text(
                        'View Order',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 235, 235, 235),
                          elevation: 8,
                          shape: (RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(130)))),
                      onPressed: () {
                        pushAndRemoveUntil(child: HomeScreen());
                      },
                      child: const Text(
                        'Home',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
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
}
