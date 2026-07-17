import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'services/firebase_data_service.dart';
import 'screens/home_screen.dart';
import 'screens/standings_screen.dart';
import 'screens/matches_screen.dart';
import 'screens/match_detail_screen.dart';
import 'screens/teams_screen.dart';
import 'screens/team_detail_screen.dart';
import 'screens/events_screen.dart';
import 'screens/betting_screen.dart';
import 'screens/login_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/admin/manage_teams_screen.dart';
import 'screens/admin/manage_players_screen.dart';
import 'screens/admin/manage_matches_screen.dart';
import 'screens/admin/manage_referees_screen.dart';
import 'screens/admin/edit_match_result_screen.dart';
import 'widgets/back_to_home.dart';
import 'theme/app_theme.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final path = state.uri.path;
    if (!path.startsWith('/admin')) return null;
    final provider = context.read<AppProvider>();
    if (provider.userId == null) return '/login';
    if (!provider.isAdmin) return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/posiciones', builder: (_, __) => const StandingsScreen()),
    GoRoute(path: '/partidos', builder: (_, __) => const MatchesScreen()),
    GoRoute(
      path: '/partido/:id',
      builder: (_, state) => BackToHome(
        child: MatchDetailScreen(matchId: state.pathParameters['id']!),
      ),
    ),
    GoRoute(path: '/equipos', builder: (_, __) => const TeamsScreen()),
    GoRoute(
      path: '/equipo/:id',
      builder: (_, state) => BackToHome(
        child: TeamDetailScreen(teamId: state.pathParameters['id']!),
      ),
    ),
    GoRoute(path: '/eventos', builder: (_, __) => const EventsScreen()),
    GoRoute(
        path: '/apuestas',
        builder: (_, __) => const BackToHome(child: BettingScreen())),
    GoRoute(
        path: '/login',
        builder: (_, __) => const BackToHome(child: LoginScreen())),
    GoRoute(
        path: '/admin',
        builder: (_, __) => const BackToHome(child: AdminDashboard())),
    GoRoute(
        path: '/admin/equipos',
        builder: (_, __) => const BackToHome(child: ManageTeamsScreen())),
    GoRoute(
      path: '/admin/equipo/:id/jugadores',
      builder: (_, state) => BackToHome(
        child: ManagePlayersScreen(teamId: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
        path: '/admin/partidos',
        builder: (_, __) => const BackToHome(child: ManageMatchesScreen())),
    GoRoute(
      path: '/admin/partido/:id/resultado',
      builder: (_, state) => BackToHome(
        child: EditMatchResultScreen(matchId: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
        path: '/admin/arbitros',
        builder: (_, __) => const BackToHome(child: ManageRefereesScreen())),
  ],
);

class CopaCarnavalApp extends StatelessWidget {
  const CopaCarnavalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(service: FirebaseDataService()),
      child: MaterialApp.router(
        title: 'Copa Carnaval',
        theme: AppTheme.darkTheme,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
