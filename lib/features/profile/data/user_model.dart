class UserModel {
  final String name;
  final String? imageUrl;

  UserModel({
    this.name = '',
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json, String uid) {
    return UserModel(
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }
}
