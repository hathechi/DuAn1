import 'dart:io';
import 'dart:ui';

import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app_fluter/utils/show_bottom_sheet.dart';

class AddBrand extends StatefulWidget {
  const AddBrand({super.key});

  @override
  State<AddBrand> createState() => _AddBrandState();
}

class _AddBrandState extends State<AddBrand> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        alignment: Alignment.center,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisExtent: 210),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 14,
            itemBuilder: (context, index) {
              return _itemBrand(index);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openBottomSheetAdd(context, 'ADD BRAND');
        },
        child: const Icon(FontAwesomeIcons.plus),
      ),
    );
  }

  Widget _itemBrand(int index) {
    return InkWell(
      onLongPress: () {
        _openBottomSheetAdd(context, 'EDIT');
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
                      print("object");
                      Navigator.of(_scaffoldKey.currentContext!).pop();
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
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  margin: const EdgeInsets.only(bottom: 5),
                  child: index % 2 == 0
                      ? Image.asset(
                          'assets/images/nike-logo.png',
                        )
                      : Image.asset(
                          'assets/images/puma.png',
                        ),
                ),
                Wrap(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Converse",
                        style: TextStyle(
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

void _openBottomSheetAdd(BuildContext context, String title) {
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
      );
    },
  );
}

class bottomAdd extends StatefulWidget {
  final String title;

  const bottomAdd({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  State<bottomAdd> createState() => _bottomAddState();
}

class _bottomAddState extends State<bottomAdd> {
  final _controllerName = TextEditingController();

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
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          // height: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: TextFormField(
                      controller: _controllerName,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                            borderRadius: const BorderRadiusDirectional.all(
                                Radius.circular(100)),
                            child: image != null
                                ? Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                    width: 200,
                                    height: 200,
                                  )
                                : Image.asset(
                                    "assets/images/nike-logo.png",
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
                                  borderRadius: BorderRadius.circular(130)))),
                          onPressed: () {
                            Navigator.pop(context);
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
                                  borderRadius: BorderRadius.circular(130)))),
                          onPressed: () {},
                          child: Text(
                            widget.title.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
      ],
    );
  }
}
