import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/DAO/cartDAO.dart';
import 'package:my_app_fluter/DAO/commentsDAO.dart';
import 'package:my_app_fluter/DAO/productDAO.dart';
import 'package:my_app_fluter/modal/cart.dart';
import 'package:my_app_fluter/modal/comment.dart';
import 'package:my_app_fluter/modal/product.dart';
import 'package:my_app_fluter/screen_page/cart_page.dart';
import 'package:my_app_fluter/screen_page/login_screen.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:my_app_fluter/utils/showToast.dart';
import 'package:my_app_fluter/utils/show_bottom_sheet.dart';

class ProductDetail extends StatefulWidget {
  late Product product;
  final int index;

  ProductDetail({super.key, required this.index, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Đường dẫn
  final CollectionReference _cart =
      FirebaseFirestore.instance.collection('cart');
  List<Cart> listCart = [];
  int countItemCart = 0;

  int count = 1;
  int currentSize = 0;
  List<String> listSize = ['38', '39', '40', '41', '42', '43'];
  List<String> listColors = ['Đen', 'Xám', 'Hồng', 'Xanh Dương', 'Cam'];
  List<int> listGiaSize = [0, 5, 10, 15, 20, 25];
  String? chooceSize;
  String? chooceColor;
  double? tongtien;
  int currentColor = 0;
  List<ChoiceColor> listColor = [
    ChoiceColor(Colors.black),
    ChoiceColor(Colors.grey),
    ChoiceColor(Colors.pink),
    ChoiceColor(Colors.blue.shade900),
    ChoiceColor(Colors.orange),
  ];

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser != null) {
      countCart();
    }
  }

  void countCart() {
    log(_auth.currentUser!.uid);
    _cart
        .doc(_auth.currentUser!.uid)
        .collection('cart')
        .snapshots()
        .listen((data) {
      listCart.clear();
      for (int i = 0; i < data.docs.length; i++) {
        var item = Cart.fromMap(data.docs[i].data());
        listCart.add(item);
      }

      //   countItemCart = listCart.length;
      // log("detail " + countItemCart.toString());

      setState(() {
        countItemCart = listCart.length;
        log("detail " + countItemCart.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (_auth.currentUser == null) {
                showToast('Bạn Phải Đăng Nhập Trước', Colors.red);
                pushAndRemoveUntil(child: const Login());
              } else {
                pushScreen(
                  context,
                  const CartPage(
                    fromToDetail: true,
                  ),
                );
              }
            },
            icon: _auth.currentUser != null
                ? Badge(
                    padding: const EdgeInsets.all(6),
                    position: BadgePosition.topEnd(top: -15, end: -10),
                    badgeContent: Text(
                      countItemCart.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    badgeColor: Colors.pink,
                    child: const Icon(FontAwesomeIcons.cartShopping),
                  )
                : const Card(),
          ),
        ],
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          widget.product.thuonghieusp!,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Hero(
        tag: widget.index,
        child: Builder(builder: (context) {
          return Material(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          height: 400,
                          child: Image.network(widget.product.urlImage!),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 238, 238, 238),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Wrap(
                                        children: [
                                          Text(
                                            widget.product.tensp!,
                                            style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    _auth.currentUser != null
                                        ? IconButton(
                                            onPressed: () {
                                              setState(() {
                                                widget.product.like =
                                                    !widget.product.like!;
                                              });
                                              updateLikesDataFireStore(
                                                  widget.product);
                                            },
                                            icon: widget.product.like!
                                                ? const Icon(
                                                    FontAwesomeIcons
                                                        .heartCircleCheck,
                                                    color: Colors.pink,
                                                  )
                                                : const Icon(
                                                    FontAwesomeIcons.heart,
                                                    color: Colors.pink,
                                                  ),
                                          )
                                        : const Card(),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: const Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    'Description',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                subtitle: Text(widget.product.chitietsp!),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20),
                                width: double.infinity,
                                height: 42,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      elevation: 8,
                                      shape: (RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(130),
                                      )),
                                    ),
                                    onPressed: () {
                                      _openBottomSheetComment(
                                          context, widget.product.masp!);
                                    },
                                    child: const Text(
                                      'Reviews from client',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Text(
                                              "Size",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          _chooseSize(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: _chooseColor(),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Quantity',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 202, 202, 202),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        width: 100,
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (count != 1) {
                                                    count--;
                                                  }
                                                });
                                              },
                                              icon: const Icon(
                                                  FontAwesomeIcons.minus),
                                            ),
                                            Text(
                                              '$count',
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  count++;
                                                });
                                              },
                                              icon: const Icon(
                                                  FontAwesomeIcons.plus),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  color: const Color.fromARGB(255, 244, 244, 244),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ListTile(
                          title: const Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text('Total Price'),
                          ),
                          subtitle: Text(
                            '\$${(widget.product.giasp! * count) + listGiaSize[currentSize]}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 56,
                          child: ElevatedButton.icon(
                            icon: const Icon(FontAwesomeIcons.cartShopping),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                elevation: 8,
                                shape: (RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(130)))),
                            onPressed: () {
                              if (_auth.currentUser == null) {
                                showToast(
                                    'Bạn Phải Đăng Nhập Trước', Colors.red);
                                pushAndRemoveUntil(child: const Login());
                              } else {
                                addCart(
                                  product: widget.product,
                                  size: chooceSize ?? listSize[0],
                                  color: chooceColor ?? listColors[0],
                                  tongtien: (widget.product.giasp! * count) +
                                      listGiaSize[currentSize],
                                  soluong: count,
                                  gia: widget.product.giasp! +
                                      listGiaSize[currentSize],
                                );
                              }
                            },
                            label: const Text(
                              '    ADD TO CART',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _chooseSize() {
    return Container(
      height: 50,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: listSize.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  currentSize = index;
                  chooceSize = listSize[index];
                });
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // color: Color.fromARGB(255, 219, 218, 218),
                  color: index == currentSize ? Colors.black : Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                child: Text(
                  listSize[index],
                  style: index == currentSize
                      ? const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)
                      : const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _chooseColor() {
    return Container(
      height: 100,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "Color",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15),
            height: 50,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listColor.length,
                itemBuilder: (context, index) {
                  var color = listColor[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        currentColor = index;
                        chooceColor = listColors[index];
                      });
                    },
                    child: Container(
                      width: 40,
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: color.mColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      child: currentColor == index
                          ? const Icon(
                              FontAwesomeIcons.check,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
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
}

class ChoiceColor {
  final Color? mColor;

  ChoiceColor(this.mColor);
}

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

  List<Comment> listComment = [];
  @override
  void initState() {
    super.initState();
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
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    height: 400,
                    // height: MediaQuery.of(context).size.height * 0.5,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: StreamBuilder(
                        stream: _comment
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
                            return listComment.isEmpty
                                ? Image.asset('assets/images/nothing.png')
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                            Radius.circular(
                                                                200)),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        listComment[index]
                                                            .name!,
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
                                                              ? Text(listComment[
                                                                          index]
                                                                      .content!
                                                                      .substring(
                                                                          0,
                                                                          60) +
                                                                  '...')
                                                              : Text(listComment[
                                                                      index]
                                                                  .content!),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          _auth.currentUser != null &&
                                                  _auth.currentUser!
                                                          .displayName ==
                                                      'admin'
                                              ? Positioned(
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
                                                      backgroundColor:
                                                          Colors.black,
                                                      child: Icon(
                                                        FontAwesomeIcons
                                                            .trashCan,
                                                        color: Colors.white,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const Card(),
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
}
