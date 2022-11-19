import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:my_app_fluter/modal/product.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:my_app_fluter/utils/showToast.dart';

//Push Data lên FireBase
void pustDataFireStore(File image, double gia, String chitiet,
    String thuonghieu, int slnhap, String name) async {
  //Đường dẫn
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('product');
  String urlImage = '';
  String dateTime = DateFormat('dd-MM-yyyy - kk:mm:ss').format(DateTime.now());
  final ref =
      FirebaseStorage.instance.ref().child("images").child(dateTime + '.png');
  await ref.putFile(image);
  urlImage = await ref.getDownloadURL();
  print(urlImage);

  final product = Product(
      tensp: name,
      giasp: gia,
      chitietsp: chitiet,
      thuonghieusp: thuonghieu,
      urlImage: urlImage,
      slnhap: slnhap,
      masp: dateTime);
  final toJson = product.toJson();
  print(toJson);
  _products.doc(dateTime).set(toJson).then((value) {
    showToast('Thêm Thành Công', Colors.green);
    pop();
    // loadingGIF();
  }).catchError((error) {
    print("Failed to add user: $error");
    // loadingGIF();
  });
}

//Push Data lên FireBase
void updateDataFireStoreImage(File image, double gia, String chitiet,
    String thuonghieu, int slnhap, String name, String masp) async {
  //Đường dẫn
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('product');
  String urlImage = '';
  String dateTime = DateFormat('dd-MM-yyyy - kk:mm:ss').format(DateTime.now());

//Up hình lên Storage
  final ref =
      FirebaseStorage.instance.ref().child("images").child(dateTime + '.png');
  await ref.putFile(image);
  urlImage = await ref.getDownloadURL();
  print(urlImage);
  final product = Product(
      tensp: name,
      giasp: gia,
      chitietsp: chitiet,
      thuonghieusp: thuonghieu,
      urlImage: urlImage,
      slnhap: slnhap,
      masp: masp);
  final toJson = product.toJson();
  print(toJson);
  await _products.doc(masp).update(toJson).then((value) {
    showToast('Sửa Thành Công', Colors.green);
    pop();
  }).catchError((error) => print("Failed to add user: $error"));
  // pop();
}

void updateDataFireStoreUrl(String? linkUrl, double gia, String chitiet,
    String thuonghieu, int slnhap, String name, String masp) async {
  //Đường dẫn
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('product');

  // String dateTime = DateFormat('dd-MM-yyyy - kk:mm:ss').format(DateTime.now());

  final product = Product(
      tensp: name,
      giasp: gia,
      chitietsp: chitiet,
      thuonghieusp: thuonghieu,
      urlImage: linkUrl,
      slnhap: slnhap,
      masp: masp);
  final toJson = product.toJson();
  print(toJson);
  await _products.doc(masp).update(toJson).then((value) {
    showToast('Sửa Thành Công', Colors.green);
    pop();
  }).catchError((error) => print("Failed to add user: $error"));
  // pop();
}

void updateLikesDataFireStore(Product product) async {
//Đường dẫn
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('product');
  final toJson = product.toJson();
  await _products
      .doc(product.masp)
      .update(toJson)
      .then((value) {})
      .catchError((error) => print("Failed to add user: $error"));
}

//Delete Data lên FireBase
void deleteDataFireStore(String name) async {
  //Đường dẫn
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('product');

  _products.doc(name).delete().then((value) {
    showToast('Xóa Thành Công', Colors.green);
    pop();
  }).catchError((error) => print("Failed to delele product: $error"));
}

Future<bool> isCheckExist(String tensp) async {
  bool check = false;
  var document = await FirebaseFirestore.instance
      .collection("product")
      .where('tensp', isEqualTo: tensp)
      .get();
  if (document.size > 0) {
    var results = document.docs;
    for (int i = 0; i < results.length; i++) {
      if (results[i].exists) {
        check = !check;
        break;
      }
    }
  }
  return check;
}
