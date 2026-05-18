import 'package:flutter/material.dart';

import '../theme/eventhub_colors.dart';
import '../widgets/auth_widgets.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendRecoveryLink() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      header: const GradientAuthHeader(
        title: 'Recuperar senha',
        subtitle: 'EventHub',
      ),
      card: AuthWhiteCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Esqueceu a senha?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: EventHubColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Informe o e-mail da sua conta. Enviaremos um link para você '
              'redefinir a senha com segurança.',
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
            const SizedBox(height: 20),
            AuthPrimaryButton(
              label: 'Enviar link de recuperação',
              onPressed: _sendRecoveryLink,
            ),
            const SizedBox(height: 16),
            const Text(
              'Não recebeu? Verifique o spam ou tente outro e-mail.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: EventHubColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: EventHubColors.inputBorder),
            const SizedBox(height: 16),
            AuthTextLink(
              label: 'Voltar ao login',
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
