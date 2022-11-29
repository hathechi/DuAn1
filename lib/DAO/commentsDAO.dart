import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app_fluter/modal/comment.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:my_app_fluter/utils/showToast.dart';

Future addComment({String? content, String? idsanpham}) async {
  //Đường dẫn
  final CollectionReference _comment =
      FirebaseFirestore.instance.collection('comments');

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String timeNow = DateFormat('kk:mm:ss').format(DateTime.now());
  // String dateNow = DateFormat('dd-MM-yyyy').format(DateTime.now());

  String userID = _auth.currentUser!.uid;
  String nameUser = _auth.currentUser!.displayName!;
  String urlImageAvatar = _auth.currentUser!.photoURL!;
  final comment = Comment(
      idComment: timeNow,
      idUser: userID,
      name: nameUser,
      content: content,
      urlImageAvatar: urlImageAvatar,
      idsanpham: idsanpham);
  final toMap = comment.toMap();
  _comment.doc(timeNow).set(toMap).then((value) {
    showToast('Đánh Giá Sản Phẩm Thành Công', Colors.green);
    pop();
  }).catchError((error) {
    print("Failed to add user: $error");
  });
}

Future deleteComment(String idComment) async {
  //Đường dẫn
  final CollectionReference _comment =
      FirebaseFirestore.instance.collection('comments');

  _comment.doc(idComment).delete().then((value) {
    showToast('Xóa Đánh Giá Thành Công', Colors.green);
    pop();
  }).catchError((error) {
    print("Failed to add user: $error");
  });
}
