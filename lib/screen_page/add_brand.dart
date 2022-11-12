import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app_fluter/DAO/brandDAO.dart';
import 'package:my_app_fluter/modal/brand.dart';
import 'package:my_app_fluter/utils/showToast.dart';
import 'package:my_app_fluter/utils/show_bottom_sheet.dart';

import '../utils/push_screen.dart';

class AddBrand extends StatefulWidget {
  const AddBrand({super.key});

  @override
  State<AddBrand> createState() => _AddBrandState();
}

class _AddBrandState extends State<AddBrand> {
  //Đường dẫn
  final CollectionReference _brands =
      FirebaseFirestore.instance.collection('brand');

  late Brand brand;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Add Brand",
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
        width: double.infinity,
        // alignment: Alignment.center,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: StreamBuilder(
              stream: _brands.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, mainAxisExtent: 210),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var mapData = streamSnapshot.data!.docs[index].data()
                          as Map<String, dynamic>;

                      brand = Brand.fromJson(mapData);
                      return _itemBrand(brand);
                    },
                  );
                }

                return const Card();
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openBottomSheetAdd(context, 'ADD BRAND', brand);
        },
        child: const Icon(FontAwesomeIcons.plus),
      ),
    );
  }

  Widget _itemBrand(Brand brand) {
    return InkWell(
      onLongPress: () {
        _openBottomSheetAdd(context, 'EDIT', brand);
      },
      child: Container(
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
                  dialogModalBottomsheet(
                    context,
                    'Delete',
                    () {
                      deleteBrandFireStore(brand.idthuonghieu!);
                      showLoading(1);
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
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Color.fromARGB(255, 236, 236, 236)),
            child: Column(
              children: [
                Container(
                  // width: 60,
                  // height: 60,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Image.network(
                    brand.urlImage!,
                    // width: double.infinity,
                    // height: double.infinity,
                  ),
                ),
                Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        brand.tenthuonghieu!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _openBottomSheetAdd(BuildContext context, String title, Brand brand) {
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
      return bottomAdd(
        title: title,
        brand: brand,
      );
    },
  );
}

class bottomAdd extends StatefulWidget {
  final String title;
  late Brand brand;
  bottomAdd({
    required this.title,
    required this.brand,
    Key? key,
  }) : super(key: key);

  @override
  State<bottomAdd> createState() => _bottomAddState();
}

class _bottomAddState extends State<bottomAdd> {
  final _controllerName = TextEditingController();
  String? urlImage;
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
      _controllerName.text = widget.brand.tenthuonghieu!;
      urlImage = widget.brand.urlImage!;
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
                              if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
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
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(255, 215, 215, 215),
                                radius: 60,
                                child: ClipRRect(
                                  borderRadius:
                                      const BorderRadiusDirectional.all(
                                          Radius.circular(100)),
                                  child: image != null
                                      ? Image.file(
                                          image!,
                                          fit: BoxFit.cover,
                                          width: 200,
                                          height: 200,
                                        )
                                      : urlImage != null
                                          ? Image.network(
                                              urlImage!,
                                              fit: BoxFit.cover,
                                              width: 200,
                                              height: 200,
                                            )
                                          : Image.asset(
                                              "assets/images/choose.jpg",
                                              fit: BoxFit.cover,
                                            ),
                                ),
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
                                shape: (RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(130),
                                )),
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
                                  borderRadius: BorderRadius.circular(130),
                                )),
                              ),
                              onPressed: () {
                                if (widget.title.toString() == "EDIT") {
                                  if (navKey1.currentState!.validate()) {
                                    if (image == null) {
                                      isCheckExistBrand(_controllerName.text)
                                          .then(
                                        (value) => {
                                          if (value == true)
                                            {
                                              showToast(
                                                  'Tên Thương Hiệu Đã Tồn Tại',
                                                  Colors.red),
                                            }
                                          else
                                            {
                                              updateLinkBrandFireStore(
                                                  urlImage!,
                                                  _controllerName.text
                                                      .toUpperCase(),
                                                  widget.brand.idthuonghieu!),
                                              showLoading(1),
                                            }
                                        },
                                      );
                                    } else {
                                      updateImageBrandFireStore(
                                          image!,
                                          _controllerName.text.toUpperCase(),
                                          widget.brand.idthuonghieu!);
                                      showLoading(4);
                                    }
                                  }
                                } else {
                                  if (navKey1.currentState!.validate()) {
                                    if (image == null) {
                                      showToast('Chưa Chọn Hình', Colors.red);
                                    } else {
                                      pustDataBrandFireStore(image!,
                                          _controllerName.text.toUpperCase());
                                      showLoading(4);
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
}
