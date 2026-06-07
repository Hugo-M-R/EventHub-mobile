/// Regra de negócio: apenas contas @souunit.com.br podem usar o app.
abstract final class InstitutionalEmailPolicy {
  static const institutionalDomain = '@souunit.com.br';

  static bool isAllowed(String? email) {
    if (email == null || email.trim().isEmpty) return false;
    return email.toLowerCase().trim().endsWith(institutionalDomain);
  }

  static String? validationMessage(String? email) {
    if (isAllowed(email)) return null;
    return 'Use seu e-mail institucional ($institutionalDomain).';
  }
}

class InstitutionalEmailException implements Exception {
  InstitutionalEmailException([
    this.message =
        'Acesso restrito a contas institucionais (@souunit.com.br).',
  ]);

  final String message;

  @override
  String toString() => message;
}
