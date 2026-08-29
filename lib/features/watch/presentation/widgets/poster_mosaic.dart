import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';

class PosterMosaic extends StatelessWidget {
  const PosterMosaic({
    super.key,
    required this.urls,
    this.fallbackIcon = Icons.movie_outlined,
  });

  final List<String> urls;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final validUrls = urls.where((u) => u.trim().isNotEmpty).toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Container(
        width: 80,
        height: 80,
        color: AppColors.surfaceVariant,
        child: validUrls.isEmpty
            ? Center(
                child: Icon(
                  fallbackIcon,
                  color: AppColors.outlineVariant,
                  size: 32,
                ),
              )
            : validUrls.length == 1
                ? _PosterImage(url: validUrls[0])
                : Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: _PosterImage(url: validUrls[0]),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Expanded(
                              child: _PosterImage(
                                url: validUrls.length > 1 ? validUrls[1] : validUrls[0],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Expanded(
                              child: _PosterImage(
                                url: validUrls.length > 2
                                    ? validUrls[2]
                                    : (validUrls.length > 1 ? validUrls[1] : validUrls[0]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _PosterImage extends StatelessWidget {
  const _PosterImage({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Container(
        color: AppColors.surfaceVariant,
        child: const Icon(Icons.movie_outlined, color: AppColors.outlineVariant, size: 20),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => Container(color: AppColors.surfaceVariant),
      errorWidget: (_, _, _) => Container(
        color: AppColors.surfaceVariant,
        child: const Icon(Icons.broken_image_outlined, color: AppColors.outline, size: 16),
      ),
    );
  }
}
