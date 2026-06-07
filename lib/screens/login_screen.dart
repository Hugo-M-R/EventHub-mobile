import 'package:flutter/material.dart';

import '../services/auth_error_messages.dart';
import '../services/auth_service.dart';
import '../services/institutional_email_policy.dart';
import '../theme/eventhub_colors.dart';
import '../widgets/auth_widgets.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.accessDeniedMessage});

  final String? accessDeniedMessage;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.accessDeniedMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showError(widget.accessDeniedMessage!);
      });
    }
  }

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
    setState(() => _isGoogleLoading = true);
    try {
      await AuthService.instance.signInWithGoogle();
    } catch (error) {
      if (!mounted) return;
      _showError(authErrorMessage(error));
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool get _busy => _isLoading || _isGoogleLoading;

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
              Text(
                'Acesso exclusivo para ${InstitutionalEmailPolicy.institutionalDomain}',
                style: TextStyle(
                  fontSize: 14,
                  color: EventHubColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              EventHubTextField(
                label: 'E-mail institucional',
                hint: 'nome@souunit.com.br',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o e-mail';
                  }
                  return InstitutionalEmailPolicy.validationMessage(value);
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
                onTap: _busy
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
                onPressed: _busy ? null : _login,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(child: Divider(color: EventHubColors.inputBorder)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'ou',
                      style: TextStyle(color: EventHubColors.textSecondary),
                    ),
                  ),
                  const Expanded(child: Divider(color: EventHubColors.inputBorder)),
                ],
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _busy ? null : _loginWithGoogle,
                icon: _isGoogleLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.g_mobiledata, size: 28),
                label: const Text('Entrar com Google'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: EventHubColors.textPrimary,
                  side: const BorderSide(color: EventHubColors.inputBorder),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AuthLinkRow(
                prefix: 'Não tem conta?',
                linkLabel: 'Criar conta',
                onLinkTap: _busy
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
