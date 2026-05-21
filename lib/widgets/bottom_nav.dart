import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Copa Carnaval',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryYellow)),
        actions: [
          if (provider.isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings, color: Colors.redAccent),
              tooltip: 'Panel Admin',
              onPressed: () => context.go('/admin'),
            ),
          if (provider.userId == null)
            IconButton(
              icon: const Icon(Icons.login),
              tooltip: 'Iniciar sesión',
              onPressed: () => context.go('/login'),
            )
          else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    provider.userEmail?.split('@').first ?? '',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: provider.userId ?? ''),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('UID copiado al portapapeles'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text(
                      'ID: ${provider.userId?.substring(0, 8)}...',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Cerrar sesión',
              onPressed: () async {
                await provider.logout();
                if (context.mounted) context.go('/');
              },
            ),
          ],
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) {
          switch (i) {
            case 0: context.go('/');
            case 1: context.go('/posiciones');
            case 2: context.go('/partidos');
            case 3: context.go('/equipos');
            case 4: context.go('/eventos');
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events), label: 'Posiciones'),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_soccer), label: 'Partidos'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Equipos'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Eventos'),
        ],
      ),
    );
  }
}
