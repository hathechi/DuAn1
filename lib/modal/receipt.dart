// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:my_app_fluter/modal/cart.dart';

class Receipt {
  String? mahoadon;
  String? ngaytaohd;
  double? tongtien;
  String? address;
  String? phoneNumber;
  List<Cart>? listCart;
  Receipt({
    this.mahoadon,
    this.ngaytaohd,
    this.tongtien,
    this.address,
    this.phoneNumber,
    this.listCart,
  });

  Receipt copyWith({
    String? mahoadon,
    String? ngaytaohd,
    double? tongtien,
    String? address,
    String? phoneNumber,
    List<Cart>? listCart,
  }) {
    return Receipt(
      mahoadon: mahoadon ?? this.mahoadon,
      ngaytaohd: ngaytaohd ?? this.ngaytaohd,
      tongtien: tongtien ?? this.tongtien,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      listCart: listCart ?? this.listCart,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mahoadon': mahoadon,
      'ngaytaohd': ngaytaohd,
      'tongtien': tongtien,
      'address': address,
      'phoneNumber': phoneNumber,
      'listCart': listCart!.map((x) => x.toMap()).toList(),
    };
  }

  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
      mahoadon: map['mahoadon'] != null ? map['mahoadon'] as String : null,
      ngaytaohd: map['ngaytaohd'] != null ? map['ngaytaohd'] as String : null,
      tongtien: map['tongtien'] != null ? map['tongtien'] as double : null,
      address: map['address'] != null ? map['address'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      listCart: map['listCart'] != null
          ? List<Cart>.from(
              (map['listCart'] as List<dynamic>).map<Cart?>(
                (x) => Cart.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Receipt.fromJson(String source) =>
      Receipt.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Receipt(mahoadon: $mahoadon, ngaytaohd: $ngaytaohd, tongtien: $tongtien, address: $address, phoneNumber: $phoneNumber, listCart: $listCart)';
  }

  @override
  bool operator ==(covariant Receipt other) {
    if (identical(this, other)) return true;

    return other.mahoadon == mahoadon &&
        other.ngaytaohd == ngaytaohd &&
        other.tongtien == tongtien &&
        other.address == address &&
        other.phoneNumber == phoneNumber &&
        listEquals(other.listCart, listCart);
  }

  @override
  int get hashCode {
    return mahoadon.hashCode ^
        ngaytaohd.hashCode ^
        tongtien.hashCode ^
        address.hashCode ^
        phoneNumber.hashCode ^
        listCart.hashCode;
  }
}
