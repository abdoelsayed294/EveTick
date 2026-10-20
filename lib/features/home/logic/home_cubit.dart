import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/data/repo/home_repo.dart';
import 'package:evetick/features/home/logic/home_data.dart';
import 'package:evetick/features/home/logic/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit(this.homeRepo) : super(const HomeState.initial());

  HomeData _data = const HomeData();

  Future<void> load({bool silent = false}) async {
    if (!silent) {
      _data = const HomeData();
      emit(const HomeState.loading());
    }

    final eventsResult = await homeRepo.getLiveEvents();
    final favoritesResult = await homeRepo.getFavoriteIds();

    if (isClosed) return;

    final favorites = favoritesResult.when(
      success: (ids) => ids,
      failure: (_) => _data.favoriteIds,
    );

    eventsResult.when(
      success: (events) {
        _emitData(
          _data.copyWith(
            events: _upcomingSorted(events),
            favoriteIds: favorites,
          ),
        );
      },
      failure: (failure) {
        if (silent && _data.events.isNotEmpty) return;
        emit(HomeState.error(error: failure.message));
      },
    );
  }

  void selectCategory(String? category) {
    _emitData(
      category == null
          ? _data.copyWith(clearCategory: true)
          : _data.copyWith(selectedCategory: category),
    );
  }

  void search(String query) => _emitData(_data.copyWith(searchQuery: query));

  Future<void> toggleFavorite(String eventId) async {
    final wasFavorite = _data.favoriteIds.contains(eventId);
    final updated = Set<String>.of(_data.favoriteIds);
    wasFavorite ? updated.remove(eventId) : updated.add(eventId);
    _emitData(_data.copyWith(favoriteIds: updated));

    final result = await homeRepo.setFavorite(eventId, isFavorite: !wasFavorite);
    if (isClosed) return;
    result.when(
      success: (_) {},
      failure: (_) {
        final rollback = Set<String>.of(_data.favoriteIds);
        wasFavorite ? rollback.add(eventId) : rollback.remove(eventId);
        _emitData(_data.copyWith(favoriteIds: rollback));
      },
    );
  }

  void _emitData(HomeData data) {
    _data = data;
    emit(HomeState.success(_data));
  }

  List<HomeEvent> _upcomingSorted(List<HomeEvent> events) {
    final now = DateTime.now();
    final upcoming = events.where((e) {
      final end = e.endDate ?? e.startDate;
      return end == null || !end.isBefore(now);
    }).toList();

    upcoming.sort((a, b) {
      final aDate = a.startDate;
      final bDate = b.startDate;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return aDate.compareTo(bDate);
    });
    return upcoming;
  }
}
