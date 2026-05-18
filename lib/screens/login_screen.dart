import 'package:flutter/material.dart';

import '../session/app_session.dart';
import '../theme/eventhub_colors.dart';
import '../widgets/auth_widgets.dart';
import 'forgot_password_screen.dart';
import 'home_placeholder.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    AppSession.loginAsUser(_emailController.text);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePlaceholder()),
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
            ),
            const SizedBox(height: 16),
            EventHubTextField(
              label: 'Senha',
              hint: '••••••••',
              obscureText: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 8),
            AuthTextLink(
              label: 'Esqueci minha senha',
              align: Alignment.centerRight,
              compact: true,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ForgotPasswordScreen(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AuthPrimaryButton(label: 'Entrar', onPressed: _login),
            const SizedBox(height: 20),
            AuthLinkRow(
              prefix: 'Não tem conta?',
              linkLabel: 'Criar conta',
              onLinkTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RegisterScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
