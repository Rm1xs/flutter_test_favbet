// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

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
          color: AppColors.light.favorite,
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
