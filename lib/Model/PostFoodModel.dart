import 'dart:convert';

import 'package:flutter/material.dart';

class Post {
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

  Post({
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
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    var mediaList = json['media'] as List;
    List<Media> media = mediaList.map((i) => Media.fromJson(i)).toList();

    return Post(
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
      averageReview: (json['averageReview'] == null)
          ? 0
          : json['averageReview'].toDouble(),
      media: media,
    );
  }
}

class Body {
  final String alamat;
  final String coordinate;
  final String deskripsi;

  Body({
    required this.alamat,
    required this.coordinate,
    required this.deskripsi,
  });

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      alamat: json['alamat'],
      coordinate: json['coordinate'],
      deskripsi: json['deskripsi'],
    );
  }
}

class Media {
  final int id;
  final String url;
  final String createdAt;
  final String updatedAt;

  Media({
    required this.id,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      url: json['url'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
