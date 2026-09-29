import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../../../core/utils/open_url.dart';
import '../../../../core/widgets/halo.dart';

/// Static page rendered from a bundled markdown asset (about, privacy, terms).
class MarkdownPageScreen extends StatefulWidget {
  const MarkdownPageScreen({super.key, required this.title, required this.asset});

  final String title;
  final String asset;

  @override
  State<MarkdownPageScreen> createState() => _MarkdownPageScreenState();
}

class _MarkdownPageScreenState extends State<MarkdownPageScreen> {
  late Future<String> _content;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _content = DefaultAssetBundle.of(context).loadString(widget.asset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<String>(
        future: _content,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) {
            return const HaloLoading();
          }
          return Markdown(
            data: data,
            selectable: true,
            padding: const EdgeInsets.all(16),
            onTapLink: (_, href, _) => openExternalUrl(context, href),
          );
        },
      ),
    );
  }
}
