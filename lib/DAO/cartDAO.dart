import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app_fluter/modal/cart.dart';
import 'package:my_app_fluter/modal/product.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:my_app_fluter/utils/showToast.dart';

void addCart(Product product, String size, String color, double tongtien,
    int soluong) async {
  //Đường dẫn
  final CollectionReference _cart =
      FirebaseFirestore.instance.collection('cart');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String timeNow = DateFormat('kk:mm:ss').format(DateTime.now());
  log(timeNow);
  // ignore: await_only_futures
  String userID = await _auth.currentUser!.uid;
  log(userID);
  final cart = Cart(
      idsanpham: product.masp,
      tensp: product.tensp,
      kichcosp: size,
      mausp: color,
      giasp: product.giasp,
      tongtien: tongtien,
      slsp: soluong,
      urlImage: product.urlImage,
      thuonghieusp: product.thuonghieusp);
  final cartToJson = cart.toMap();
  // log('JSON' + cartToJson);
  _cart
      .doc(userID)
      .collection('cart')
      .doc("${product.masp}")
      .set(cartToJson)
      .then((value) {
    showToast('Thêm Vào Giỏ Hàng Thành Công', Colors.green);
    pop();
  }).catchError((error) {
    print("Failed to add user: $error");
  });
}

void updateCart(Cart cart) async {
  //Đường dẫn
  final CollectionReference _cart =
      FirebaseFirestore.instance.collection('cart');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // String timeNow = DateFormat('kk:mm:ss').format(DateTime.now());
  // log(timeNow);
  // ignore: await_only_futures
  String userID = await _auth.currentUser!.uid;
  log(userID);
  // final cart = Cart(
  //     tongtien: tongtien,
  //     slsp: soluong,
  //    );
  final cartToJson = cart.toMap();
  // log('JSON' + cartToJson);
  _cart
      .doc(userID)
      .collection('cart')
      .doc(cart.idsanpham)
      .set(cartToJson)
      .then((value) {
    print('update thanh cong');
  }).catchError((error) {
    print("Failed to add user: $error");
  });
}

void deleteCart(Cart cart) async {
  //Đường dẫn
  final CollectionReference _cart =
      FirebaseFirestore.instance.collection('cart');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userID = await _auth.currentUser!.uid;

  _cart
      .doc(userID)
      .collection('cart')
      .doc(cart.idsanpham)
      .delete()
      .then((value) {
    showToast('Xóa Thành Công', Colors.green);
    pop();
  }).catchError((error) {
    print("Failed to add user: $error");
  });
}
