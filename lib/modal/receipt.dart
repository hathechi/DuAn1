// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:my_app_fluter/modal/cart.dart';

class Receipt {
  String? mahoadon;
  String? userId;
  String? ngaytaohd;
  int? filterDate;
  double? tongtien;
  String? address;
  String? phoneNumber;
  String? nguoinhan;
  bool? status;
  List<Cart>? listCart;
  Receipt({
    this.mahoadon,
    this.userId,
    this.ngaytaohd,
    this.filterDate,
    this.tongtien,
    this.address,
    this.phoneNumber,
    this.nguoinhan,
    this.status = false,
    this.listCart,
  });

  Receipt copyWith({
    String? mahoadon,
    String? userId,
    String? ngaytaohd,
    int? filterDate,
    double? tongtien,
    String? address,
    String? phoneNumber,
    String? nguoinhan,
    bool? status,
    List<Cart>? listCart,
  }) {
    return Receipt(
      mahoadon: mahoadon ?? this.mahoadon,
      userId: userId ?? this.userId,
      ngaytaohd: ngaytaohd ?? this.ngaytaohd,
      filterDate: filterDate ?? this.filterDate,
      tongtien: tongtien ?? this.tongtien,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nguoinhan: nguoinhan ?? this.nguoinhan,
      status: status ?? this.status,
      listCart: listCart ?? this.listCart,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mahoadon': mahoadon,
      'userId': userId,
      'ngaytaohd': ngaytaohd,
      'filterDate': filterDate,
      'tongtien': tongtien,
      'address': address,
      'phoneNumber': phoneNumber,
      'nguoinhan': nguoinhan,
      'status': status,
      'listCart': listCart!.map((x) => x.toMap()).toList(),
    };
  }

  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
      mahoadon: map['mahoadon'] != null ? map['mahoadon'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      ngaytaohd: map['ngaytaohd'] != null ? map['ngaytaohd'] as String : null,
      filterDate: map['filterDate'] != null ? map['filterDate'] as int : null,
      tongtien: map['tongtien'] != null ? map['tongtien'] as double : null,
      address: map['address'] != null ? map['address'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      nguoinhan: map['nguoinhan'] != null ? map['nguoinhan'] as String : null,
      status: map['status'] != null ? map['status'] as bool : null,
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
    return 'Receipt(mahoadon: $mahoadon, userId: $userId, ngaytaohd: $ngaytaohd, filterDate: $filterDate, tongtien: $tongtien, address: $address, phoneNumber: $phoneNumber, nguoinhan: $nguoinhan, status: $status, listCart: $listCart)';
  }

  @override
  bool operator ==(covariant Receipt other) {
    if (identical(this, other)) return true;

    return other.mahoadon == mahoadon &&
        other.userId == userId &&
        other.ngaytaohd == ngaytaohd &&
        other.filterDate == filterDate &&
        other.tongtien == tongtien &&
        other.address == address &&
        other.phoneNumber == phoneNumber &&
        other.nguoinhan == nguoinhan &&
        other.status == status &&
        listEquals(other.listCart, listCart);
  }

  @override
  int get hashCode {
    return mahoadon.hashCode ^
        userId.hashCode ^
        ngaytaohd.hashCode ^
        filterDate.hashCode ^
        tongtien.hashCode ^
        address.hashCode ^
        phoneNumber.hashCode ^
        nguoinhan.hashCode ^
        status.hashCode ^
        listCart.hashCode;
  }
}
