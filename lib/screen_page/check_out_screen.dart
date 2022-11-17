import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/modal/cart.dart';
import 'package:my_app_fluter/screen_page/chooce_payment_screen.dart';
import 'package:my_app_fluter/utils/push_screen.dart';

class CheckOut extends StatefulWidget {
  String? address;
  List<Cart> listCart = [];
  String? phantramgiam;

  CheckOut(
      {super.key,
      this.address,
      required this.listCart,
      required this.phantramgiam});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  double totalPrice = 0;
  double? tongtien;
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < widget.listCart.length; i++) {
      totalPrice += widget.listCart[i].tongtien!;
    }

    tongtien =
        (totalPrice - ((int.parse(widget.phantramgiam!) / 100) * totalPrice));
    log(tongtien.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Check Out',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: navKey1,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Shipping Address',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  // margin: const EdgeInsets.all(10),
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 228, 227, 227),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 30,
                            child: Icon(
                              FontAwesomeIcons.locationDot,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListTile(
                              title: Text(
                                widget.address ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Phone number',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                inputPhoneNumber(),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Order List',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.listCart.length,
                    itemBuilder: (context, index) {
                      return _itemCart(index);
                    },
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 237, 237, 237),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Amount',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "\$" + totalPrice.toString(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Promo',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              '-${widget.phantramgiam}%',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            '\$' +
                                (totalPrice -
                                        ((int.parse(widget.phantramgiam!) /
                                                100) *
                                            totalPrice))
                                    .toStringAsFixed(3)
                                    .toString(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            elevation: 8,
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(130)))),
                        onPressed: () {
                          if (navKey1.currentState!.validate()) {
                            pushScreen(
                              context,
                              ChoocePayMent(
                                listCart: widget.listCart,
                                tongtien: tongtien!,
                                phoneNumber: _phoneNumberController.text,
                                address: widget.address!,
                              ),
                            );
                          }
                        },
                        label: const Text(
                          'Continue to Payment',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(
                          FontAwesomeIcons.chevronRight,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemCart(index) {
    return Container(
      height: 150,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Color.fromARGB(255, 226, 235, 247),
      ),
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
                widget.listCart[index].urlImage!,
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
                        child: Wrap(
                          children: [
                            Text(
                              widget.listCart[index].tensp!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black,
                        child: Text(
                          widget.listCart[index].slsp.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${widget.listCart[index].mausp!}  |  Size = ${widget.listCart[index].kichcosp!}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget inputPhoneNumber() => Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextFormField(
        maxLength: 10,
        keyboardType: TextInputType.number,
        controller: _phoneNumberController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.isEmpty) {
            return "Không Bỏ Trống Số Điện Thoại";
          }
          if (!RegExp(r"^[[0-9]").hasMatch(value)) {
            return "Nhập Đúng Định Dạng Số";
          }
          return null;
        },
        decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 245, 245, 245),
            prefixIcon: Icon(
              Icons.phone,
              size: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            labelText: 'Phone Number',
            labelStyle: TextStyle(fontSize: 12)),
      ));
}
