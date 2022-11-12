import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/modal/brand.dart';
import 'package:my_app_fluter/modal/product.dart';
import 'package:my_app_fluter/screen_page/product_detail_screen.dart';
import 'package:my_app_fluter/screen_page/test.dart';

import '../utils/push_screen.dart';

class HomePageTest extends StatefulWidget {
  const HomePageTest({super.key});

  @override
  State<HomePageTest> createState() => _HomePageTestState();
}

class _HomePageTestState extends State<HomePageTest> {
  //Đường dẫn
  final CollectionReference _brands =
      FirebaseFirestore.instance.collection('brand');

  late Product product;
  final List<Product> listProduct = [];
  //Đường dẫn
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('product');

  bool _isClickLike = false;
  //function delay
  Future<void> delay(int millis) async {
    await Future.delayed(Duration(milliseconds: millis));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                toolbarHeight: 100,
                expandedHeight: 150,
                pinned: true,
                floating: true,
                snap: true,
                title: Text('adasd'),
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.cloud_outlined),
                    ),
                    Tab(
                      icon: Icon(Icons.beach_access_sharp),
                    ),
                    Tab(
                      icon: Icon(Icons.brightness_5_sharp),
                    ),
                  ],
                ),
              ),
            ],
            body: SingleChildScrollView(
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
                                child: Image.asset(
                                  'assets/images/khi.png',
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Hello !',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200),
                                  ),
                                  Text(
                                    'Andrew  !',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: const Icon(
                                    Icons.notifications_none_outlined,
                                    color: Colors.black,
                                    size: 36,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Special Offers',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: _slider(),
                    ),
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
                                  return Column(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 226, 226, 226),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
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
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: StreamBuilder(
                          stream: _products.snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 250,
                                ),
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var mapData = snapshot.data!.docs[index]
                                      .data() as Map<String, dynamic>;
                                  product = Product.fromJson(mapData);
                                  listProduct.add(product);
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
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.45,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    decoration:
                                                        const BoxDecoration(
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8),
                                                          child: Text(
                                                            product.tensp!,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            '\$' +
                                                                product.giasp
                                                                    .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                    product.urlImage!,
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
                                                        _isClickLike =
                                                            !_isClickLike;
                                                      });
                                                    },
                                                    icon: _isClickLike
                                                        ? const Icon(
                                                            FontAwesomeIcons
                                                                .heartCircleCheck,
                                                            color: Colors.pink,
                                                          )
                                                        : const Icon(
                                                            FontAwesomeIcons
                                                                .heart,
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
        ),
      ),
    );
  }

  Widget _slider() {
    return CarouselSlider.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          Container(
        child: Stack(
          children: [
            Card(
              margin: const EdgeInsets.all(10),
              color: const Color.fromARGB(255, 234, 234, 234),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Image.asset('assets/images/logo.png'),
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
                  '30$itemIndex.00 \$',
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
}
