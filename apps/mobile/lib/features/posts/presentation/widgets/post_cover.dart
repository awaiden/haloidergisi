import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/cdn.dart';

/// Magazine cover (portrait) with a neutral placeholder.
class PostCover extends StatelessWidget {
  const PostCover({super.key, required this.path, this.width});

  final String? path;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final url = cdnUrl(path);
    final placeholder = ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Icon(Icons.menu_book_outlined, color: scheme.onSurfaceVariant),
    );

    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: DecoratedBox(
          // A soft drop shadow so covers read as printed objects.
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.coverRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.coverRadius),
            child: url == null
                ? placeholder
                : CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => placeholder,
                    errorWidget: (_, _, _) => placeholder,
                  ),
          ),
        ),
      ),
    );
  }
}
