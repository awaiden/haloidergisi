import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/cdn.dart';

/// Profile photo from the CDN, falling back to the first letter of [name].
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.avatarPath,
    this.radius = 24,
  });

  final String name;

  /// Stored CDN path (`Profile.avatarUrl`).
  final String? avatarPath;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final url = cdnUrl(avatarPath);
    final initial = name.trim().isEmpty ? '?' : name.trim().characters.first;

    return CircleAvatar(
      radius: radius,
      foregroundImage: url == null ? null : CachedNetworkImageProvider(url),
      // Shown while loading and if the image fails.
      child: Text(
        initial.toUpperCase(),
        style: TextStyle(fontSize: radius * 0.8),
      ),
    );
  }
}
