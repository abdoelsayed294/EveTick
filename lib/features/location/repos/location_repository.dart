import 'package:evetick/features/location/models/location_model.dart';

abstract class LocationRepository {
  Future<LocationModel> getCurrentLocation();
  Future<LocationModel?> getSavedLocation();
  Future<void> saveLocation(LocationModel location);
  Future<List<String>> getGovernorates();
  Future<void> skipLocation();
}
