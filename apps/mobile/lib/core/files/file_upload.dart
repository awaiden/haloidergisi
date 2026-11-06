import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_exception.dart';
import '../network/dio_client.dart';

/// Mirrors `USER_UPLOAD_LIMIT_BYTES` in the API; admins have no limit.
const userUploadLimitBytes = 25 * 1024 * 1024;

final fileUploaderProvider = Provider<FileUploader>(
  (ref) => FileUploader(ref.watch(dioProvider)),
);

/// Thrown before uploading when a regular user picks a file over the limit.
class FileTooLargeException extends ApiException {
  const FileTooLargeException()
    : super('Dosya en fazla 25 MB olabilir.', statusCode: 413);
}

/// `POST /files` (any signed-in user; avatars and submissions).
class FileUploader {
  FileUploader(this._dio);

  final Dio _dio;

  /// Uploads [content] and returns the stored CDN key (the API answers with
  /// plain text). The body is streamed so large files never sit in memory.
  Future<String> upload({
    required Stream<List<int>> content,
    required int length,
    required String filename,
  }) async {
    try {
      final response = await _dio.post<String>(
        '/files',
        data: FormData.fromMap({
          'file': MultipartFile.fromStream(
            () => content,
            length,
            filename: filename,
          ),
        }),
        options: Options(responseType: ResponseType.plain),
      );
      return response.data!;
    } catch (e) {
      throw ApiException.from(e);
    }
  }

  /// Lets the user pick one file and uploads it. Returns the CDN key, or
  /// `null` if nothing was picked. Throws [ApiException] (including
  /// [FileTooLargeException] for regular users over the limit).
  Future<String?> pickAndUpload({
    required bool isAdmin,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    final picked = await FilePicker.pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
    );
    if (picked.isEmpty) return null;
    final file = picked.single;

    final length = await file.length();
    if (!isAdmin && length != null && length > userUploadLimitBytes) {
      throw const FileTooLargeException();
    }

    // Stream from disk; only read into memory if the size is unknown
    // (Android pickers return content:// URIs, so there is no plain path).
    final bytes = length == null ? await file.readAsBytes() : null;
    return upload(
      content: bytes == null ? file.readAsByteStream() : Stream.value(bytes),
      length: length ?? bytes!.length,
      filename: file.name,
    );
  }
}
