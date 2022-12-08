// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:my_app_fluter/modal/cart.dart';
import 'package:my_app_fluter/screen_page/check_out_screen.dart';
import 'package:my_app_fluter/utils/push_screen.dart';
import 'package:my_app_fluter/utils/showToast.dart';

class GoogleMapPicker extends StatefulWidget {
  List<Cart> listCart = [];
  GoogleMapPicker({super.key, required this.listCart});

  @override
  State<GoogleMapPicker> createState() => _GoogleMapPickerState();
}

class _GoogleMapPickerState extends State<GoogleMapPicker> {
  final Completer<GoogleMapController> _controller = Completer();
  // ignore: prefer_const_constructors
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: const LatLng(12.679519, 108.044521),
    zoom: 18,
  );
  List<Discount> listDiscount = [
    Discount(phantramgiam: '25', checkbox: false),
    Discount(phantramgiam: '20', checkbox: false),
    Discount(phantramgiam: '15', checkbox: false),
    Discount(phantramgiam: '10', checkbox: false),
    Discount(phantramgiam: '5', checkbox: false)
  ];
  double? longitude;
  double? latitude;
  bool valueCheckbox = true;
  final _controllerMaps = TextEditingController();
  Future<Position> getLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      log(error.toString());
    });
    return Geolocator.getCurrentPosition();
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
          'Address',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onCameraMove: (position) {
                    latitude = position.target.latitude;
                    longitude = position.target.longitude;
                  },
                ),
                const Center(
                  child: Icon(
                    Icons.location_pin,
                    color: Color.fromARGB(255, 232, 15, 0),
                    size: 40,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 50,
                  right: 50,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                    child: TextFormField(
                      controller: _controllerMaps,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Is not empty!";
                        }

                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 14, 14, 14),
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          FontAwesomeIcons.locationDot,
                          size: 18,
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        labelText: 'Andress',
                        labelStyle:
                            TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 70,
                  left: 70,
                  child: Container(
                    height: 56,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                        icon: const Icon(FontAwesomeIcons.location),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            elevation: 8,
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(130)))),
                        onPressed: () {
                          getLocation().then((value) async {
                            longitude = value.longitude;
                            latitude = value.latitude;
                            log(latitude.toString() +
                                "chi" +
                                longitude.toString());

                            List<Placemark> placemarks =
                                await placemarkFromCoordinates(
                                    latitude!, longitude!);
                            for (int i = 0; i < placemarks.length; i++) {
                              log("placemarks " + placemarks[i].toString());
                            }

                            _controllerMaps.text =
                                placemarks[placemarks.length - 1].street! +
                                    ", " +
                                    placemarks[placemarks.length - 1].locality!;
                          });
                        },
                        label: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'CHOOCE LOCATION',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 216, 216, 216),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ListView.builder(
                  itemCount: listDiscount.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (_controllerMaps.text.trim() == '') {
                          showToast('Chưa Chọn Địa Chỉ', Colors.red);
                          return;
                        }
                        pushScreen(
                          context,
                          CheckOut(
                            address: _controllerMaps.text,
                            listCart: widget.listCart,
                            phantramgiam: listDiscount[index].phantramgiam,
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
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
                                    FontAwesomeIcons.ticket,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Special ${listDiscount[index].phantramgiam}% OFF',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: const Text(
                                        'Special promo only today! '),
                                  ),
                                ],
                              ),
                            ),
                            // Expanded(
                            //   flex: 1,
                            //   child: Checkbox(
                            //     value: listDiscount[index].checkbox,
                            //     onChanged: (value) {
                            //       setState(() {
                            //         listDiscount[index].checkbox = value;
                            //       });
                            //     },
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(FontAwesomeIcons.chevronRight),
        onPressed: () {
          if (_controllerMaps.text.trim() == '') {
            showToast('Chưa Chọn Địa Chỉ', Colors.red);
            return;
          }
          showToast('Chọn Phiếu Giảm Giá Mà Bạn Có', Colors.orange);
        },
      ),
    );
  }
}

class Discount {
  String? phantramgiam;
  bool? checkbox;
  Discount({
    this.phantramgiam,
    this.checkbox,
  });
}
