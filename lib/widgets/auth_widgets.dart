import 'package:flutter/material.dart';

import '../theme/eventhub_colors.dart';

class AuthPageLayout extends StatelessWidget {
  const AuthPageLayout({
    super.key,
    required this.header,
    required this.card,
    this.belowCard,
  });

  final Widget header;
  final Widget card;
  final Widget? belowCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHubColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 48,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: EventHubColors.loginMaxWidth,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              header,
                              Transform.translate(
                                offset: const Offset(0, -36),
                                child: card,
                              ),
                              if (belowCard != null) ...[
                                const SizedBox(height: 4),
                                belowCard!,
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'v1 · EventHub',
                style: TextStyle(
                  fontSize: 12,
                  color: EventHubColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientAuthHeader extends StatelessWidget {
  const GradientAuthHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: subtitle == null ? 168 : 180,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [EventHubColors.purple, EventHubColors.orange],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AuthWhiteCard extends StatelessWidget {
  const AuthWhiteCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: EventHubColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class EventHubTextField extends StatelessWidget {
  const EventHubTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: EventHubColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: EventHubColors.textMuted),
            filled: true,
            fillColor: EventHubColors.inputFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: EventHubColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: EventHubColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: EventHubColors.orangeButton,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Botão principal com hover/pressed mais escuro e leve elevação.
class AuthPrimaryButton extends StatefulWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  State<AuthPrimaryButton> createState() => _AuthPrimaryButtonState();
}

class _AuthPrimaryButtonState extends State<AuthPrimaryButton> {
  bool _hovered = false;
  bool _pressed = false;

  Color get _background {
    if (_pressed) return EventHubColors.orangeButtonPressed;
    if (_hovered) return EventHubColors.orangeButtonHover;
    return EventHubColors.orangeButton;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: _background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered || _pressed
                  ? EventHubColors.orangeButtonPressed
                  : EventHubColors.orangeButtonHover.withValues(alpha: 0.5),
              width: _hovered || _pressed ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: EventHubColors.orangeButton.withValues(
                  alpha: _hovered ? 0.45 : 0.25,
                ),
                blurRadius: _hovered ? 12 : 6,
                offset: Offset(0, _hovered ? 4 : 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Link/ação secundária com borda, fundo no hover e sublinhado.
class AuthTextLink extends StatefulWidget {
  const AuthTextLink({
    super.key,
    required this.label,
    required this.onTap,
    this.align = Alignment.center,
    this.compact = false,
  });

  final String label;
  final VoidCallback onTap;
  final Alignment align;
  final bool compact;

  @override
  State<AuthTextLink> createState() => _AuthTextLinkState();
}

class _AuthTextLinkState extends State<AuthTextLink> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final padding = widget.compact
        ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
        : const EdgeInsets.symmetric(horizontal: 14, vertical: 10);

    return Align(
      alignment: widget.align,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() {
          _hovered = false;
          _pressed = false;
        }),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: padding,
            child: Text(
              widget.label,
              style: TextStyle(
                color: _pressed
                    ? EventHubColors.orangeButtonPressed
                    : EventHubColors.orangeButton,
                fontWeight: FontWeight.w700,
                fontSize: widget.compact ? 14 : 15,
                decoration: TextDecoration.underline,
                decorationColor: EventHubColors.orangeButton.withValues(
                  alpha: _hovered ? 1 : 0.6,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Linha “texto + link” com link interativo.
class AuthLinkRow extends StatelessWidget {
  const AuthLinkRow({
    super.key,
    required this.prefix,
    required this.linkLabel,
    required this.onLinkTap,
  });

  final String prefix;
  final String linkLabel;
  final VoidCallback onLinkTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: [
        Text(
          prefix,
          style: const TextStyle(color: EventHubColors.textSecondary),
        ),
        AuthTextLink(
          label: linkLabel,
          onTap: onLinkTap,
          compact: true,
        ),
      ],
    );
  }
}
