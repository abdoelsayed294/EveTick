import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/favorites/data/favorites_repository.dart';
import 'package:evetick/features/favorites/logic/favorites_state.dart';
import 'package:evetick/features/home/data/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository repo;
  final HomeRepo homeRepo;

  FavoritesCubit(this.repo, this.homeRepo) : super(const FavoritesState());

  /// [silent] keeps the current list on screen (pull to refresh, tab opened).
  Future<void> load({bool silent = false}) async {
    if (!silent) emit(const FavoritesState());

    final result = await repo.getFavoriteEvents();
    result.when(
      success: (events) => emit(
        state.copyWith(status: FavoritesStatus.success, events: events),
      ),
      failure: (error) {
        // On a silent refresh keep what the user already sees.
        if (silent && state.events.isNotEmpty) return;
        emit(
          state.copyWith(
            status: FavoritesStatus.error,
            errorMessage: error.message,
          ),
        );
      },
    );
  }

  /// Removes the card immediately, then saves; puts it back if saving fails.
  Future<void> removeFavorite(String eventId) async {
    final index = state.events.indexWhere((e) => e.id == eventId);
    if (index < 0) return;
    final removed = state.events[index];

    emit(
      state.copyWith(
        events: [...state.events]..removeAt(index),
      ),
    );

    final result = await homeRepo.setFavorite(eventId, isFavorite: false);
    result.when(
      success: (_) {},
      failure: (_) {
        final restored = [...state.events];
        restored.insert(index.clamp(0, restored.length), removed);
        emit(state.copyWith(events: restored));
      },
    );
  }
}
