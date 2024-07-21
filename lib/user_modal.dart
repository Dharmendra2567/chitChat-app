class UserModel {
  String uid;
  String username;
  String email;

  UserModel({
    required this.uid,
    required this.username,
    required this.email});

  Map<String, dynamic> toJson() {
    return {
      'uid':uid,
      'username': username,
      'email': email,
    };
  }
}
