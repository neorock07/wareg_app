import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wareg_app/Model/PostFoodModel.dart';

class PostDetail {
  final int id;
  final String title;
  final Body body;
  final String createdAt;
  final String updatedAt;
  final String expiredAt;
  final String distance;
  final int stok;
  final int userId;
  final String userName;
  final String userProfilePicture;
  final double averageReview;
  final List<Media> media;
  List<String>? categories;
  List<Variants>? variants;
  int? reviewCount;
  var transaction;

  PostDetail({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    required this.expiredAt,
    required this.distance,
    required this.stok,
    required this.userId,
    required this.userName,
    required this.userProfilePicture,
    required this.averageReview,
    required this.media,
    this.categories,
    this.variants,
    this.reviewCount,
    this.transaction
  });

  factory PostDetail.fromJson(Map<String, dynamic> json) {
    var mediaList = json['media'] as List;
    List<Media> media = mediaList.map((i) => Media.fromJson(i)).toList();
    
    var varianList = (json['variants'] == null)? [] : json['variants'] as List;
    List<Variants> varian = varianList.map((i) => Variants.fromJson(i)).toList();

    return PostDetail(
      id: json['id'],
      title: json['title'],
      body: Body.fromJson(json['body']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      expiredAt: json['expiredAt'],
      distance: json['distance'],
      stok: json['stok'],
      userId: json['userId'],
      userName: json['userName'],
      userProfilePicture: json['userProfilePicture'],
      averageReview: (json['averageReview'] == null) ? 0 : json['averageReview'].toDouble(),
      media: media,
      reviewCount: (json['reviewCount'] == null) ? 0 : json['reviewCount'],
      variants: varian,
      transaction: json['transaction'],
      categories: (json['categories'] == null)? [] : json['categories'][0],
    );
  }
}


class Variants {
  final String id;
  final String name;
  final String stok;

  Variants({
    required this.id,
    required this.name,
    required this.stok,
  });

  factory Variants.fromJson(Map<String, dynamic> json) {
    return Variants(
      id: json['id'],
      name: json['name'],
      stok: json['stok'],
    );
  }
}

