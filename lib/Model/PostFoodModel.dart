import 'package:wareg_app/Model/AddressModel.dart';
import 'package:wareg_app/Model/UserModel.dart';
import 'package:wareg_app/Model/VariantsModel.dart';

class PostFoodModel{
  
  String? title;
  String? body;
  UserModel? user;
  AddressModel? address;
  List<VariantModel>? variants;
  int? id;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

    PostFoodModel({
    required this.title,
    required this.body,
    required this.user,
    required this.address,
    required this.variants,
    required this.id,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

   factory PostFoodModel.fromJson(Map<String, dynamic> json) {
    return PostFoodModel(
      title: json['title'],
      body: json['body'],
      user: UserModel.fromJson(json['user']),
      address: AddressModel.fromJson(json['address']),
      variants: List<VariantModel>.from(json['variants'].map((x) => VariantModel.fromJson(x))),
      id: json['id'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'user': user?.toJson(),
      'address': address?.toJson(),
      'variants': List<dynamic>.from(variants!.map((x) => x.toJson())),
      'id': id,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

}