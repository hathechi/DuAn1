import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:my_app_fluter/modal/brand.dart';
import 'package:my_app_fluter/modal/product.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:my_app_fluter/utils/showToast.dart';

//Push Data lên FireBase
void pustDataBrandFireStore(File image, String tenthuonghieu) async {
  //Đường dẫn
  final CollectionReference _brands =
      FirebaseFirestore.instance.collection('brand');
  String urlImage = '';
  String timeNow = DateFormat('kk:mm:ss').format(DateTime.now());

  final ref =
      FirebaseStorage.instance.ref().child("images").child(timeNow + '.png');
  await ref.putFile(image);
  urlImage = await ref.getDownloadURL();
  print(urlImage);

  final brand = Brand(
      tenthuonghieu: tenthuonghieu, urlImage: urlImage, idthuonghieu: timeNow);
  final toJson = brand.toJson();
  print(toJson);
  _brands.doc(timeNow).set(toJson).then((value) {
    showToast('Thêm Thương Hiệu Thành Công', Colors.green);
    pop();
  }).catchError((error) {
    print("Failed to add user: $error");
  });
}

void updateImageBrandFireStore(
    File image, String tenthuonghieu, String idthuonghieu) async {
  //Đường dẫn
  final CollectionReference _brands =
      FirebaseFirestore.instance.collection('brand');
  String urlImage = '';
  String timeNow = DateFormat('kk:mm:ss').format(DateTime.now());

  final ref =
      FirebaseStorage.instance.ref().child("images").child(timeNow + '.png');
  await ref.putFile(image);
  urlImage = await ref.getDownloadURL();
  print(urlImage);

  final brand = Brand(
      tenthuonghieu: tenthuonghieu,
      urlImage: urlImage,
      idthuonghieu: idthuonghieu);
  final toJson = brand.toJson();
  print(toJson);
  _brands.doc(idthuonghieu).update(toJson).then((value) {
    showToast('Sửa Thương Hiệu Thành Công', Colors.green);
    pop();
  }).catchError((error) {
    print("Failed to add user: $error");
  });
}

void updateLinkBrandFireStore(
    String urlImage, String tenthuonghieu, String idthuonghieu) async {
  //Đường dẫn
  final CollectionReference _brands =
      FirebaseFirestore.instance.collection('brand');

  final brand = Brand(
      tenthuonghieu: tenthuonghieu,
      urlImage: urlImage,
      idthuonghieu: idthuonghieu);
  final toJson = brand.toJson();
  print(toJson);
  _brands.doc(idthuonghieu).update(toJson).then((value) {
    showToast('Sửa Thương Hiệu Thành Công', Colors.green);
    pop();
  }).catchError((error) {
    print("Failed to add user: $error");
  });
}

//Delete Data lên FireBase
void deleteBrandFireStore(String name) async {
  //Đường dẫn
  final CollectionReference _brands =
      FirebaseFirestore.instance.collection('brand');

  _brands.doc(name).delete().then((value) {
    showToast('Xóa Thành Công', Colors.green);
    pop();
  }).catchError((error) => print("Failed to delele product: $error"));
}

Future<bool> isCheckExistBrand(String tenthuonghieu) async {
  bool check = false;
  var document = await FirebaseFirestore.instance
      .collection("brand")
      .where('tenthuonghieu', isEqualTo: tenthuonghieu)
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
