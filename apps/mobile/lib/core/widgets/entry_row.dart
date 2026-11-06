import 'package:flutter/material.dart';

/// Text-first list row (news, calls) that opens a detail page: serif title,
/// muted detail line, an optional excerpt and a chevron so it reads as
/// tappable. Rows are separated by rules rather than boxed as cards.
class EntryRow extends StatelessWidget {
  const EntryRow({
    super.key,
    required this.title,
    required this.detail,
    required this.onTap,
    this.excerpt,
    this.badge,
  });

  final String title;
  final String detail;
  final VoidCallback onTap;

  /// A line or two of the body, so it's clear there is more to read.
  final String? excerpt;

  /// Shown under the detail line (e.g. an approaching deadline).
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 12, 18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 19),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      detail,
                      style: theme.textTheme.bodySmall?.copyWith(color: muted),
                    ),
                    if (excerpt?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 8),
                      Text(
                        excerpt!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                    if (badge != null) ...[const SizedBox(height: 10), badge!],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: muted),
            ],
          ),
        ),
      ),
    );
  }
}
