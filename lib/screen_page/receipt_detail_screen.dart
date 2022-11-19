import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/DAO/receiptDAO.dart';
import 'package:my_app_fluter/modal/cart.dart';
import 'package:my_app_fluter/modal/receipt.dart';
import 'package:my_app_fluter/utils/showToast.dart';
import 'package:my_app_fluter/utils/show_bottom_sheet.dart';

class ReceiptDetail extends StatefulWidget {
  Receipt receipt;
  ReceiptDetail({super.key, required this.receipt});

  @override
  State<ReceiptDetail> createState() => _ReceiptDetailState();
}

class _ReceiptDetailState extends State<ReceiptDetail> {
  List<Cart> listCart = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listCart = widget.receipt.listCart!;
    // log(listCart.toString());
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
          'Receipt Detail',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 236, 236, 236),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DetailBill(
                            title: 'Code Bill:',
                            content: widget.receipt.mahoadon!),
                        DetailBill(
                            title: 'Date created:',
                            content: widget.receipt.ngaytaohd!),
                        DetailBill(
                            title: 'Phone Number:',
                            content: widget.receipt.phoneNumber!),
                        DetailBill(
                            title: 'Name:', content: widget.receipt.nguoinhan!),
                        DetailBill(
                            title: 'Address:',
                            content: widget.receipt.address!),
                        DetailBill(
                            title: 'Total Price:',
                            content: '\$' +
                                widget.receipt.tongtien!.toStringAsFixed(3)),
                        DetailBill(
                            title: 'Status:',
                            content: !widget.receipt.status!
                                ? 'Chưa Hoàn Thành'
                                : 'Đã Hoàn Thành'),
                      ],
                    ),
                  ),
                  Container(
                    child: Image.asset('assets/images/giaohang.jpeg'),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listCart.length,
                          itemBuilder: (context, index) {
                            return _itemCart(index);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !widget.receipt.status!,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 176, 176, 176),
                    offset: Offset(0.0, 1), //(x,y)
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 228, 228, 228),
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(130)))),
                        onPressed: () {
                          dialogModalBottomsheet(context, 'Return and Refund',
                              () => deleteReceipt(context, widget.receipt));
                        },
                        label: const Text(
                          'Return and Refund',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        icon: const Icon(
                          FontAwesomeIcons.rightLeft,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(130)))),
                        onPressed: () {
                          widget.receipt.status = true;
                          dialogModalBottomsheet(context, 'Complete Your Order',
                              () => updateReceipt(context, widget.receipt));
                        },
                        label: const Text(
                          'Complete Your Order',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(FontAwesomeIcons.check),
                      ),
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
                listCart[index].urlImage!,
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
                              listCart[index].tensp!,
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
                          listCart[index].slsp.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${listCart[index].mausp!}  |  Size = ${listCart[index].kichcosp!}',
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

  Widget DetailBill({String? title, String? content}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(title!),
        ),
        const SizedBox(
          width: 40,
        ),
        Expanded(
          flex: 3,
          child: Wrap(
            children: [
              Text(
                content!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
