// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: sized_box_for_whitespace

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/DAO/productDAO.dart';

import 'package:my_app_fluter/modal/brand.dart';
import 'package:my_app_fluter/modal/product.dart';
import 'package:my_app_fluter/screen_page/home_screen.dart';
import 'package:my_app_fluter/screen_page/product_detail_screen.dart';
import 'package:my_app_fluter/screen_page/search_screen.dart';
import 'package:my_app_fluter/screen_page/test.dart';

import '../utils/push_screen.dart';

class PageHome extends StatefulWidget {
  final PageController pageController;
  const PageHome({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome>
    with AutomaticKeepAliveClientMixin {
  static final _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Đường dẫn
  static final CollectionReference _brands = _fireStore.collection('brand');

  final List<Product> listProduct = [];
  final _productHasUpdate = ValueNotifier<bool>(false);
  //Đường dẫn
  final CollectionReference _products = _fireStore.collection('product');

  bool _isClickLike = false;
  //function delay
  Future<void> delay(int millis) async {
    await Future.delayed(Duration(milliseconds: millis));
  }

  String getNameUser() {
    if (_auth.currentUser?.displayName == null) {
      return 'Guest';
    }
    return _auth.currentUser!.displayName!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileUpdateChanged.stream.listen((event) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Widget getAvatar() {
    if (_auth.currentUser?.photoURL == null) {
      return Image.asset(
        'assets/images/avatar.jpg',
        fit: BoxFit.contain,
      );
    }
    return InkWell(
      onTap: () {
        widget.pageController.jumpToPage(3);
      },
      child: Image.network(
        _auth.currentUser!.photoURL!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          child: CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(255, 205, 205, 205),
                            child: ClipRRect(
                              borderRadius: const BorderRadiusDirectional.all(
                                  Radius.circular(100)),
                              child: getAvatar(),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          child: InkWell(
                            onTap: () => widget.pageController.jumpToPage(3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hello !',
                                  style: TextStyle(fontWeight: FontWeight.w200),
                                ),
                                Text(
                                  getNameUser(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {},
                                child: const Icon(
                                  Icons.notifications_none_outlined,
                                  color: Colors.black,
                                  size: 36,
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
                  child: TextFormField(
                    showCursor: false,
                    readOnly: true,
                    onTap: () => pushScreen(context, SearchScreen()),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.search_outlined,
                        size: 26,
                      ),
                      suffixIcon: Icon(Icons.bubble_chart),
                      hintText: 'Search ...',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 241, 19, 133),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Special Offers',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                ValueListenableBuilder<bool>(
                    valueListenable: _productHasUpdate,
                    builder: (context, value, child) {
                      if (!value) return const SizedBox();
                      return Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: _slider(listProduct));
                    }),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: StreamBuilder(
                      stream: _brands.snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4),
                            itemCount: streamSnapshot.data!.docs.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];
                              return InkWell(
                                onTap: () => pushScreen(
                                    context,
                                    SearchScreen(
                                      brand: documentSnapshot['tenthuonghieu'],
                                    )),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 226, 226, 226),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: Image.network(
                                        documentSnapshot['urlImage'],
                                        scale: 3,
                                      ),
                                    ),
                                    Text(
                                      documentSnapshot['tenthuonghieu'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return const Card();
                      }),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Most Popular',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: StreamBuilder(
                      stream: _products.snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          listProduct.clear();
                          for (var element in snapshot.data!.docs) {
                            var mapData =
                                element.data() as Map<String, dynamic>;
                            var _productTemp = Product.fromJson(mapData);
                            listProduct.add(_productTemp);
                          }
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            _productHasUpdate.value = true;
                          });
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 250,
                            ),
                            scrollDirection: Axis.vertical,
                            itemCount: listProduct.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Hero(
                                tag: index,
                                child: Builder(builder: (context) {
                                  return Material(
                                    child: InkWell(
                                      onTap: () {
                                        pushScreen(
                                            context,
                                            ProductDetail(
                                              product: listProduct[index],
                                              index: index,
                                            ));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(5),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              bottom: 0,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.45,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                alignment: Alignment.bottomLeft,
                                                decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 231, 231, 231),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8),
                                                      child: Text(
                                                        listProduct[index]
                                                            .tensp!,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        '\$' +
                                                            listProduct[index]
                                                                .giasp
                                                                .toString(),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // Text('Running Shoes'),
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              child: Image.network(
                                                listProduct[index].urlImage!,
                                                width: 200,
                                                height: 180,
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              bottom: 0,
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    listProduct[index].like =
                                                        !listProduct[index]
                                                            .like!;
                                                  });
                                                  updateLikesDataFireStore(
                                                      listProduct[index]);
                                                },
                                                icon: listProduct[index].like!
                                                    ? const Icon(
                                                        FontAwesomeIcons
                                                            .heartCircleCheck,
                                                        color: Colors.pink,
                                                      )
                                                    : const Icon(
                                                        FontAwesomeIcons.heart,
                                                        color: Colors.pink,
                                                      ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          );
                        }
                        return const Card();
                      }),
                ),
                // _slider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _slider(List<Product> listProduct) {
    return CarouselSlider.builder(
      itemCount: listProduct.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          InkWell(
        onTap: () => pushScreen(
          context,
          ProductDetail(index: itemIndex, product: listProduct[itemIndex]),
        ),
        child: Container(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 234, 234, 234),
                ),
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.network(listProduct[itemIndex].urlImage!)),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    '\$' + listProduct[itemIndex].giasp.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      options: CarouselOptions(
        height: 300.0,
        viewportFraction: 1,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
