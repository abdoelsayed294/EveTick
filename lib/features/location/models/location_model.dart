class LocationModel {
  final String city;
  final String country;

  LocationModel({required this.city, required this.country});

  Map<String, dynamic> toJson() {
    return {'city': city, 'country': country};
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      city: json['city'] ?? '',
      country: json['country'] ?? '',
    );
  }

  bool get isEmpty => city.isEmpty || country.isEmpty;
}
