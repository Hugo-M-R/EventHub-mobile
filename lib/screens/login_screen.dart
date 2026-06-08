import 'package:flutter/material.dart';

import '../services/auth_error_messages.dart';
import '../services/auth_service.dart';
import '../theme/eventhub_colors.dart';
import '../widgets/auth_widgets.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.signInWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (error) {
      if (!mounted) return;
      _showError(authErrorMessage(error));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await AuthService.instance.signInWithGoogle();
    } catch (error) {
      if (!mounted) return;
      _showError(authErrorMessage(error));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      header: const GradientAuthHeader(
        title: 'EventHub',
        subtitle: 'Cultura local na sua mão',
      ),
      card: AuthWhiteCard(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Entrar',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: EventHubColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Acesse sua conta para salvar eventos e criar avisos para o público.',
                style: TextStyle(
                  fontSize: 14,
                  color: EventHubColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              EventHubTextField(
                label: 'E-mail',
                hint: 'nome@email.com',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o e-mail';
                  }
                  if (!value.contains('@')) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              EventHubTextField(
                label: 'Senha',
                hint: '••••••••',
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              AuthTextLink(
                label: 'Esqueci minha senha',
                align: Alignment.centerRight,
                compact: true,
                onTap: _isLoading
                    ? null
                    : () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        ),
              ),
              const SizedBox(height: 16),
              AuthPrimaryButton(
                label: 'Entrar',
                isLoading: _isLoading,
                onPressed: _login,
              ),
              const SizedBox(height: 16),
              const AuthOrDivider(),
              const SizedBox(height: 16),
              GoogleSignInButton(
                label: 'Entrar com Google',
                isLoading: _isLoading,
                onPressed: _loginWithGoogle,
              ),
              const SizedBox(height: 20),
              AuthLinkRow(
                prefix: 'Não tem conta?',
                linkLabel: 'Criar conta',
                onLinkTap: _isLoading
                    ? null
                    : () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
