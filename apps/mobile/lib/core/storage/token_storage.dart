import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../app/constants/storage_keys.dart';

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => TokenStorage(const FlutterSecureStorage()),
);

class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  Future<String?> read() => _storage.read(key: StorageKeys.sessionToken);

  Future<void> write(String token) =>
      _storage.write(key: StorageKeys.sessionToken, value: token);

  Future<void> clear() => _storage.delete(key: StorageKeys.sessionToken);
}
