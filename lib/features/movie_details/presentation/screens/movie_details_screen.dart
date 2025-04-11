// ignore_for_file: lines_longer_than_80_chars

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../core/providers/theme_notifier.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../favorites/models/favorite_movie.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../providers/movie_details_provider.dart';

class MovieDetailsScreen extends ConsumerWidget {
  const MovieDetailsScreen({required this.movieId, super.key});
  final int movieId;

  String formatReleaseDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate.replaceAll('.', '-'));
      return DateFormat('d MMMM y').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieDetailsState = ref.watch(movieDetailsProvider(movieId));
    final isDarkTheme = ref.watch(themeProvider);
    final favorites = ref.watch(favoritesProvider);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);

    final isFavorite = favorites.any((fav) => fav.id == movieId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          movieDetailsState.movieDetails?.title ?? '',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child:
            movieDetailsState.isLoading
                ? const Center(
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballRotateChase,
                      colors: [Colors.grey],
                      strokeWidth: 2,
                    ),
                  ),
                )
                : movieDetailsState.error != null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 50,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load movie details: ${movieDetailsState.error}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
                : movieDetailsState.movieDetails == null
                ? const Center(child: Text('No details available'))
                : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              movieDetailsState
                                      .movieDetails!
                                      .posterPath
                                      .isNotEmpty
                                  ? CachedNetworkImage(
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/w500${movieDetailsState.movieDetails!.posterPath}',
                                    fit: BoxFit.cover,
                                    width: 250,
                                    height: 380,
                                    placeholder:
                                        (context, url) => Container(
                                          width: double.infinity,
                                          height: 300,
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                    errorWidget:
                                        (context, url, error) => Container(
                                          width: double.infinity,
                                          height: 300,
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: Icon(
                                              Icons.error_outline,
                                              size: 50,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                  )
                                  : Container(
                                    width: double.infinity,
                                    height: 300,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(Icons.movie, size: 50),
                                    ),
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Rating ${(movieDetailsState.movieDetails!.voteAverage * 10).round() / 10}',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          movieDetailsState.movieDetails!.overview.isNotEmpty
                              ? movieDetailsState.movieDetails!.overview
                              : 'No overview available.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              formatReleaseDate(
                                movieDetailsState.movieDetails?.releaseDate ??
                                    DateTime.now().toString(),
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  !isFavorite
                                      ? isDarkTheme
                                          ? AppColors.dark.buttonBackground1
                                          : AppColors.light.buttonBackground1
                                      : isDarkTheme
                                      ? AppColors.light.buttonBackground2
                                      : AppColors.dark.buttonBackground2,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side:
                                    isFavorite
                                        ? const BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        )
                                        : const BorderSide(
                                          width: 0,
                                          color: Colors.transparent,
                                        ),
                              ),
                            ),
                            onPressed: () {
                              final movie = movieDetailsState.movieDetails!;
                              if (isFavorite) {
                                favoritesNotifier.removeFavorite(movieId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Removed from favorites'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                favoritesNotifier.addFavorite(
                                  FavoriteMovie(
                                    id: movie.id,
                                    title: movie.title,
                                    posterPath: movie.posterPath,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Added to favorites'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              isFavorite
                                  ? 'Remove from favorites'
                                  : 'Add to favorites',
                              style: TextStyle(
                                color:
                                    !isFavorite
                                        ? isDarkTheme
                                            ? AppColors.dark.buttonText1
                                            : AppColors.light.buttonText1
                                        : isDarkTheme
                                        ? AppColors.dark.buttonText2
                                        : AppColors.light.buttonText2,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
