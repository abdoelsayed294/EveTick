import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/features/location/models/location_model.dart';
import 'package:evetick/features/location/repos/location_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationRepositoryImpl implements LocationRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  LocationRepositoryImpl({required this.firestore, required this.auth});

  @override
  Future<LocationModel> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location service disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }
    Position position = await Geolocator.getCurrentPosition();

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final place = placemarks.first;
    return LocationModel(
      city: place.locality ?? '',
      country: place.country ?? '',
    );
  }

  @override
  Future<void> saveLocation(LocationModel location) async {
    final uid = auth.currentUser!.uid;

    await firestore.collection('users').doc(uid).update({
      'city': location.city,
      'country': location.country,
      'locationSkipped': false,
    });
  }

  @override
  Future<LocationModel?> getSavedLocation() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await firestore.collection('users').doc(uid).get();

    if (!doc.exists) return null;

    final data = doc.data();
    if (data?['locationSkipped'] == true) {
      return LocationModel(country: '', city: '');
    }
    if (data == null || data['city'] == null || data['country'] == null) {
      return null;
    }

    return LocationModel.fromJson(data);
  }

  @override
  Future<List<String>> getGovernorates() async {
    final jsonString = await rootBundle.loadString(
      'assets/json/egypt_governorates.json',
    );
    return List<String>.from(jsonDecode(jsonString));
  }

  @override
  Future<void> skipLocation() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'locationSkipped': true});
  }
}
