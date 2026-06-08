import 'package:flutter/material.dart';

import '../services/auth_error_messages.dart';
import '../services/auth_service.dart';
import '../theme/eventhub_colors.dart';
import '../widgets/auth_widgets.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptedTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedTerms) {
      _showError('Aceite os termos para continuar.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.registerWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
        fullName: _nameController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      _showError(authErrorMessage(error));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _registerWithGoogle() async {
    if (!_acceptedTerms) {
      _showError('Aceite os termos para continuar.');
      return;
    }
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
        title: 'Criar conta',
        subtitle: 'Participe da cultura local com o EventHub',
      ),
      card: AuthWhiteCard(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EventHubTextField(
                label: 'Nome completo',
                hint: 'Maria Silva',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
                hint: 'Mín. 6 caracteres',
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              EventHubTextField(
                label: 'Confirmar senha',
                hint: '••••••••',
                obscureText: true,
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _acceptedTerms,
                      activeColor: EventHubColors.orangeButton,
                      onChanged: _isLoading
                          ? null
                          : (value) {
                              setState(() => _acceptedTerms = value ?? false);
                            },
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Li e aceito os termos de uso e a privacidade',
                      style: TextStyle(
                        fontSize: 13,
                        color: EventHubColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AuthPrimaryButton(
                label: 'Criar minha conta',
                isLoading: _isLoading,
                onPressed: _createAccount,
              ),
              const SizedBox(height: 16),
              const AuthOrDivider(),
              const SizedBox(height: 16),
              GoogleSignInButton(
                label: 'Continuar com Google',
                isLoading: _isLoading,
                onPressed: _registerWithGoogle,
              ),
              const SizedBox(height: 20),
              AuthLinkRow(
                prefix: 'Já tem conta?',
                linkLabel: 'Entrar',
                onLinkTap: _isLoading
                    ? null
                    : () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
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
