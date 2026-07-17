import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackToHome extends StatelessWidget {
  final Widget child;
  const BackToHome({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        context.go('/');
      },
      child: child,
    );
  }
}
