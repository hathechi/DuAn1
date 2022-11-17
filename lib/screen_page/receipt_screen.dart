import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/modal/receipt.dart';
import 'package:my_app_fluter/screen_page/receipt_detail_screen.dart';
import 'package:my_app_fluter/utils/push_screen.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final CollectionReference _receipt =
      FirebaseFirestore.instance.collection('receipt');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Receipt> listReceipt = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Receipt',
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
          child: StreamBuilder(
            stream: _receipt
                .doc(_auth.currentUser!.uid)
                .collection('receipt')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                listReceipt.clear();
                for (var element in streamSnapshot.data!.docs) {
                  var _item = Receipt.fromMap(
                    (element.data() as Map<String, dynamic>),
                  );
                  listReceipt.add(_item);
                }
                // log(listReceipt[0].toString());
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listReceipt.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        pushScreen(context,
                            ReceiptDetail(receipt: listReceipt[index]));
                      },
                      child: Container(
                        height: 100,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 226, 226, 226),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const CircleAvatar(
                              radius: 36,
                              backgroundColor: Colors.black,
                              child: Icon(
                                FontAwesomeIcons.truckFast,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text('Code Bill:'),
                                      Text('Date created:'),
                                      Text('Total Price:'),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        listReceipt[index].mahoadon!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        listReceipt[index].ngaytaohd!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        '\$${listReceipt[index].tongtien!.toStringAsFixed(3)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return const Card();
            },
          ),
        ),
      ),
    );
  }
}
