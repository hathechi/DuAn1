import 'dart:convert';

import 'package:my_app_fluter/modal/product.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Cart {
  String? idsanpham;
  String? tensp;
  String? mausp;
  String? kichcosp;
  int slsp;
  double? giasp;
  String? urlImage;
  String? thuonghieusp;
  double? tongtien;
  Cart({
    this.idsanpham,
    this.tensp,
    this.mausp,
    this.kichcosp,
    required this.slsp,
    this.giasp,
    this.urlImage,
    this.thuonghieusp,
    this.tongtien,
  });

  Cart copyWith({
    String? idsanpham,
    String? tensp,
    String? mausp,
    String? kichcosp,
    int? slsp,
    double? giasp,
    String? urlImage,
    String? thuonghieusp,
    double? tongtien,
  }) {
    return Cart(
      idsanpham: idsanpham ?? this.idsanpham,
      tensp: tensp ?? this.tensp,
      mausp: mausp ?? this.mausp,
      kichcosp: kichcosp ?? this.kichcosp,
      slsp: slsp ?? this.slsp,
      giasp: giasp ?? this.giasp,
      urlImage: urlImage ?? this.urlImage,
      thuonghieusp: thuonghieusp ?? this.thuonghieusp,
      tongtien: tongtien ?? this.tongtien,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idsanpham': idsanpham,
      'tensp': tensp,
      'mausp': mausp,
      'kichcosp': kichcosp,
      'slsp': slsp,
      'giasp': giasp,
      'urlImage': urlImage,
      'thuonghieusp': thuonghieusp,
      'tongtien': tongtien,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      idsanpham: map['idsanpham'] != null ? map['idsanpham'] as String : null,
      tensp: map['tensp'] != null ? map['tensp'] as String : null,
      mausp: map['mausp'] != null ? map['mausp'] as String : null,
      kichcosp: map['kichcosp'] != null ? map['kichcosp'] as String : null,
      slsp: map['slsp'] as int,
      giasp: map['giasp'] != null ? map['giasp'] as double : null,
      urlImage: map['urlImage'] != null ? map['urlImage'] as String : null,
      thuonghieusp:
          map['thuonghieusp'] != null ? map['thuonghieusp'] as String : null,
      tongtien: map['tongtien'] != null
          ? double.tryParse(map['tongtien'].toString())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) =>
      Cart.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Cart(idsanpham: $idsanpham, tensp: $tensp, mausp: $mausp, kichcosp: $kichcosp, slsp: $slsp, giasp: $giasp, urlImage: $urlImage, thuonghieusp: $thuonghieusp, tongtien: $tongtien)';
  }

  @override
  bool operator ==(covariant Cart other) {
    if (identical(this, other)) return true;

    return other.idsanpham == idsanpham &&
        other.tensp == tensp &&
        other.mausp == mausp &&
        other.kichcosp == kichcosp &&
        other.slsp == slsp &&
        other.giasp == giasp &&
        other.urlImage == urlImage &&
        other.thuonghieusp == thuonghieusp &&
        other.tongtien == tongtien;
  }

  @override
  int get hashCode {
    return idsanpham.hashCode ^
        tensp.hashCode ^
        mausp.hashCode ^
        kichcosp.hashCode ^
        slsp.hashCode ^
        giasp.hashCode ^
        urlImage.hashCode ^
        thuonghieusp.hashCode ^
        tongtien.hashCode;
  }
}
