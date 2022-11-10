import 'dart:convert';

class Brand {
  String? tenthuonghieu;
  String? urlImage;
  String? idthuonghieu;

  Brand({this.tenthuonghieu, this.urlImage, this.idthuonghieu});

  Brand.fromJson(Map<String, dynamic> json) {
    tenthuonghieu = json['tenthuonghieu'];
    urlImage = json['urlImage'];
    idthuonghieu = json['idthuonghieu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['tenthuonghieu'] = this.tenthuonghieu;
    data['urlImage'] = this.urlImage;
    data['idthuonghieu'] = this.idthuonghieu;

    return data;
  }
}
