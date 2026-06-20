class AppUserModel {
  String uid;
  String email;

  AppUserModel({required this.uid, required this.email});


  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email};
  }

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(uid: json['uid'], email: json['email']);
  }
}