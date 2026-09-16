import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/widgets/app_toast.dart';
import 'auth_service.dart';

/// Pantalla de autenticación con PIN.
///
/// Modos:
///   * `PinMode.lock`      — pide PIN al abrir la app
///   * `PinMode.setup`     — crear un PIN nuevo
///   * `PinMode.confirm`   — confirmar el PIN recién creado
class PinScreen extends StatefulWidget {
  final PinMode mode;
  final VoidCallback? onSuccess;
  const PinScreen({
    super.key,
    this.mode = PinMode.lock,
    this.onSuccess,
  });

  @override
  State<PinScreen> createState() => _PinScreenState();
}

enum PinMode { lock, setup, confirm }

class _PinScreenState extends State<PinScreen> {
  String _entered = '';
  String? _firstSetupPin;
  bool _obscure = true;

  static const int _pinLength = 4;

  void _onDigit(String d) {
    if (_entered.length >= _pinLength) return;
    HapticFeedback.selectionClick();
    setState(() => _entered += d);
    if (_entered.length == _pinLength) {
      _evaluate();
    }
  }

  void _onBackspace() {
    if (_entered.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  Future<void> _evaluate() async {
    final pin = _entered;
    switch (widget.mode) {
      case PinMode.lock:
        final ok = await AuthService.verifyPin(pin);
        if (!mounted) return;
        if (ok) {
          if (widget.onSuccess != null) {
            widget.onSuccess!();
          } else {
            Navigator.of(context).pop(true);
          }
        } else {
          AppToast.danger(context, 'PIN incorrecto');
          setState(() => _entered = '');
        }
        break;
      case PinMode.setup:
        setState(() {
          _firstSetupPin = pin;
          _entered = '';
        });
        // Pasamos a confirmación: cerramos esta y abrimos una nueva.
        unawaited(
          Future<void>.microtask(() async {
            if (!mounted) return;
            final navigator = Navigator.of(context);
            await navigator.pushReplacement(
              MaterialPageRoute<bool>(
                builder: (_) => const PinScreen(mode: PinMode.confirm),
              ),
            );
          }),
        );
        break;
      case PinMode.confirm:
        if (_firstSetupPin == null) {
          // Caso raro: entrar en confirm sin haber pasado por setup.
          Navigator.of(context).pop(false);
          return;
        }
        if (pin == _firstSetupPin) {
          await AuthService.setPin(pin);
          if (!mounted) return;
          AppToast.success(context, 'PIN configurado');
          Navigator.of(context).pop(true);
        } else {
          if (!mounted) return;
          AppToast.danger(context, 'Los PIN no coinciden');
          setState(() => _entered = '');
        }
        break;
    }
  }

  String get _title {
    switch (widget.mode) {
      case PinMode.lock:
        return 'Ingresa tu PIN';
      case PinMode.setup:
        return 'Crea un PIN';
      case PinMode.confirm:
        return 'Confirma tu PIN';
    }
  }

  String get _subtitle {
    switch (widget.mode) {
      case PinMode.lock:
        return '4 dígitos para acceder';
      case PinMode.setup:
        return 'Lo usarás para abrir FoodBook';
      case PinMode.confirm:
        return 'Ingrésalo una vez más';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(FoodBookSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: FoodBookColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  widget.mode == PinMode.lock
                      ? Icons.lock_outline_rounded
                      : Icons.password_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: FoodBookSpacing.xl),
              Text(_title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: FoodBookSpacing.xs),
              Text(
                _subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: FoodBookSpacing.xxl),

              // Indicador de dígitos
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pinLength, (i) {
                  final filled = i < _entered.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                    ),
                  );
                }),
              ),

              const SizedBox(height: FoodBookSpacing.xxl),

              // Teclado numérico
              _NumberPad(
                onDigit: _onDigit,
                onBackspace: _onBackspace,
                obscure: _obscure,
                onToggleObscure: () => setState(() => _obscure = !_obscure),
              ),

              if (widget.mode == PinMode.lock)
                TextButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('¿Restablecer PIN?'),
                        content: const Text(
                          'Si olvidaste tu PIN, puedes restablecerlo. '
                          'Esto requiere borrar todos los datos locales.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Restablecer'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await AuthService.resetPin();
                      if (!mounted) return;
                      navigator.pop(false);
                    }
                  },
                  child: const Text('¿Olvidaste tu PIN?'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberPad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onToggleObscure;
  final bool obscure;

  const _NumberPad({
    required this.onDigit,
    required this.onBackspace,
    required this.onToggleObscure,
    required this.obscure,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['ocultar', '0', 'borrar'],
    ];
    return Column(
      children: rows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row.map((key) {
            return _PadKey(
              label: key,
              icon: key == 'borrar'
                  ? Icons.backspace_outlined
                  : (key == 'ocultar'
                      ? (obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined)
                      : null),
              onTap: () {
                if (key == 'borrar') {
                  onBackspace();
                } else if (key == 'ocultar') {
                  onToggleObscure();
                } else {
                  onDigit(key);
                }
              },
              theme: theme,
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _PadKey extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final ThemeData theme;

  const _PadKey({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Material(
          color: theme.colorScheme.surfaceContainerHigh,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: 64,
              width: 64,
              child: Center(
                child: icon != null
                    ? Icon(icon, size: 22, color: theme.colorScheme.onSurface)
                    : Text(
                        label,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
