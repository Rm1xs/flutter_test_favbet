// ignore_for_file: deprecated_member_use, lines_longer_than_80_chars

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/providers/theme_notifier.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/search_movie_provider.dart';

class SearchMoviesScreen extends ConsumerStatefulWidget {
  const SearchMoviesScreen({required this.initialQuery, super.key});
  final String initialQuery;

  @override
  ConsumerState<SearchMoviesScreen> createState() => _SearchMoviesScreenState();
}

class _SearchMoviesScreenState extends ConsumerState<SearchMoviesScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery;
    if (widget.initialQuery.isNotEmpty) {
      ref
          .read(searchMoviesProvider.notifier)
          .searchMovies(query: widget.initialQuery);
    }
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 2), () {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        ref.read(searchMoviesProvider.notifier).searchMovies(query: query);
      } else if (query.isEmpty && searchState.movies.isNotEmpty) {
        ref.read(searchMoviesProvider.notifier).clearSearch();
      }
    });
  }

  SearchMoviesState get searchState => ref.watch(searchMoviesProvider);

  @override
  Widget build(BuildContext context) {
    final searchNotifier = ref.read(searchMoviesProvider.notifier);
    final isDarkTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            searchNotifier.clearSearch();
            context.pop();
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Search',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(
                    Icons.search,
                    color:
                        isDarkTheme
                            ? Colors.white.withOpacity(0.6)
                            : Colors.black54,
                  ),
                  suffixIcon:
                      _searchController.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color:
                                  isDarkTheme
                                      ? Colors.white.withOpacity(0.6)
                                      : Colors.black54,
                            ),
                            onPressed: () {
                              searchNotifier.clearSearch();
                              _searchController.clear();
                            },
                          )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  filled: true,
                  fillColor:
                      isDarkTheme
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFF1F1F1),
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Expanded(
              child: _buildBody(
                context,
                searchState,
                searchNotifier,
                isDarkTheme,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SearchMoviesState searchState,
    SearchMoviesNotifier searchNotifier,
    bool isDarkTheme,
  ) {
    // TextFiled empty
    if (searchState.query.isEmpty) {
      return const SizedBox.shrink();
    }

    // loading
    if (searchState.isLoading && searchState.movies.isEmpty) {
      return const Center(
        child: SizedBox(
          height: 80,
          width: 80,
          child: LoadingIndicator(
            indicatorType: Indicator.ballRotateChase,
            colors: [Colors.grey],
            strokeWidth: 2,
          ),
        ),
      );
    }

    // search complete but list empty
    if (searchState.query.isNotEmpty &&
        searchState.movies.isEmpty &&
        !searchState.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Search results (0)',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 70),
            Center(
              child: SizedBox(
                height: 105,
                width: 115,
                child: Image.asset(
                  'assets/images/not_found.png',
                  color:
                      isDarkTheme
                          ? AppColors.light.background
                          : AppColors.dark.background,
                ),
              ),
            ),
          ],
        ),
      );
    }

    //have search result
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                'Search results (${searchState.movies.length})',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.58,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final movie = searchState.movies[index];
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
                                  ? Image.network(
                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                    width: double.infinity,
                                    height: 250,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          width: double.infinity,
                                          height: 250,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  )
                                  : Container(
                                    width: double.infinity,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.movie, size: 50),
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(movie.voteAverage * 10).round() / 10}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }, childCount: searchState.movies.length),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (searchState.isLoading && searchState.movies.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballRotateChase,
                        colors: [Colors.grey],
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                if (searchState.movies.isNotEmpty)
                  PaginationWidget(
                    currentPage: searchState.currentPage,
                    totalPages: searchState.totalPages,
                    isLoading: searchState.isLoading,
                    onPageSelected: (page) {
                      searchNotifier.searchMovies(
                        query: searchState.query,
                        page: page,
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaginationWidget extends StatelessWidget {
  const PaginationWidget({
    required this.currentPage,
    required this.totalPages,
    required this.isLoading,
    required this.onPageSelected,
    super.key,
  });
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final Function(int) onPageSelected;

  @override
  Widget build(BuildContext context) {
    final prevPage = currentPage > 1 ? currentPage - 1 : 1;
    final nextPage = currentPage < totalPages ? currentPage + 1 : totalPages;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentPage > 1)
            _buildPageButton(context, prevPage, isLoading, onPageSelected),
          _buildCurrentPageButton(context, currentPage),
          if (currentPage < totalPages)
            _buildPageButton(context, nextPage, isLoading, onPageSelected),
          if (nextPage < totalPages - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '...',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          if (currentPage < totalPages - 1)
            _buildPageButton(context, totalPages, isLoading, onPageSelected),
        ],
      ),
    );
  }

  Widget _buildPageButton(
    BuildContext context,
    int page,
    bool isLoading,
    Function(int) onPageSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: isLoading ? null : () => onPageSelected(page),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          child: Center(
            child: Text(
              '$page',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPageButton(BuildContext context, int page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        child: Center(
          child: Text(
            '$page',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
