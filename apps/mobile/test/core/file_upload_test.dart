import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/files/file_upload.dart';
import 'package:mobile/core/network/api_exception.dart';

void main() {
  late RequestOptions captured;
  late FileUploader uploader;

  setUp(() {
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            handler.resolve(
              Response(
                requestOptions: options,
                data: '1790000000000-Kader Öyküsü.docx',
              ),
            );
          },
        ),
      );
    uploader = FileUploader(dio);
  });

  test('streams a multipart upload with the original filename', () async {
    final key = await uploader.upload(
      content: Stream.value([1, 2, 3]),
      length: 3,
      filename: 'Kader Öyküsü.docx',
    );

    expect(captured.path, '/files');
    final form = captured.data as FormData;
    expect(form.files.single.key, 'file');
    expect(form.files.single.value.filename, 'Kader Öyküsü.docx');
    expect(form.files.single.value.length, 3);
    expect(key, '1790000000000-Kader Öyküsü.docx');
  });

  test('the over-limit error reads like the server one', () {
    const e = FileTooLargeException();
    expect(e, isA<ApiException>());
    expect(e.statusCode, 413);
  });
}
