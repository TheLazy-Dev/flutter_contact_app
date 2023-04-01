// To parse this JSON data, do
//
//     final contactModel = contactModelFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

ContactModel contactModelFromJson(String str) =>
    ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel {
  ContactModel({
    this.id,
    this.photo,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.address,
    this.notes,
  });

  final int? id;
  final Uint8List? photo;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? notes;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        id: json["id"],
        photo: json["photo"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        address: json["address"],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "photo": photo,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "email": email,
        "address": address,
        "notes": notes,
      };
}
