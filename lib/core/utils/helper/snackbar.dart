import 'package:flutter/material.dart';

import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/extension/extension.dart';

DateTime? _lastSnackBarTime;

void showSnackBar(
  BuildContext context, {
  String? message,
  Color? color,
  int? durationInMilliseconds,
}) {
  final now = DateTime.now();

  if (_lastSnackBarTime != null &&
      now.difference(_lastSnackBarTime!) < const Duration(seconds: 1)) {
    return;
  }

  _lastSnackBarTime = now;

  final overlay = Overlay.of(context);
  late final OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => TopSnackBar(
      message: message ?? "There was an error, please try again later!",
      color: color ?? ColorManager.purple,
      durationInMilliseconds: durationInMilliseconds ?? 2500,
      onRemove: () => overlayEntry.remove(), // Pass the remove function
    ),
  );

  overlay.insert(overlayEntry);
}

class TopSnackBar extends StatefulWidget {
  final String message;
  final Color color;
  final int durationInMilliseconds;
  final VoidCallback onRemove; // Callback to remove the overlay entry

  const TopSnackBar({
    super.key,
    required this.message,
    required this.color,
    required this.durationInMilliseconds,
    required this.onRemove,
  });

  @override
  State<TopSnackBar> createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<TopSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();

    _animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(Duration(milliseconds: widget.durationInMilliseconds), () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) {
            widget.onRemove(); // Call the callback to remove the overlay entry
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SlideTransition(
            position: _animation,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25),
                  ),
                  child: Container(
                    color: widget.color.withOpacity(0.95),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    child: Center(
                      child: Text(
                        widget.message,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
