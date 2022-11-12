import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/modal/product.dart';
import 'package:my_app_fluter/screen_page/cart_page.dart';
import 'package:my_app_fluter/screen_page/login_screen.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:my_app_fluter/utils/showToast.dart';

class ProductDetail extends StatefulWidget {
  late Product product;
  final int index;

  ProductDetail({super.key, required this.index, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isClickLike = false;
  int count = 1;
  int currentSize = 0;
  int currentColor = 0;
  List<ChoiceColor> listColor = [
    ChoiceColor(Colors.black),
    ChoiceColor(Colors.grey),
    ChoiceColor(Colors.pink),
    ChoiceColor(Colors.blue.shade900),
    ChoiceColor(Colors.amber),
  ];

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
            icon: const Icon(
              FontAwesomeIcons.cartArrowDown,
              size: 28,
            ),
          )
        ],
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          widget.product.tensp!,
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
                                    Text(
                                      widget.product.tensp!,
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isClickLike = !_isClickLike;
                                        });
                                      },
                                      icon: _isClickLike
                                          ? const Icon(
                                              FontAwesomeIcons.heartCircleCheck,
                                              color: Colors.pink,
                                            )
                                          : const Icon(
                                              FontAwesomeIcons.heart,
                                              color: Colors.pink,
                                            ),
                                    ),
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
                            '\$${widget.product.giasp! * count}',
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
                            onPressed: () {},
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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                currentSize = index;
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
                '4$index',
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
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listColor.length,
              itemBuilder: (context, index) {
                var color = listColor[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      currentColor = index;
                    });
                  },
                  child: Container(
                    width: 40,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
        ],
      ),
    );
  }
}

class ChoiceColor {
  final Color? mColor;

  ChoiceColor(this.mColor);
}
