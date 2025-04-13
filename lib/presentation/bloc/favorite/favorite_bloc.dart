import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopease/core/constants/app_constants.dart';
import 'package:shopease/domain/entities/product.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final SharedPreferences sharedPreferences;

  FavoriteBloc({required this.sharedPreferences}) : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoading());
    try {
      final favoritesJson = sharedPreferences.getStringList(AppConstants.favoritesKey) ?? [];
      final favorites = favoritesJson.map((json) => ProductModel.fromJson(json)).toList();
      emit(FavoriteLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoriteError(message: 'Failed to load favorites: $e'));
    }
  }

  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    if (state is FavoriteLoaded) {
      final currentState = state as FavoriteLoaded;
      final updatedFavorites = List<Product>.from(currentState.favorites)..add(event.product);
      await _saveFavorites(updatedFavorites);
      emit(FavoriteLoaded(favorites: updatedFavorites));
    }
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    if (state is FavoriteLoaded) {
      final currentState = state as FavoriteLoaded;
      final updatedFavorites = List<Product>.from(currentState.favorites)
        ..removeWhere((product) => product.id == event.product.id);
      await _saveFavorites(updatedFavorites);
      emit(FavoriteLoaded(favorites: updatedFavorites));
    }
  }

  Future<void> _saveFavorites(List<Product> favorites) async {
    final favoritesJson = favorites.map((product) => product.toJson()).toList();
    await sharedPreferences.setStringList(
      AppConstants.favoritesKey,
      favoritesJson,
    );
  }
}