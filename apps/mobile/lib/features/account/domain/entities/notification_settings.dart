class NotificationSettings {
  const NotificationSettings({
    required this.emailNotifications,
    required this.newPost,
    required this.securityAlert,
  });

  final bool emailNotifications;
  final bool newPost;
  final bool securityAlert;

  NotificationSettings copyWith({
    bool? emailNotifications,
    bool? newPost,
    bool? securityAlert,
  }) =>
      NotificationSettings(
        emailNotifications: emailNotifications ?? this.emailNotifications,
        newPost: newPost ?? this.newPost,
        securityAlert: securityAlert ?? this.securityAlert,
      );
}
