import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app_fluter/modal/receipt.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  //Đường dẫn
  final CollectionReference _receipt =
      FirebaseFirestore.instance.collection('receipt');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<_PieData> pieData = [
    _PieData('Jan', 35, 'Abc'),
    _PieData('Jan', 50, 'Abc'),
    _PieData('Jan', 70, 'Abc'),
    _PieData('Jan', 35, 'Abc'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Statistics",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  onClick();
                },
                child: Text('Click')),
            SfCartesianChart(
                // Initialize category axis
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<SalesData, String>>[
                  LineSeries<SalesData, String>(
                      // Bind data source
                      dataSource: <SalesData>[
                        SalesData('Jan', 100),
                        SalesData('Feb', 28),
                        SalesData('Mar', 34),
                        SalesData('Apr', 32),
                        SalesData('May', 40)
                      ],
                      xValueMapper: (SalesData sales, _) => sales.year,
                      yValueMapper: (SalesData sales, _) => sales.sales)
                ]),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  //Initialize the spark charts widget
                  child: SfCircularChart(
                      title: ChartTitle(text: 'Sales by sales person'),
                      legend: Legend(isVisible: true),
                      series: <PieSeries<_PieData, String>>[
                        PieSeries<_PieData, String>(
                            explode: true,
                            explodeIndex: 0,
                            dataSource: pieData,
                            xValueMapper: (_PieData data, _) => data.xData,
                            yValueMapper: (_PieData data, _) => data.yData,
                            dataLabelMapper: (_PieData data, _) => data.text,
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true)),
                      ])),
            ),
          ],
        ),
      ),
    );
  }

  void onClick() {
    List<Receipt> list1 = [];
    List<Receipt> list2 = [];
    List<Receipt> list3 = [];
    log(_auth.currentUser!.uid);
    _receipt
        .doc(_auth.currentUser!.uid)
        .collection('receipt')
        .where('ngaytaohd', isGreaterThanOrEqualTo: '19/11/2022')
        // .where('ngaytaohd', isLessThanOrEqualTo: '19/11/2022')
        .snapshots()
        .listen((data) {
      for (var element in data.docs) {
        var _item = Receipt.fromMap(
          (element.data()),
        );
        list1.add(_item);
        // log(list1.toString());
      }
      // for (int i = 0; i < data.docs.length; i++) {
      //   log('grower ${data.docs[i]['mahoadon']}');
      //   list1.add(data.docs[i]);
      // }
    });
    _receipt
        .doc(_auth.currentUser!.uid)
        .collection('receipt')
        // .where('ngaytaohd', isGreaterThanOrEqualTo: '18/11/2022')
        .where('ngaytaohd', isLessThanOrEqualTo: '20/11/2022')
        .snapshots()
        .listen((data) {
      for (var element in data.docs) {
        var _item = Receipt.fromMap(
          (element.data()),
        );
        list2.add(_item);
        // log(list2.toString());
      }
      // list3.clear();
      for (int i = 0; i < list1.length; i++) {
        if (list1[i].ngaytaohd == list2[i].ngaytaohd) {
          list3.add(list1[i]);
          log(list3[i].toString());
        }
      }
    });
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class _PieData {
  _PieData(this.xData, this.yData, this.text);
  final String xData;
  final num yData;
  final String text;
}
