/// `POST /messages` (the web "İletişim" form).
class ContactMessage {
  const ContactMessage({
    required this.name,
    required this.email,
    required this.subject,
    required this.content,
  });

  final String name;
  final String email;
  final String subject;
  final String content;
}
