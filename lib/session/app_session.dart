abstract final class AppSession {
  static String? email;
  static String? name;

  static void loginAsUser(String userEmail, {String? fullName}) {
    final trimmedEmail = userEmail.trim();
    email = trimmedEmail.isEmpty ? 'usuario@eventhub.local' : trimmedEmail;
    final trimmedName = fullName?.trim();
    name = (trimmedName == null || trimmedName.isEmpty) ? null : trimmedName;
  }

  static void clear() {
    email = null;
    name = null;
  }

  static String get displayName {
    if (name != null && name!.isNotEmpty) return name!;
    return email ?? 'usuário';
  }
}
