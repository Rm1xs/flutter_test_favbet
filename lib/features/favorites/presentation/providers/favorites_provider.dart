import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/favorite_movie.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<FavoriteMovie>>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return FavoritesNotifier(prefs);
    });

class FavoritesNotifier extends StateNotifier<List<FavoriteMovie>> {
  FavoritesNotifier(this._prefs) : super([]) {
    _loadFavorites();
  }
  final SharedPreferences _prefs;
  static const String _favoritesKey = 'favorites';

  void _loadFavorites() {
    final favoritesJson = _prefs.getString(_favoritesKey);
    if (favoritesJson != null) {
      final List<dynamic> decoded = jsonDecode(favoritesJson);
      state = decoded.map((json) => FavoriteMovie.fromJson(json)).toList();
    }
  }

  void _saveFavorites() {
    final favoritesJson = jsonEncode(
      state.map((movie) => movie.toJson()).toList(),
    );
    _prefs.setString(_favoritesKey, favoritesJson);
  }

  void addFavorite(FavoriteMovie movie) {
    if (!state.any((fav) => fav.id == movie.id)) {
      state = [...state, movie];
      _saveFavorites();
    }
  }

  void removeFavorite(int movieId) {
    state = state.where((fav) => fav.id != movieId).toList();
    _saveFavorites();
  }

  bool isFavorite(int movieId) {
    return state.any((fav) => fav.id == movieId);
  }
}
