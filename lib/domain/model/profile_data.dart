import 'dart:convert';

UserAllDataModel userAllDataModelFromJson(String str) => UserAllDataModel.fromJson(json.decode(str));

String userAllDataModelToJson(UserAllDataModel data) => json.encode(data.toJson());

class UserAllDataModel {
  UserAllDataModel({
    this.id,
    this.name,
    this.surname,
    this.region,
    this.business,
    this.marriage,
    this.image,
    this.imageX,
    this.numberHide,
    this.about,
  });

  int? id;
  String? name;
  String? surname;
  int? region;
  int? business;
  String? marriage;
  String? image;
  String? imageX;
  bool? numberHide;
  String? about;

  factory UserAllDataModel.fromJson(Map<String, dynamic> json) => UserAllDataModel(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
        region: json["region"],
        business: json["business"],
        marriage: json["marriage"],
        image: json["image"],
        imageX: json["imagex"],
        numberHide: json["number_hide"],
        about: json["about"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
        "region": region,
        "business": business,
        "marriage": marriage,
        "image": image,
        "imagex": imageX,
        "number_hide": numberHide,
        "about": about,
      };
}
