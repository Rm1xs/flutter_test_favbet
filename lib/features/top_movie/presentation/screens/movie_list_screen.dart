// ignore_for_file: lines_longer_than_80_chars

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../core/errors/remote_exception.dart';
import '../../../../core/providers/theme_notifier.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/movie_provider.dart';
import '../widgets/pagination_widget.dart';

class MovieListScreen extends ConsumerStatefulWidget {
  const MovieListScreen({super.key});

  @override
  ConsumerState<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends ConsumerState<MovieListScreen> {
  late ScrollController _scrollController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _restoreScrollPosition() {
    if (_scrollController.hasClients && _scrollOffset > 0) {
      _scrollController.jumpTo(_scrollOffset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final moviesState = ref.watch(topRatedMoviesProvider);
    final moviesNotifier = ref.read(topRatedMoviesProvider.notifier);
    final isDarkTheme = ref.watch(themeProvider);

    ref.listen(topRatedMoviesProvider, (previous, next) {
      if (next.isLoading == false &&
          next.movies.isEmpty &&
          previous?.movies.isNotEmpty == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next is RemoteException
                  ? (next as RemoteException).message
                  : 'Failed to load movies',
            ),
            action: SnackBarAction(
              label: 'Retry',
              onPressed:
                  () => moviesNotifier.fetchMovies(page: next.currentPage),
            ),
          ),
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreScrollPosition();
    });

    final currentPage = moviesState.currentPage;
    final totalPages = moviesState.totalPages;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/search'),
            icon: Icon(
              Icons.search,
              color:
                  isDarkTheme ? AppColors.light.search : AppColors.dark.search,
            ),
          ),
          IconButton(
            icon: Icon(isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              _scrollOffset = _scrollController.offset;
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: SafeArea(
        child:
            moviesState.movies.isEmpty && moviesState.isLoading
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
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomScrollView(
                    physics: const ClampingScrollPhysics(),
                    controller: _scrollController,
                    slivers: [
                      SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.58,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final movie = moviesState.movies[index];
                          return GestureDetector(
                            onTap: () => context.push('/movie/${movie.id}'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child:
                                          movie.posterPath.isNotEmpty
                                              ? CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                fit: BoxFit.cover,
                                                filterQuality:
                                                    FilterQuality.high,
                                                width: double.infinity,
                                                height: 250,
                                                placeholder:
                                                    (context, url) => Container(
                                                      width: double.infinity,
                                                      height: 250,
                                                      color: Colors.grey[300],
                                                      child: const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                      ),
                                                    ),
                                                errorWidget:
                                                    (
                                                      context,
                                                      url,
                                                      error,
                                                    ) => Container(
                                                      width: double.infinity,
                                                      height: 250,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
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
                                                height: 250,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.movie,
                                                    size: 50,
                                                  ),
                                                ),
                                              ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black45,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  movie.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${(movie.voteAverage * 10).round() / 10}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }, childCount: moviesState.movies.length),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            PaginationWidget(
                              currentPage: currentPage,
                              totalPages: totalPages,
                              isLoading: moviesState.isLoading,
                              onPageSelected: (page) {
                                _scrollOffset = _scrollController.offset;
                                moviesNotifier.fetchMovies(page: page);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
