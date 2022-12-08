import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_app_fluter/modal/receipt.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:my_app_fluter/utils/showToast.dart';
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

  final List<String> items = [
    'Thống Kê Trong Ngày',
    'Thống Kê Trong 7 Ngày',
    'Thống Kê Trong 30 Ngày',
  ];
  String? selectedValue;
  String? valueName;
  final _controllerDate = TextEditingController();
  final _controllerDate1 = TextEditingController();
  List<Receipt> list1 = [];
  int dateFormat = int.parse(DateFormat('yyyyMMdd').format(DateTime.now()));
  double tong = 0;

  List<ChartData> dataColumn = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onClick(dateFormat: dateFormat);
    valueName = items[0];
  }

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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomDropdownButton2(
                  hint: items[0],
                  buttonWidth: double.infinity,
                  buttonHeight: 60,
                  buttonPadding: const EdgeInsets.symmetric(horizontal: 20),
                  dropdownWidth: MediaQuery.of(context).size.width * 0.9,
                  dropdownItems: items,
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                      valueName = value;
                      if (value == items[0]) {
                        onClick(dateFormat: dateFormat);
                      } else if (value == items[1]) {
                        onClick(
                            dateFormat: dateFormat - 7,
                            dateFormat1: dateFormat);
                      } else {
                        onClick(
                            dateFormat: dateFormat - 30,
                            dateFormat1: dateFormat);
                      }
                    });
                  },
                ),
              ),
              Form(
                key: navKey1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: day1(),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: day2(),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.recycle,
                            size: 32,
                          ),
                          onPressed: () {
                            if (navKey1.currentState!.validate()) {
                              setState(() {
                                valueName =
                                    'Doanh Thu Từ ${_controllerDate.text} / ${_controllerDate1.text}';
                              });
                              onClick(
                                  dateFormat: int.parse(
                                      _controllerDate.text.replaceAll('-', '')),
                                  dateFormat1: int.parse(_controllerDate1.text
                                      .replaceAll('-', '')));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${valueName ?? 'Thống Kê Trong Ngày'}: \$${tong.toStringAsFixed(4)}',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                width: double.infinity,
                height: 500,
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(top: 100),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: [
                    StackedColumnSeries(
                        color: const Color.fromARGB(255, 105, 213, 193),
                        borderRadius: BorderRadius.circular(20),
                        dataSource: dataColumn,
                        // xValueMapper: (ChartData ch, _) =>
                        //     "\$" + ch.xval!.toStringAsFixed(4),
                        xValueMapper: (ChartData ch, _) => ch.xval,
                        yValueMapper: (ChartData ch, _) => ch.yval)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onClick({int? dateFormat, int? dateFormat1}) {
    // String dateNow = DateFormat('dd-MM-yyyy').format(DateTime.now());
    // int dateFormat = int.parse(DateFormat('yyyyMMdd').format(DateTime.now()));
    log(_auth.currentUser!.uid);
    _receipt
        .doc(_auth.currentUser!.uid)
        .collection('receipt')
        .where('filterDate',
            isGreaterThanOrEqualTo: dateFormat,
            isLessThanOrEqualTo: dateFormat1)
        .snapshots()
        .listen((data) {
      list1.clear();
      for (int i = 0; i < data.docs.length; i++) {
        var item = Receipt.fromMap(data.docs[i].data());
        list1.add(item);
        log(list1[i].mahoadon.toString());
      }
      tong = 0;
      var a;
      for (int i = 0; i < list1.length; i++) {
        tong += list1[i].tongtien!;

        a = ChartData(xval: valueName, yval: tong);
        log(tong.toString());
        setState(() {
          tong = tong;
        });
      }
      if (a == null) {
        showToast('Không Có Dữ Liệu', Colors.red);
        return;
      }
      dataColumn.add(a);
    });
  }

  Widget day1() => TextFormField(
        style: const TextStyle(fontSize: 14),
        readOnly: true,
        onTap: () async {
          DateTime? pickDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1970),
              lastDate: DateTime(2100));
          if (pickDate != null) {
            setState(() {
              _controllerDate.text = DateFormat('yyyy-MM-dd').format(pickDate);
            });
          }
        },
        controller: _controllerDate,
        validator: (value) {
          if (value!.isEmpty) {
            return "Không Bỏ Trống ";
          }

          return null;
        },
        decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 245, 245, 245),
            prefixIcon: Icon(
              FontAwesomeIcons.calendarDays,
              size: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            labelText: 'Day Start',
            labelStyle: TextStyle(fontSize: 12)),
      );
  Widget day2() => TextFormField(
        style: const TextStyle(fontSize: 14),
        readOnly: true,
        onTap: () async {
          DateTime? pickDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1970),
              lastDate: DateTime(2100));
          if (pickDate != null) {
            setState(() {
              _controllerDate1.text = DateFormat('yyyy-MM-dd').format(pickDate);
            });
          }
        },
        controller: _controllerDate1,
        validator: (value) {
          if (value!.isEmpty) {
            return "Không Bỏ Trống ";
          }

          return null;
        },
        decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 245, 245, 245),
            prefixIcon: Icon(
              FontAwesomeIcons.calendarDays,
              size: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            labelText: 'Day End',
            labelStyle: TextStyle(fontSize: 12)),
      );
}

class ChartData {
  ChartData({this.xval, this.yval});
  final String? xval;
  final double? yval;
}
