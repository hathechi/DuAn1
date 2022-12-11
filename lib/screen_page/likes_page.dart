import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/DAO/productDAO.dart';
import 'package:my_app_fluter/modal/product.dart';
import 'package:my_app_fluter/screen_page/login_screen.dart';
import 'package:my_app_fluter/screen_page/product_detail_screen.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:my_app_fluter/utils/showToast.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  final List<Product> listProduct = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Đường dẫn
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('product');
  int count = 1;

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser == null) {
      showToast('Bạn Phải Đăng Nhập Trước', Colors.red);
      pushReplacement(context, const Login());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Likes Page",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: StreamBuilder(
                  stream: _products.where('like', isEqualTo: true).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      listProduct.clear();
                      for (var element in snapshot.data!.docs) {
                        var mapData = element.data() as Map<String, dynamic>;
                        var _productTemp = Product.fromJson(mapData);
                        listProduct.add(_productTemp);
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listProduct.length,
                        itemBuilder: (context, index) {
                          return _itemLikes(index);
                        },
                      );
                    }
                    return const Card();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemLikes(int index) {
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            spacing: 10,
            onPressed: (context) {
              setState(() {
                listProduct[index].like = !listProduct[index].like!;
              });
              updateLikesDataFireStore(listProduct[index]);
            },
            backgroundColor: const Color.fromARGB(255, 245, 55, 55),
            // foregroundColor: Colors.white,
            icon: FontAwesomeIcons.trashCan,
            label: 'DELETE',
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          pushScreen(context,
              ProductDetail(index: index, product: listProduct[index]));
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
                  child: Image.network(listProduct[index].urlImage!),
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
                        listProduct[index].tensp!,
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
                          'Price: \$${listProduct[index].giasp}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Text(
                          listProduct[index].thuonghieusp!,
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
      ),
    );
  }
}
