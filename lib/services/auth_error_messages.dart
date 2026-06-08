import 'package:firebase_auth/firebase_auth.dart';

/// Mensagens de erro do Firebase Auth em português.
String authErrorMessage(Object error) {
  if (error is FirebaseAuthException) {
    return switch (error.code) {
      'invalid-email' => 'E-mail inválido.',
      'user-disabled' => 'Esta conta foi desativada.',
      'user-not-found' => 'Não encontramos conta com este e-mail.',
      'wrong-password' => 'Senha incorreta.',
      'invalid-credential' => 'E-mail ou senha incorretos.',
      'email-already-in-use' => 'Este e-mail já está cadastrado.',
      'weak-password' => 'Senha fraca. Use pelo menos 6 caracteres.',
      'operation-not-allowed' => 'Login por e-mail não está habilitado no Firebase.',
      'too-many-requests' => 'Muitas tentativas. Tente novamente mais tarde.',
      'network-request-failed' => 'Sem conexão. Verifique sua internet.',
      'popup-closed-by-user' => 'Login com Google cancelado.',
      'popup-blocked' => 'O navegador bloqueou o popup do Google. Libere e tente de novo.',
      _ => error.message ?? 'Não foi possível concluir a autenticação.',
    };
  }

  if (error is StateError) {
    return error.message;
  }

  return 'Ocorreu um erro inesperado. Tente novamente.';
}
