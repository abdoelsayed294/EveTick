import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/home/data/data_sources/home_data_source.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';

class HomeRepo {
  final HomeDataSource dataSource;

  HomeRepo(this.dataSource);

  Future<Result<List<HomeEvent>>> getLiveEvents() => dataSource.getLiveEvents();

  Future<Result<Set<String>>> getFavoriteIds() => dataSource.getFavoriteIds();

  Future<Result<void>> setFavorite(String eventId, {required bool isFavorite}) {
    return dataSource.setFavorite(eventId, isFavorite: isFavorite);
  }
}
