import 'dart:convert';

class Product {
  String? tensp;
  double? giasp;
  String? chitietsp;
  String? thuonghieusp;
  String? urlImage;
  bool? like;
  int? slnhap;
  String? masp;

  Product(
      {this.tensp,
      this.giasp,
      this.chitietsp,
      this.thuonghieusp,
      this.urlImage,
      this.like = false,
      this.slnhap,
      this.masp});

  Product.fromJson(Map<String, dynamic> json) {
    tensp = json['tensp'];
    giasp = json['giasp'];
    chitietsp = json['chitietsp'];
    thuonghieusp = json['thuonghieusp'];
    urlImage = json['urlImage'];
    like = json['like'];
    slnhap = json['slnhap'];
    masp = json['masp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['tensp'] = this.tensp;
    data['giasp'] = this.giasp;
    data['chitietsp'] = this.chitietsp;
    data['thuonghieusp'] = this.thuonghieusp;
    data['urlImage'] = this.urlImage;
    data['like'] = this.like;
    data['slnhap'] = this.slnhap;
    data['masp'] = this.masp;
    return data;
  }
}
