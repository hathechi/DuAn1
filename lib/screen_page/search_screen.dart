import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/modal/product.dart';
import 'package:my_app_fluter/screen_page/product_detail_screen.dart';
import 'package:my_app_fluter/utils/push_screen.dart';

class SearchScreen extends StatefulWidget {
  late String? brand;
  SearchScreen({super.key, this.brand});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //Đường dẫn
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('product');
  final searchController = TextEditingController();
  String? search;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    search = widget.brand.toString().toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        pop();
                      },
                      icon: const Icon(FontAwesomeIcons.chevronLeft),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      // padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                        controller: searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search_outlined,
                            size: 26,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                searchController.clear();
                              },
                              icon: const Icon(
                                FontAwesomeIcons.circleXmark,
                              )),
                          hintText: 'Search ...',
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 241, 19, 133),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: StreamBuilder(
                  stream: _products.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (search == null) {
                      return Container(
                        child: Image.asset('assets/images/nothing.png'),
                      );
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var documentSnapshot = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          var product = Product.fromJson(documentSnapshot);

                          if (product.tensp
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(search ?? ''.toLowerCase()) ||
                              product.giasp
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(search ?? ''.toLowerCase()) ||
                              product.thuonghieusp
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(search ?? ''.toLowerCase())) {
                            return _itemLikes(product, index);
                          }
                          return const Card();
                        },
                      );
                    }
                    return const Card();
                  },
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemLikes(var product, int index) {
    return InkWell(
      onTap: () {
        pushScreen(context, ProductDetail(index: index, product: product));
      },
      child: Container(
        height: 150,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            color: Color.fromARGB(255, 238, 238, 238)),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Image.network(product.urlImage),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      product.tensp,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 252, 210, 188),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Price: \$${product.giasp}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Text(
                        product.thuonghieusp,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
