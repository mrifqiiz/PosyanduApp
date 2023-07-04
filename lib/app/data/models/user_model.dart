class UserModel {
  String? id;
  String? email;
  String? username;
  String? password;
  String? phone;

  UserModel({
    this.id,
    this.email,
    this.username,
    this.password,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "password": password,
        "phone": phone,
      };
}
