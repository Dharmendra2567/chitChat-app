class UserModel {
  String uid;
  String username;
  String email;
  String? imageUrl;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.imageUrl
  });

  Map<String, dynamic> toJson() {
    return {
      'uid':uid,
      'username': username,
      'email': email,
      'imageUrl':imageUrl,
    };
  }
}
