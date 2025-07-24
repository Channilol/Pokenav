import 'package:flutter/material.dart';

class PulsingShadowWrapper extends StatefulWidget {
  const PulsingShadowWrapper({
    super.key,
    required this.child,
    required this.onTap,
    required this.colorOnTap,
    required this.isLoading,
    required this.current,
    required this.total,
    required this.colors,
    this.pulseDuration = const Duration(milliseconds: 1000),
    this.shadowBlurRadius = 20.0,
    this.shadowSpreadRadius = 2.0,
  });

  final Widget child;
  final VoidCallback onTap;
  final Color colorOnTap;
  final bool isLoading;
  final double current;
  final double total;
  final List<Color> colors;
  final Duration pulseDuration;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;

  @override
  State<PulsingShadowWrapper> createState() => _PulsingShadowWrapperState();
}

class _PulsingShadowWrapperState extends State<PulsingShadowWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    );

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );

    // Avvia l'animazione pulse
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _getCurrentShadowColor() {
    // Se è stato toccato, usa il colore onTap
    if (_isTapped) {
      return widget.colorOnTap;
    }

    // Se è in loading, calcola il colore basandosi sul progresso
    if (widget.isLoading && widget.colors.isNotEmpty) {
      if (widget.total <= 0) return widget.colors.first;

      final double stepSize = widget.total / widget.colors.length;
      final int colorIndex = (widget.current / stepSize).floor().clamp(
        0,
        widget.colors.length - 1,
      );

      return widget.colors[colorIndex];
    }

    // Default: primo colore della lista o trasparente se vuota
    return widget.colors.isNotEmpty ? widget.colors.first : Colors.transparent;
  }

  void _handleTap() {
    setState(() {
      _isTapped = true;
    });

    widget.onTap();

    // Reset del tap dopo un breve delay
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _isTapped = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          final currentColor = _getCurrentShadowColor();
          final pulseIntensity =
              0.3 + (_pulseAnimation.value * 0.7); // Da 0.3 a 1.0

          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: currentColor.withOpacity(pulseIntensity * 0.6),
                  blurRadius: widget.shadowBlurRadius * pulseIntensity,
                  spreadRadius: widget.shadowSpreadRadius * pulseIntensity,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}
