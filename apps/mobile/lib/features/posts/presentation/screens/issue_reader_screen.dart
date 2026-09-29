import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/cdn.dart';
import '../../../../core/widgets/error_retry.dart';
import '../../../../core/widgets/halo.dart';
import '../../data/issue_file_cache.dart';
import '../../data/reading_progress.dart';
import '../../domain/entities/post.dart';
import '../controllers/posts_controller.dart';
import '../widgets/post_cover.dart';

/// Reads an issue's PDF in-app. The file is downloaded into the app's cache
/// (asking the user first if not downloaded) and opened from disk afterwards;
/// the reader reopens on the last page read.
class IssueReaderScreen extends ConsumerWidget {
  const IssueReaderScreen({
    super.key,
    required this.idOrSlug,
    this.autoDownload = false,
  });

  final String idOrSlug;
  final bool autoDownload;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postDetailProvider(idOrSlug));
    return post.when(
      loading: () => const Scaffold(body: HaloLoading()),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorRetry(
          error: error,
          onRetry: () => ref.invalidate(postDetailProvider(idOrSlug)),
        ),
      ),
      data: (post) {
        final url = cdnUrl(post.attachment);
        if (url == null) {
          return Scaffold(
            appBar: AppBar(title: Text(post.title)),
            body: const Center(child: Text('Bu sayının PDF dosyası yok.')),
          );
        }
        return _Reader(
          post: post,
          url: url,
          autoDownload: autoDownload,
        );
      },
    );
  }
}

enum _ReaderStatus {
  checkingCache,
  promptDownload,
  downloading,
  ready,
  error,
}

class _Reader extends ConsumerStatefulWidget {
  const _Reader({
    required this.post,
    required this.url,
    this.autoDownload = false,
  });

  final Post post;
  final String url;
  final bool autoDownload;

  @override
  ConsumerState<_Reader> createState() => _ReaderState();
}

class _ReaderState extends ConsumerState<_Reader> {
  CancelToken _cancel = CancelToken();

  _ReaderStatus _status = _ReaderStatus.checkingCache;
  File? _file;
  Object? _error;
  int _received = 0;
  int? _total;

  late final int _startPage = () {
    final saved =
        ref.read(readingProgressProvider).lastPage(widget.post.slug) ?? 1;
    return saved < 1 ? 1 : saved;
  }();

  @override
  void initState() {
    super.initState();
    _checkCache();
  }

  @override
  void dispose() {
    _cancel.cancel();
    super.dispose();
  }

  Future<void> _checkCache() async {
    setState(() {
      _status = _ReaderStatus.checkingCache;
      _error = null;
    });
    final cache = ref.read(issueFileCacheProvider);
    try {
      final cachedFile = await cache.cached(widget.url);
      if (!mounted) return;
      if (cachedFile != null) {
        setState(() {
          _file = cachedFile;
          _status = _ReaderStatus.ready;
        });
      } else if (widget.autoDownload) {
        // User already confirmed before opening the reader screen.
        _startDownload();
      } else {
        setState(() {
          _status = _ReaderStatus.promptDownload;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _status = _ReaderStatus.error;
      });
    }
  }

  Future<void> _startDownload() async {
    _cancel = CancelToken();
    setState(() {
      _status = _ReaderStatus.downloading;
      _error = null;
      _received = 0;
      _total = null;
    });
    final cache = ref.read(issueFileCacheProvider);
    try {
      final file = await cache.download(
        widget.url,
        cancelToken: _cancel,
        onProgress: (received, total) {
          if (!mounted) return;
          setState(() {
            _received = received;
            _total = total;
          });
        },
      );
      if (!mounted) return;
      ref.invalidate(isIssueCachedProvider(widget.url));
      setState(() {
        _file = file;
        _status = _ReaderStatus.ready;
      });
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        if (mounted) {
          setState(() {
            _status = _ReaderStatus.promptDownload;
          });
        }
        return;
      }
      if (mounted) {
        setState(() {
          _error = e;
          _status = _ReaderStatus.error;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _status = _ReaderStatus.error;
        });
      }
    }
  }

  Future<void> _redownload(File broken) async {
    // A corrupt copy: drop it and download again.
    if (await broken.exists()) await broken.delete();
    ref.invalidate(isIssueCachedProvider(widget.url));
    if (!mounted) return;
    setState(() => _file = null);
    await _startDownload();
  }

