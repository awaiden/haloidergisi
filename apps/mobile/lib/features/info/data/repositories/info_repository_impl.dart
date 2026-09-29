import '../../../../core/network/api_exception.dart';
import '../../domain/entities/contact_message.dart';
import '../../domain/entities/team.dart';
import '../../domain/repositories/info_repository.dart';
import '../datasources/info_remote_datasource.dart';

class InfoRepositoryImpl implements InfoRepository {
  InfoRepositoryImpl(this._remote);

  final InfoRemoteDataSource _remote;

  @override
  Future<List<Crew>> getTeam() => _guard(() async {
        final crews = (await _remote.getCrews()).map((c) => c.toEntity()).toList()
          ..sort((a, b) => a.sort.compareTo(b.sort));
        return crews.where((crew) => crew.members.isNotEmpty).toList();
      });

  @override
  Future<void> sendMessage(ContactMessage message, {required String turnstileToken}) =>
      _guard(() => _remote.sendMessage(message, turnstileToken));

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}
