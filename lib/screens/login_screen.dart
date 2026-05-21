import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.primaryYellow,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(Icons.person,
                    size: 56, color: AppTheme.primaryBlack),
              ),
              const SizedBox(height: 24),
              const Text('Iniciá sesión para apostar',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'Apostá a los resultados de los partidos\ny competí con otros usuarios',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _googleSignIn(context),
                  icon: const Icon(Icons.login, color: AppTheme.primaryBlack),
                  label: const Text('Ingresar con Google',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _mockLogin(context),
                child: const Text('Entrar como invitado',
                    style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _googleSignIn(BuildContext context) async {
    try {
      UserCredential result;

      if (kIsWeb) {
        result = await FirebaseAuth.instance.signInWithPopup(
          GoogleAuthProvider(),
        );
      } else {
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return;
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        result = await FirebaseAuth.instance.signInWithCredential(credential);
      }

      final user = result.user;
      if (user != null && context.mounted) {
        context.read<AppProvider>().login(user.uid, user.email ?? '');
        context.go('/');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bienvenido, ${user.displayName ?? "Usuario"}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión: $e')),
        );
      }
    }
  }

  Future<void> _mockLogin(BuildContext context) async {
    await context.read<AppProvider>().login(
        'guest_${DateTime.now().millisecondsSinceEpoch}', 'invitado@email.com');
    if (context.mounted) {
      context.go('/');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Iniciaste sesión como invitado')),
      );
    }
  }
}
