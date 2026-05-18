import 'package:flutter/material.dart';

import '../session/app_session.dart';
import '../theme/eventhub_colors.dart';
import '../widgets/auth_widgets.dart';
import 'home_placeholder.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptedTerms = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _createAccount() {
    AppSession.loginAsUser(
      _emailController.text,
      fullName: _nameController.text,
    );
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomePlaceholder()),
      (_) => false,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EventHubTextField(
              label: 'Nome completo',
              hint: 'Maria Silva',
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            EventHubTextField(
              label: 'E-mail',
              hint: 'nome@email.com',
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            const SizedBox(height: 16),
            EventHubTextField(
              label: 'Senha',
              hint: 'Mín. 8 caracteres',
              obscureText: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 16),
            EventHubTextField(
              label: 'Confirmar senha',
              hint: '••••••••',
              obscureText: true,
              controller: _confirmPasswordController,
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
                    onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
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
              onPressed: _createAccount,
            ),
            const SizedBox(height: 20),
            AuthLinkRow(
              prefix: 'Já tem conta?',
              linkLabel: 'Entrar',
              onLinkTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
