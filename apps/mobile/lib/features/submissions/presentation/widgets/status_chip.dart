import 'package:flutter/material.dart';

import '../../domain/entities/submission.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final ArticleStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      ArticleStatus.pending => Colors.amber,
      ArticleStatus.reviewing => Colors.blue,
      ArticleStatus.approved => Colors.green,
      ArticleStatus.rejected => Colors.red,
      ArticleStatus.revisionRequested => Colors.purple,
    };
    return Chip(
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: color.withValues(alpha: 0.4)),
      backgroundColor: color.withValues(alpha: 0.12),
      label: Text(status.label),
    );
  }
}
