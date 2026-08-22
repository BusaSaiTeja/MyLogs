import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';

class PosterMosaic extends StatelessWidget {
  const PosterMosaic({super.key, required this.urls, this.singlePoster = false});
  final List<String> urls;
  final bool singlePoster;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: SizedBox(
        width: 80,
        height: 80,
        child: singlePoster || urls.length < 2
            ? _PosterImage(url: urls.isNotEmpty ? urls[0] : '')
            : Row(
                children: [
                  Expanded(child: _PosterImage(url: urls[0])),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(child: _PosterImage(url: urls.length > 1 ? urls[1] : '')),
                        const SizedBox(height: 2),
                        Expanded(child: _PosterImage(url: urls.length > 2 ? urls[2] : '')),
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
    return Container(
      color: AppColors.surfaceVariant,
      child: url.isEmpty
          ? const Icon(Icons.movie_outlined, color: AppColors.outline, size: 24)
          : Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.surfaceVariant),
            ),
    );
  }
}
