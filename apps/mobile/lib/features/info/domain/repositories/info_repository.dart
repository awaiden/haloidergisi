import '../entities/contact_message.dart';
import '../entities/team.dart';

abstract interface class InfoRepository {
  /// Team sections in display order; members without a profile are skipped.
  Future<List<Crew>> getTeam();

  Future<void> sendMessage(ContactMessage message, {required String turnstileToken});
}
