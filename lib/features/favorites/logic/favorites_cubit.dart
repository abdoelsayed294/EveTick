import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/favorites/data/favorites_repository.dart';
import 'package:evetick/features/favorites/logic/favorites_state.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/data/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository repo;
  final HomeRepo homeRepo;

  FavoritesCubit(this.repo, this.homeRepo)
      : super(const FavoritesState.initial());

  List<HomeEvent> get _events =>
      state.whenOrNull(success: (data) => data as List<HomeEvent>) ?? const [];

  Future<void> load({bool silent = false}) async {
    if (!silent) emit(const FavoritesState.loading());

    final result = await repo.getFavoriteEvents();
    result.when(
      success: (events) {
        emit(FavoritesState.success(events));
      },
      failure: (failure) {
        if (silent && _events.isNotEmpty) return;
        emit(FavoritesState.error(error: failure.message));
      },
    );
  }

  Future<void> removeFavorite(String eventId) async {
    final current = _events;
    final index = current.indexWhere((e) => e.id == eventId);
    if (index < 0) return;
    final removed = current[index];

    emit(FavoritesState.success([...current]..removeAt(index)));

    final result = await homeRepo.setFavorite(eventId, isFavorite: false);
    result.when(
      success: (_) {},
      failure: (_) {
        final restored = [..._events];
        restored.insert(index.clamp(0, restored.length), removed);
        emit(FavoritesState.success(restored));
      },
    );
  }
}
