class VariantModel{  
  String? name;
  String? stok;
  DateTime? startAt;
  DateTime? expiredAt;

  VariantModel({
    required this.name,
    required this.stok,
    required this.startAt,
    required this.expiredAt,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      name: json['name'],
      stok: json['stok'],
      startAt: DateTime.parse(json['startAt']),
      expiredAt: DateTime.parse(json['expiredAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'stok': stok,
      'startAt': startAt?.toIso8601String(),
      'expiredAt': expiredAt?.toIso8601String(),
    };
  }

}