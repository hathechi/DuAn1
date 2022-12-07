import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app_fluter/modal/cart.dart';
import 'package:my_app_fluter/modal/receipt.dart';
import 'package:my_app_fluter/screen_page/receipt_screen.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:my_app_fluter/utils/showToast.dart';

Future addReceipt(
    List<Cart> listCart, double tongtien, String sdt, String diachi) async {
  //Đường dẫn
  final CollectionReference _receipt =
      FirebaseFirestore.instance.collection('receipt');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String timeNow = DateFormat('kk:mm:ss').format(DateTime.now());
  String dateNow = DateFormat('dd-MM-yyyy').format(DateTime.now());
  int dateFormat = int.parse(DateFormat('yyyyMMdd').format(DateTime.now()));

  // DateFormat dateFormat = DateFormat("dd/MM/yyyy hh:mm:ss");
  // DateTime dateTime = dateFormat.parse("19/11/2022 04:30:22");
  log(dateFormat.toString());

  String userID = _auth.currentUser!.uid;
  String nameUser = _auth.currentUser!.displayName!;
  final receipt = Receipt(
      mahoadon: timeNow,
      tongtien: tongtien,
      phoneNumber: sdt,
      nguoinhan: nameUser,
      userId: userID,
      address: diachi,
      ngaytaohd: dateNow,
      filterDate: dateFormat,
      listCart: listCart);
  final toMap = receipt.toMap();
  _receipt
      .doc(userID)
      .collection('receipt')
      .doc(timeNow)
      .set(toMap)
      .then((value) {})
      .catchError((error) {
    print("Failed to add user: $error");
  });
}

Future updateReceipt(BuildContext context, Receipt itemReceipt) async {
  //Đường dẫn
  final CollectionReference _receipt =
      FirebaseFirestore.instance.collection('receipt');

  final toMap = itemReceipt.toMap();
  _receipt
      .doc(itemReceipt.userId)
      .collection('receipt')
      .doc(itemReceipt.mahoadon)
      .set(toMap)
      .then((value) {
    showToast('Đơn Hàng Đã Hoàn Thành', Colors.green);
    pop();
    pushReplacement(context, const ReceiptScreen());
  }).catchError((error) {
    print("Failed to add user: $error");
  });
}

// Future updatePDFReceipt(String urlPDF) async {
//   //Đường dẫn
//   final CollectionReference _receipt =
//       FirebaseFirestore.instance.collection('receipt');

//   // final toMap = itemReceipt.toMap();
//   _receipt
//       .doc('3piiGueGR4NHfFxVRBgxD3pEuxp1')
//       .collection('receipt')
//       .doc('01:02:50')
//       .update({"urlPDF": urlPDF}).then((value) {
//     showToast('Update OK', Colors.green);
//   }).catchError((error) {
//     print("Failed to add user: $error");
//   });
// }

Future deleteReceipt(BuildContext context, Receipt itemReceipt) async {
  //Đường dẫn
  final CollectionReference _receipt =
      FirebaseFirestore.instance.collection('receipt');

  // final toMap = itemReceipt.toMap();
  _receipt
      .doc(itemReceipt.userId)
      .collection('receipt')
      .doc(itemReceipt.mahoadon)
      .delete()
      .then((value) {
    showToast('Đơn Hàng Đã Bị Hủy', Colors.red);
    pop();
    pushReplacement(context, const ReceiptScreen());
  }).catchError((error) {
    print("Failed to add user: $error");
  });
}
