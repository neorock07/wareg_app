class AddressModel {
  int? id;
  String? provinsi;
  String? kota;
  String? kecamatan;
  String? kodePos;
  String? alamat;
  String? coordinate;
  DateTime? createdAt;
  DateTime? updatedAt;

  AddressModel({
    required this.id,
    required this.provinsi,
    required this.kota,
    required this.kecamatan,
    required this.kodePos,
    required this.alamat,
    required this.coordinate,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      provinsi: json['provinsi'],
      kota: json['kota'],
      kecamatan: json['kecamatan'],
      kodePos: json['kode_pos'],
      alamat: json['alamat'],
      coordinate: json['coordinate'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provinsi': provinsi,
      'kota': kota,
      'kecamatan': kecamatan,
      'kode_pos': kodePos,
      'alamat': alamat,
      'coordinate': coordinate,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
