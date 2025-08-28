import 'package:flutter/material.dart';
import 'dart:async';

mixin ToastMixin {
  static OverlayEntry? _overlayEntry;
  static Timer? _timer;

  void showToast(String string) {
    // Get current context
    final BuildContext? context = _getToastContext();
    if (context == null || !context.mounted) return;

    // Remove existing toast if any
    _dismissToast();

    // Get overlay from current context
    final overlay = Overlay.of(context);
    
    // Create toast widget
    _overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(message: string),
    );

    // Insert toast into overlay
    overlay.insert(_overlayEntry!);

    // Set timer to auto-dismiss after 5 seconds
    _timer = Timer(const Duration(seconds: 5), () {
      _dismissToast();
    });
  }

  static void _dismissToast() {
    _timer?.cancel();
    _timer = null;
    
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // Subclasses need to implement this method to provide BuildContext
  BuildContext? _getToastContext() {
    // If this is a State of StatefulWidget, return this.context
    if (this is State && (this as State).mounted) {
      return (this as State).context;
    }
    return null;
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;

  const _ToastWidget({required this.message});

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start entrance animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 40, // 40dp from bottom
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                widget.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
