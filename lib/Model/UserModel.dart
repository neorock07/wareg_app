class UserModel{
  
  int? id;

  UserModel({required this.id});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }


}