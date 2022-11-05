import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/screen_page/product_detail_screen.dart';
import 'package:my_app_fluter/screen_page/test.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  bool _isClickLike = false;
  //function delay
  Future<void> delay(int millis) async {
    await Future.delayed(Duration(milliseconds: millis));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Hello !',
                                style: TextStyle(fontWeight: FontWeight.w200),
                              ),
                              Text(
                                'Andrew  !',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
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
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
                  child: TextFormField(
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
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: _slider(),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                    itemCount: 7,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 226, 226, 226),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                            margin: const EdgeInsets.only(bottom: 5),
                            child: index % 2 == 0
                                ? Image.asset(
                                    'assets/images/nike-logo.png',
                                    scale: 3,
                                  )
                                : Image.asset(
                                    'assets/images/puma.png',
                                    scale: 3,
                                  ),
                          ),
                          const Text("Nike"),
                        ],
                      );
                    },
                  ),
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
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 250,
                    ),
                    scrollDirection: Axis.vertical,
                    itemCount: 10,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetail(index: index)),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height:
                                      MediaQuery.of(context).size.width * 0.4,
                                  alignment: Alignment.bottomLeft,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 231, 231, 231),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          'Running Shoes',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          '\$60.00',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
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
                                child: index % 2 == 0
                                    ? Image.asset(
                                        'assets/images/giay1.png',
                                        width: 200,
                                        height: 180,
                                      )
                                    : Image.asset(
                                        'assets/images/giay3.png',
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
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // _slider(),
              ],
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
