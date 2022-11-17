import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_app_fluter/modal/cart.dart';
import 'package:my_app_fluter/modal/receipt.dart';

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
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 236, 236, 236),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DetailBill(
                      title: 'Code Bill:', content: widget.receipt.mahoadon!),
                  DetailBill(
                      title: 'Total Price:',
                      content: widget.receipt.ngaytaohd!),
                  DetailBill(
                      title: 'Date created:',
                      content:
                          '\$' + widget.receipt.tongtien!.toStringAsFixed(3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget DetailBill({String? title, String? content}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title!),
        Text(
          content!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
