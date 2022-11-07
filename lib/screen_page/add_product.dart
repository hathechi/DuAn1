import 'dart:io';

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

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return _itemProduct(index);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openBottomSheetAdd(context, 'ADD PRODUCT');
        },
        child: const Icon(FontAwesomeIcons.plus),
      ),
    );
  }

  Widget _itemProduct(int index) {
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
                _openBottomSheetAdd(context, 'EDIT');
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
                    print("object $index");
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
                  child: Image.asset('assets/images/giay1.png'),
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
                              children: const [
                                Text(
                                  'Air Jodan 3 Retro',
                                  style: TextStyle(
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
                                  'Price: \$ $index\23.00',
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
                        child: const Text(
                          'Adidas',
                          style: TextStyle(fontSize: 12),
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
                              'Amount: $index\333',
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
                          children: const [
                            Text(
                              'Detail: Browser to find the images that fit your needs and click to download.',
                              style: TextStyle(fontSize: 12),
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
  List<String> listsDropDown = [
    "ADIDAS",
    'BITIS',
    'CONVERSE',
    'PUMA',
  ];
  final _controllerName = TextEditingController();
  final _controllerPrice = TextEditingController();
  final _controllerAmount = TextEditingController();
  final _controllerDetail = TextEditingController();
  String? selectedValue;

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
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _controllerPrice,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                    // padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: DropdownButtonFormField2(
                      buttonHeight: 60,
                      // dropdownWidth: double.infinity,
                      buttonWidth: double.infinity,
                      buttonPadding: const EdgeInsets.symmetric(horizontal: 20),
                      iconSize: 16,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.apple),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      buttonDecoration: BoxDecoration(
                        color: const Color.fromARGB(255, 240, 240, 240),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      // isExpanded: true,
                      hint: const Text(
                        'CHOOSE BRAND',
                      ),
                      // dropdownItems: listsDropDown,

                      items: listsDropDown
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _controllerAmount,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                          onPressed: () {
                            print(selectedValue);
                          },
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
