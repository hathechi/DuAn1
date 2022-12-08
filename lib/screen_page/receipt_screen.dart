import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/modal/receipt.dart';
import 'package:my_app_fluter/screen_page/complete_receipt_page.dart';
import 'package:my_app_fluter/screen_page/home_screen.dart';
import 'package:my_app_fluter/screen_page/receipt_detail_screen.dart';
import 'package:my_app_fluter/screen_page/unfinish_receipt_page.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  int value = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              pushAndRemoveUntil(child: HomeScreen());
            },
            icon: const Icon(FontAwesomeIcons.home),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Receipt',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: IndexedStack(index: value, children: const [
        UnfinishReceiptPage(),
        CompleteReceiptPage(),
      ]),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: value,
        onTap: (index) {
          setState(() {
            value = index;
          });
        },
        items: [
          SalomonBottomBarItem(
              icon: const Icon(FontAwesomeIcons.xmark),
              title: const Text('Unfinished'),
              selectedColor: Colors.redAccent,
              unselectedColor: const Color.fromARGB(255, 243, 135, 171)),
          SalomonBottomBarItem(
              icon: const Icon(FontAwesomeIcons.check),
              title: const Text('Complete'),
              selectedColor: Colors.green,
              unselectedColor: const Color.fromARGB(255, 87, 179, 38)),
        ],
      ),
    );
  }
}
