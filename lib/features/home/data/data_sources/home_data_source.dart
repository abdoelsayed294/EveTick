import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';

abstract class HomeDataSource {
  Future<Result<List<HomeEvent>>> getLiveEvents();

  Future<Result<Set<String>>> getFavoriteIds();

  Future<Result<void>> setFavorite(String eventId, {required bool isFavorite});
}
