// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Comment {
  String? idComment;
  String? idUser;
  String? idsanpham;
  String? name;
  String? content;
  String? urlImageAvatar;
  Comment({
    this.idComment,
    this.idUser,
    this.idsanpham,
    this.name,
    this.content,
    this.urlImageAvatar,
  });

  Comment copyWith({
    String? idComment,
    String? idUser,
    String? idsanpham,
    String? name,
    String? content,
    String? urlImageAvatar,
  }) {
    return Comment(
      idComment: idComment ?? this.idComment,
      idUser: idUser ?? this.idUser,
      idsanpham: idsanpham ?? this.idsanpham,
      name: name ?? this.name,
      content: content ?? this.content,
      urlImageAvatar: urlImageAvatar ?? this.urlImageAvatar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idComment': idComment,
      'idUser': idUser,
      'idsanpham': idsanpham,
      'name': name,
      'content': content,
      'urlImageAvatar': urlImageAvatar,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      idComment: map['idComment'] != null ? map['idComment'] as String : null,
      idUser: map['idUser'] != null ? map['idUser'] as String : null,
      idsanpham: map['idsanpham'] != null ? map['idsanpham'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      urlImageAvatar: map['urlImageAvatar'] != null
          ? map['urlImageAvatar'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(idComment: $idComment, idUser: $idUser, idsanpham: $idsanpham, name: $name, content: $content, urlImageAvatar: $urlImageAvatar)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.idComment == idComment &&
        other.idUser == idUser &&
        other.idsanpham == idsanpham &&
        other.name == name &&
        other.content == content &&
        other.urlImageAvatar == urlImageAvatar;
  }

  @override
  int get hashCode {
    return idComment.hashCode ^
        idUser.hashCode ^
        idsanpham.hashCode ^
        name.hashCode ^
        content.hashCode ^
        urlImageAvatar.hashCode;
  }
}
