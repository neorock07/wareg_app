import 'dart:convert';

import 'package:wareg_app/Model/PostFoodModel.dart';

class PostDetail {
  final int id;
  final String title;
  final String alamat;
  final String deskripsi;
  final String coordinate;
  final String createdAt;
  final String updatedAt;
  final String expiredAt;
  final String distance;
  final int stok;
  final String userName;
  final int userId;
  final String userProfilePicture;
  final double? averageReview;
  final int reviewCount;
  final List<String> categories;
  final List<Variant> variants;
  final List<Media> media;

  PostDetail({
    required this.id,
    required this.title,
    required this.alamat,
    required this.deskripsi,
    required this.coordinate,
    required this.createdAt,
    required this.updatedAt,
    required this.expiredAt,
    required this.distance,
    required this.stok,
    required this.userName,
    required this.userId,
    required this.userProfilePicture,
    this.averageReview,
    required this.reviewCount,
    required this.categories,
    required this.variants,
    required this.media,
  });

  factory PostDetail.fromJson(Map<String, dynamic> json) {
    return PostDetail(
      id: json['id'],
      title: json['title'],
      alamat: json['body']['alamat'],
      deskripsi: json['body']['deskripsi'],
      coordinate: json['body']['coordinate'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      expiredAt: json['expiredAt'],
      distance: json['distance'],
      stok: json['stok'],
      userName: json['userName'],
      userId: json['userId'],
      userProfilePicture: json['userProfilePicture'],
      averageReview: json['averageReview']?.toDouble(),
      reviewCount: json['reviewCount'],
      categories: List<String>.from(json['categories']),
      variants: (json['variants'] as List)
          .map((variant) => Variant.fromJson(variant))
          .toList(),
      media: (json['media'] as List)
          .map((mediaItem) => Media.fromJson(mediaItem))
          .toList(),
    );
  }
}

class Variant {
  final int id;
  final String name;
  final int stok;

  Variant({
    required this.id,
    required this.name,
    required this.stok,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      name: json['name'],
      stok: json['stok'],
    );
  }
}


