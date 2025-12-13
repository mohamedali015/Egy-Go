class UserModel {
  String? sId;
  String? email;
  String? name;
  String? phone;
  String? role;
  bool? isEmailVerified;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? lastLogin;

  UserModel(
      {this.sId,
      this.email,
      this.name,
      this.phone,
      this.role,
      this.isEmailVerified,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.lastLogin});

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    role = json['role'];
    isEmailVerified = json['isEmailVerified'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    lastLogin = json['lastLogin'];
  }
}
