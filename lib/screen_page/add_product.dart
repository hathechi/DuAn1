import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app_fluter/DAO/productDAO.dart';
import 'package:my_app_fluter/modal/brand.dart';
import 'package:my_app_fluter/modal/product.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:my_app_fluter/utils/showToast.dart';
import 'package:my_app_fluter/utils/show_bottom_sheet.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late Product product;
  //Đường dẫn
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('product');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Product",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: StreamBuilder(
              stream: _products.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var mapData = streamSnapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      var idColection = streamSnapshot.data!.docs[index].id;
                      log("ID: " + idColection);
                      product = Product.fromJson(mapData);
                      return _itemProduct(product);
                    },
                  );
                }

                return const Card();
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openBottomSheetAdd(context, 'ADD PRODUCT', product);
        },
        child: const Icon(FontAwesomeIcons.plus),
      ),
    );
  }

  Widget _itemProduct(Product product) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            const SizedBox(
              width: 10,
            ),
            SlidableAction(
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              spacing: 10,
              onPressed: (context) {
                _openBottomSheetAdd(context, 'EDIT', product);
              },

              backgroundColor: const Color.fromARGB(255, 22, 142, 227),
              // foregroundColor: Colors.white,
              icon: FontAwesomeIcons.penToSquare,
              label: 'EDIT',
            ),
            const SizedBox(
              width: 10,
            ),
            SlidableAction(
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              spacing: 10,
              onPressed: (context) {
                dialogModalBottomsheet(
                  context,
                  'Delete',
                  () {
                    deleteDataFireStore(product.masp!);
                  },
                );
              },
              backgroundColor: const Color.fromARGB(255, 245, 55, 55),
              // foregroundColor: Colors.white,
              icon: FontAwesomeIcons.trashCan,
              label: 'DELETE',
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 150,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: Color.fromARGB(255, 236, 236, 236)),
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
                    product.urlImage!,
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
                            flex: 3,
                            child: Wrap(
                              children: [
                                Text(
                                  product.tensp!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Wrap(
                              children: [
                                Text(
                                  'Price: ${product.giasp}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          product.thuonghieusp!,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          children: [
                            Text(
                              'Amount: ${product.slnhap}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          children: [
                            Text(
                              'Detail: ${product.chitietsp}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
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

void _openBottomSheetAdd(BuildContext context, String title, Product product) {
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
      return BottomAdd(
        title: title,
        product: product,
      );
    },
  );
}

class BottomAdd extends StatefulWidget {
  final String title;
  late Product product;

  BottomAdd({
    required this.title,
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  State<BottomAdd> createState() => _BottomAddState();
}

class _BottomAddState extends State<BottomAdd> {
  final _controllerName = TextEditingController();
  final _controllerPrice = TextEditingController();
  final _controllerAmount = TextEditingController();
  final _controllerDetail = TextEditingController();

  final CollectionReference _brands =
      FirebaseFirestore.instance.collection('brand');

  // List<String> listsDropDown = [
  //   "ADIDAS",
  //   'BITIS',
  //   'CONVERSE',
  //   'PUMA',
  // ];

  String? selectedValue;
  String? linkUrl;
  //Lấy hình từ thư viện máy
  File? image;

  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('false');
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.title.toString() == 'EDIT') {
      _controllerName.text = widget.product.tensp!;
      _controllerPrice.text = widget.product.giasp.toString();
      _controllerAmount.text = widget.product.slnhap.toString();
      _controllerDetail.text = widget.product.chitietsp!;
      selectedValue = widget.product.thuonghieusp;
      linkUrl = widget.product.urlImage;
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
                children: [
                  Form(
                    key: navKey1,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: TextFormField(
                            controller: _controllerName,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Không Bỏ Trống ";
                              }
                              if (!RegExp(
                                      r'^[A-Za-zÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚÝàáâãèéêìíòóôõùúýĂăĐđĨĩŨũƠơƯưẠ-ỹ ]+$')
                                  .hasMatch(value)) {
                                return "Tên Không Chứa Ký Tự Đặc Biệt Hoặc Số";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 240, 240, 240),
                                prefixIcon: Icon(
                                  FontAwesomeIcons.tags,
                                  size: 18,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                labelText: 'NAME',
                                labelStyle: TextStyle(fontSize: 12)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _controllerPrice,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Không Bỏ Trống ";
                              }
                              if (!RegExp(r'^[. 0-9]+$').hasMatch(value)) {
                                return "Không Chứa Ký Tự Đặc Biệt ";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 240, 240, 240),
                                prefixIcon: Icon(
                                  FontAwesomeIcons.dollarSign,
                                  size: 18,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                labelText: 'PRICE',
                                labelStyle: TextStyle(fontSize: 12)),
                          ),
                        ),
                        Container(
                          child: StreamBuilder(
                              stream: _brands.snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                                if (streamSnapshot.hasData) {
                                  return DropdownButtonFormField2(
                                    buttonHeight: 60,
                                    // dropdownWidth: double.infinity,
                                    buttonWidth: double.infinity,
                                    buttonPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    iconSize: 16,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(FontAwesomeIcons.apple),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                    buttonDecoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 240, 240, 240),
                                      borderRadius: BorderRadius.circular(20),
                                    ),

                                    // isExpanded: true,
                                    hint: const Text(
                                      'CHOOSE BRAND',
                                    ),
                                    // dropdownItems: listsDropDown,

                                    items: streamSnapshot.data!.docs
                                        .map((DocumentSnapshot
                                                documentSnapshot) =>
                                            DropdownMenuItem<String>(
                                              value: documentSnapshot[
                                                  'tenthuonghieu'],
                                              child: Text(
                                                documentSnapshot[
                                                    'tenthuonghieu'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Không Bỏ Trống';
                                      }
                                    },
                                    value: selectedValue,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValue = value.toString();
                                      });
                                    },
                                    onSaved: (newValue) {
                                      selectedValue = newValue.toString();
                                    },
                                  );
                                }

                                return const Card();
                              }),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _controllerAmount,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Không Bỏ Trống";
                              }
                              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return "Không Chứa Ký Tự Đặc Biệt ";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 240, 240, 240),
                                prefixIcon: Icon(
                                  Icons.format_list_numbered,
                                  size: 18,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                labelText: 'AMOUNT',
                                labelStyle: TextStyle(fontSize: 12)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: TextFormField(
                            controller: _controllerDetail,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Không Bỏ Trống ";
                              }
                              // if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                              //   return "Tên Không Chứa Ký Tự Đặc Biệt Hoặc Số";
                              // }
                              return null;
                            },
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 240, 240, 240),
                                prefixIcon: Icon(
                                  FontAwesomeIcons.calendarDay,
                                  size: 18,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                labelText: 'DETAIL',
                                labelStyle: TextStyle(fontSize: 12)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 233, 233, 233),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              getImage();
                            },
                            child: Stack(
                              children: [
                                image != null
                                    ? Image.file(
                                        image!,
                                        fit: BoxFit.contain,
                                        height: 200,
                                        width: 200,
                                      )
                                    : linkUrl != null
                                        ? Image.network(
                                            linkUrl.toString(),
                                            fit: BoxFit.contain,
                                            height: 200,
                                            width: 200,
                                          )
                                        : Image.asset(
                                            "assets/images/khi.png",
                                            fit: BoxFit.contain,
                                            height: 200,
                                            width: 200,
                                          ),
                                const Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Icon(
                                    FontAwesomeIcons.cameraRetro,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 238, 238, 238),
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(130),
                                ),
                              ),
                              onPressed: () {
                                pop();
                              },
                              child: const Text(
                                'CANCEL',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  elevation: 8,
                                  shape: (RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(130)))),
                              onPressed: () {
                                if (widget.title.toString() == 'EDIT') {
                                  if (navKey1.currentState!.validate()) {
                                    if (image == null) {
                                      isCheckExist(_controllerName.text).then(
                                        (value) {
                                          if (value == true) {
                                            showToast(
                                                'Tên Sản Phẩm Đã Tồn Tại!',
                                                Colors.red);
                                          } else {
                                            updateDataFireStoreUrl(
                                                linkUrl.toString(),
                                                double.tryParse(
                                                    _controllerPrice.text)!,
                                                _controllerDetail.text,
                                                selectedValue!,
                                                int.tryParse(
                                                    _controllerAmount.text)!,
                                                _controllerName.text,
                                                widget.product.masp!);
                                            showLoading(1);
                                          }
                                        },
                                      );
                                    } else {
                                      isCheckExist(_controllerName.text).then(
                                        (value) {
                                          if (value == true) {
                                            showToast(
                                                'Tên Sản Phẩm Đã Tồn Tại!',
                                                Colors.red);
                                          } else {
                                            updateDataFireStoreImage(
                                                image!,
                                                double.tryParse(
                                                    _controllerPrice.text)!,
                                                _controllerDetail.text,
                                                selectedValue!,
                                                int.tryParse(
                                                    _controllerAmount.text)!,
                                                _controllerName.text,
                                                widget.product.masp!);
                                            showLoading(4);
                                          }
                                        },
                                      );
                                    }
                                  }
                                } else {
                                  if (navKey1.currentState!.validate()) {
                                    if (image == null) {
                                      showToast(
                                          'Bạn Chưa Chọn Hình', Colors.red);
                                    } else {
                                      isCheckExist(_controllerName.text).then(
                                        (value) {
                                          if (value == true) {
                                            showToast(
                                                'Tên Sản Phẩm Đã Tồn Tại!',
                                                Colors.red);
                                          } else {
                                            pustDataFireStore(
                                              image!,
                                              double.tryParse(
                                                  _controllerPrice.text)!,
                                              _controllerDetail.text,
                                              selectedValue!,
                                              int.tryParse(
                                                  _controllerAmount.text)!,
                                              _controllerName.text,
                                            );
                                            showLoading(4);
                                          }
                                        },
                                      );
                                    }
                                  }
                                }
                              },
                              child: Text(
                                widget.title.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget dropDown() {
    //Đường dẫn
    final CollectionReference _brands =
        FirebaseFirestore.instance.collection('brand');
    List<String> listBrand = [];
    return StreamBuilder(
        stream: _brands.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var mapData = streamSnapshot.data!.docs[index].data()
                    as Map<String, dynamic>;
                // listBrand.add();
                // brand = Brand.fromJson(mapData);
                // return _itemBrand(brand);
                return const Card();
              },
            );
          }

          return const Card();
        });
  }
}