  @override
  Widget build(BuildContext context) {
    final file = _file;

    return switch (_status) {
      _ReaderStatus.checkingCache => const Scaffold(
          body: Center(child: HaloLoading()),
        ),
      _ReaderStatus.promptDownload => Scaffold(
          appBar: AppBar(
            title: Text(
              widget.post.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          body: _DownloadPrompt(
            post: widget.post,
            onDownload: _startDownload,
            onCancel: () => Navigator.of(context).pop(),
          ),
        ),
      _ReaderStatus.downloading => Scaffold(
          appBar: AppBar(
            title: Text(
              widget.post.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          body: _DownloadProgress(
            post: widget.post,
            received: _received,
            total: _total,
            onCancel: () {
              _cancel.cancel();
            },
          ),
        ),
      _ReaderStatus.error => Scaffold(
          appBar: AppBar(
            title: Text(
              widget.post.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          body: ErrorRetry(
            error: _error ?? 'Dergi açılırken bir hata oluştu.',
            onRetry: _checkCache,
          ),
        ),
      _ReaderStatus.ready => file == null
          ? const Scaffold(body: Center(child: HaloLoading()))
          : IssueDocumentViewer(
              documentRef: PdfDocumentRefFile(file.path),
              post: widget.post,
              startPage: _startPage,
              onRedownload: () => _redownload(file),
            ),
    };
  }
}

/// Opens an issue's PDF and pages through it. Takes a [PdfDocumentRef] (the
/// downloaded file in the app) so tests can supply an in-memory document.
///
/// [PdfDocumentViewBuilder] only loads the document; all reader state lives in
/// [_IssuePages] below it, so nothing calls `setState` on an ancestor while
/// the builder is building (that threw as soon as a document loaded).
@visibleForTesting
class IssueDocumentViewer extends StatelessWidget {
  const IssueDocumentViewer({
    super.key,
    required this.documentRef,
    required this.post,
    required this.startPage,
    required this.onRedownload,
  });

  final PdfDocumentRef documentRef;
  final Post post;
  final int startPage;
  final VoidCallback onRedownload;

  /// pdfium's errors mean nothing to readers; retrying downloads a fresh copy.
  static const _brokenFile = ApiException(
    'Dergi dosyası açılamadı. Yeniden indirmek için tekrar deneyin.',
  );

  @override
  Widget build(BuildContext context) {
    return PdfDocumentViewBuilder(
      documentRef: documentRef,
      loadingBuilder: (context) => _ReaderScaffold(
        title: post.title,
        body: const Center(child: HaloLoading()),
      ),
      errorBuilder: (context, error, _) => _ReaderScaffold(
        title: post.title,
        body: ErrorRetry(error: _brokenFile, onRetry: onRedownload),
      ),
      builder: (context, document) => switch (document) {
        null => _ReaderScaffold(
          title: post.title,
          body: const Center(child: HaloLoading()),
        ),
        // An empty document means a broken download: offer to fetch it again.
        PdfDocument(pages: []) => _ReaderScaffold(
          title: post.title,
          body: ErrorRetry(error: _brokenFile, onRetry: onRedownload),
        ),
        _ => _IssuePages(
          key: ValueKey(document),
          document: document,
          post: post,
          startPage: startPage,
        ),
      },
    );
  }
}

class _ReaderScaffold extends StatelessWidget {
  const _ReaderScaffold({
    required this.title,
    required this.body,
    this.bottomNavigationBar,
  });

  final String title;
  final Widget body;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class _IssuePages extends ConsumerStatefulWidget {
  const _IssuePages({
    super.key,
    required this.document,
    required this.post,
    required this.startPage,
  });

  final PdfDocument document;
  final Post post;
  final int startPage;

  @override
  ConsumerState<_IssuePages> createState() => _IssuePagesState();
}

class _IssuePagesState extends ConsumerState<_IssuePages> {
  late final int _pageCount = widget.document.pages.length;
  late int _currentPage = widget.startPage.clamp(1, _pageCount);
  late final PageController _pageController = PageController(
    initialPage: _currentPage - 1,
  );
  double? _dragPage;

  @override
  void initState() {
    super.initState();
    if (widget.startPage > 1 && widget.startPage <= _pageCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Kaldığınız yerden devam ediyorsunuz (s. ${widget.startPage}).',
            ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _saveProgress(int page) =>
      ref.read(readingProgressProvider).save(widget.post.slug, page);

  @override
  Widget build(BuildContext context) {
    return _ReaderScaffold(
      title: widget.post.title,
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pageCount,
        onPageChanged: (index) {
          final newPage = index + 1;
          setState(() => _currentPage = newPage);
          _saveProgress(newPage);
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            minScale: 1.0,
            maxScale: 4.0,
            clipBehavior: Clip.none,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                child: PdfPageView(
                  document: widget.document,
                  pageNumber: index + 1,
                  maximumDpi: 300,
                  backgroundColor: Colors.white,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _pageCount > 1
          ? _PageBar(
              page: (_dragPage ?? _currentPage.toDouble()).round(),
              pageCount: _pageCount,
              onDrag: (val) => setState(() => _dragPage = val),
              onJump: (val) {
                final target = val.round();
                setState(() {
                  _dragPage = null;
                  _currentPage = target;
                });
                _pageController.jumpToPage(target - 1);
                _saveProgress(target);
              },
            )
          : null,
    );
  }
}

class _DownloadPrompt extends StatelessWidget {
  const _DownloadPrompt({
    required this.post,
    required this.onDownload,
    required this.onCancel,
  });

  final Post post;
  final VoidCallback onDownload;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = scheme.onSurfaceVariant;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PostCover(path: post.coverImage, width: 140),
            const SizedBox(height: 24),
            Text(
              post.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontFamily: 'PlayfairDisplay',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Bu sayıyı okumak için PDF dosyasının indirilmesi gerekmektedir. İndirildikten sonra çevrimdışı da okuyabilirsiniz.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: muted,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: onDownload,
              icon: const Icon(Icons.download_rounded),
              label: const Text('İndir ve Oku'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(200, 48),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onCancel,
              child: const Text('Geri Dön'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadProgress extends StatelessWidget {
  const _DownloadProgress({
    required this.post,
    required this.received,
    required this.total,
    this.onCancel,
  });

  final Post post;
  final int received;
  final int? total;
  final VoidCallback? onCancel;

  static String _mb(int bytes) => (bytes / (1024 * 1024)).toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = scheme.onSurfaceVariant;
    final total = this.total;
    final fraction =
        total == null || total == 0 ? null : (received / total).clamp(0.0, 1.0);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PostCover(path: post.coverImage, width: 110),
            const SizedBox(height: 20),
            Text(
              'Dergi İndiriliyor...',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontFamily: 'PlayfairDisplay',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              post.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(color: muted),
            ),
            const SizedBox(height: 24),
            Container(
              constraints: const BoxConstraints(maxWidth: 320),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppTheme.radius),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: fraction,
                      minHeight: 8,
                      backgroundColor: scheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation(scheme.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        fraction == null
                            ? 'Hazırlanıyor...'
                            : '%${(fraction * 100).round()}',
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        fraction == null
                            ? '${_mb(received)} MB'
                            : '${_mb(received)} / ${_mb(total!)} MB',
                        style: TextStyle(
                          color: muted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.offline_pin_outlined, size: 14, color: muted),
                      const SizedBox(width: 5),
                      Text(
                        'Tamamlandığında çevrimdışı açılacaktır',
                        style:
                            theme.textTheme.labelSmall?.copyWith(color: muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (onCancel != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.close_rounded, size: 18),
                label: const Text('İndirmeyi İptal Et'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Page slider for jumping through the issue.
class _PageBar extends StatelessWidget {
  const _PageBar({
    required this.page,
    required this.pageCount,
    required this.onDrag,
    required this.onJump,
  });

  final int page;
  final int pageCount;
  final ValueChanged<double> onDrag;
  final ValueChanged<double> onJump;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: Slider(
                  value: page.clamp(1, pageCount).toDouble(),
                  min: 1,
                  max: pageCount.toDouble(),
                  divisions: pageCount - 1,
                  label: '$page',
                  onChanged: onDrag,
                  onChangeEnd: onJump,
                ),
              ),
              Text('$page / $pageCount', style: theme.textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
