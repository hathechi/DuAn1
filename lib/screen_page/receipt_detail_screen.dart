import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/DAO/commentsDAO.dart';
import 'package:my_app_fluter/DAO/receiptDAO.dart';
import 'package:my_app_fluter/modal/cart.dart';
import 'package:my_app_fluter/modal/comment.dart';
import 'package:my_app_fluter/modal/receipt.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:my_app_fluter/utils/showToast.dart';
import 'package:my_app_fluter/utils/show_bottom_sheet.dart';

class ReceiptDetail extends StatefulWidget {
  Receipt receipt;
  ReceiptDetail({super.key, required this.receipt});

  @override
  State<ReceiptDetail> createState() => _ReceiptDetailState();
}

class _ReceiptDetailState extends State<ReceiptDetail> {
  List<Cart> listCart = [];
  @override
  void initState() {
    super.initState();
    listCart = widget.receipt.listCart!;
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
          'Receipt Detail',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 236, 236, 236),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DetailBill(
                            title: 'Code Bill:',
                            content: widget.receipt.mahoadon!),
                        DetailBill(
                            title: 'Date created:',
                            content: widget.receipt.ngaytaohd!.toString()),
                        DetailBill(
                            title: 'Phone Number:',
                            content: widget.receipt.phoneNumber!),
                        DetailBill(
                            title: 'Name:', content: widget.receipt.nguoinhan!),
                        DetailBill(
                            title: 'Address:',
                            content: widget.receipt.address!),
                        DetailBill(
                            title: 'Total Price:',
                            content: '\$' +
                                widget.receipt.tongtien!.toStringAsFixed(3)),
                        DetailBill(
                            title: 'Status:',
                            content: !widget.receipt.status!
                                ? 'Chưa Hoàn Thành'
                                : 'Đã Hoàn Thành'),
                      ],
                    ),
                  ),
                  Container(
                    child: Image.asset('assets/images/giaohang.jpeg'),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listCart.length,
                          itemBuilder: (context, index) {
                            return _itemCart(index);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !widget.receipt.status!,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 176, 176, 176),
                    offset: Offset(0.0, 1), //(x,y)
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 228, 228, 228),
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(130)))),
                        onPressed: () {
                          dialogModalBottomsheet(context, 'Return and Refund',
                              () => deleteReceipt(context, widget.receipt));
                        },
                        label: const Text(
                          'Return and Refund',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        icon: const Icon(
                          FontAwesomeIcons.rightLeft,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(130)))),
                        onPressed: () {
                          widget.receipt.status = true;
                          dialogModalBottomsheet(context, 'Complete Your Order',
                              () => updateReceipt(context, widget.receipt));
                        },
                        label: const Text(
                          'Complete Your Order',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(FontAwesomeIcons.check),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemCart(index) {
    return Container(
      height: 150,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Color.fromARGB(255, 226, 235, 247),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              child: Image.network(
                listCart[index].urlImage!,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Wrap(
                          children: [
                            Text(
                              listCart[index].tensp!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black,
                        child: Text(
                          listCart[index].slsp.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${listCart[index].mausp!}  |  Size = ${listCart[index].kichcosp!}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: widget.receipt.status!,
                    child: Container(
                      alignment: Alignment.bottomRight,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            elevation: 8,
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(130)))),
                        onPressed: () {
                          _openBottomSheetComment(
                              context, listCart[index].idsanpham!);
                        },
                        child: const Text(
                          'Comment',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }

  void _openBottomSheetComment(BuildContext context, String idsp) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return BottomSheet(
          idsanpham: idsp,
        );
      },
    );
  }

  Widget DetailBill({String? title, String? content}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(title!),
        ),
        const SizedBox(
          width: 40,
        ),
        Expanded(
          flex: 3,
          child: Wrap(
            children: [
              Text(
                content!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class BottomSheet extends StatefulWidget {
  final String? idsanpham;
  const BottomSheet({super.key, this.idsanpham});

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  //Đường dẫn
  final CollectionReference _comment =
      FirebaseFirestore.instance.collection('comments');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _controllerComment = TextEditingController();

  String? urlImageAvatar;
  List<Comment> listComment = [];
  @override
  void initState() {
    super.initState();
    if (_auth.currentUser != null) {
      urlImageAvatar = _auth.currentUser!.photoURL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          radius: 30,
                          child: ClipRRect(
                            borderRadius: const BorderRadiusDirectional.all(
                                Radius.circular(200)),
                            child: urlImageAvatar == null
                                ? Image.asset(
                                    'assets/images/avatar.png',
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    urlImageAvatar!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        flex: 5,
                        child: Form(
                          key: navKey1,
                          child: inputComment(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
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
                          if (navKey1.currentState!.validate()) {
                            log(widget.idsanpham!);
                            addComment(
                                content: _controllerComment.text,
                                idsanpham: widget.idsanpham);
                          }
                        },
                        child: const Text(
                          'Comment',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    height: 400,
                    // height: MediaQuery.of(context).size.height * 0.5,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: StreamBuilder(
                        stream: _comment
                            .where('idUser', isEqualTo: _auth.currentUser!.uid)
                            .where('idsanpham', isEqualTo: widget.idsanpham)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            listComment.clear();
                            for (var element in streamSnapshot.data!.docs) {
                              var _item = Comment.fromMap(
                                (element.data() as Map<String, dynamic>),
                              );
                              listComment.add(_item);
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: listComment.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 190, 207, 217),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      margin: const EdgeInsets.all(5),
                                      height: 80,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          CircleAvatar(
                                            radius: 25,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadiusDirectional
                                                          .all(
                                                      Radius.circular(200)),
                                              child: Image.network(
                                                listComment[index]
                                                    .urlImageAvatar!,
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  listComment[index].name!,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Wrap(
                                                  children: [
                                                    listComment[index]
                                                                .content!
                                                                .length >=
                                                            60
                                                        ? Text(
                                                            listComment[index]
                                                                    .content!
                                                                    .substring(
                                                                        0, 60) +
                                                                '...')
                                                        : Text(
                                                            listComment[index]
                                                                .content!),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: InkWell(
                                        onTap: () {
                                          dialogModalBottomsheet(
                                              context,
                                              'Delete',
                                              () => deleteComment(
                                                  listComment[index]
                                                      .idComment!));
                                        },
                                        child: const CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.black,
                                          child: Icon(
                                            FontAwesomeIcons.trashCan,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          return const Card();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputComment() => Container(
        // width: MediaQuery.of(context).size.width * 0.5,
        child: TextFormField(
          controller: _controllerComment,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value!.isEmpty) {
              return "Bạn Chưa Nhập Đánh Giá";
            }

            return null;
          },
          decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 233, 233, 233),
              prefixIcon: Icon(
                Icons.comment,
                size: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              labelText: 'Comment',
              labelStyle: TextStyle(fontSize: 12)),
        ),
      );
}
