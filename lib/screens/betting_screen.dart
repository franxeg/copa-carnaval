import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/bet.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class BettingScreen extends StatelessWidget {
  const BettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    if (provider.userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Apuestas')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Iniciá sesión para apostar',
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Iniciar Sesión'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final upcomingMatches = provider.matches
        .where((m) => m.status == 'scheduled')
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Apuestas')),
      body: upcomingMatches.isEmpty
          ? const Center(child: Text('No hay partidos disponibles para apostar'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: upcomingMatches.length,
              itemBuilder: (_, i) =>
                  _BetMatchCard(match: upcomingMatches[i]),
            ),
    );
  }
}

class _BetMatchCard extends StatefulWidget {
  final dynamic match;
  const _BetMatchCard({required this.match});

  @override
  State<_BetMatchCard> createState() => _BetMatchCardState();
}

class _BetMatchCardState extends State<_BetMatchCard> {
  final _score1Ctrl = TextEditingController();
  final _score2Ctrl = TextEditingController();
  bool _hasBet = false;

  @override
  void initState() {
    super.initState();
    _checkBet();
  }

  void _checkBet() async {
    final p = context.read<AppProvider>();
    final hasBet = await p.hasUserBet(widget.match.id);
    if (mounted) setState(() => _hasBet = hasBet);
  }

  @override
  void dispose() {
    _score1Ctrl.dispose();
    _score2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final match = widget.match;
    final time =
        '${match.dateTime.hour.toString().padLeft(2, '0')}:${match.dateTime.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (match.groupName != null)
                  Chip(
                    label: Text('Grupo ${match.groupName}',
                        style: const TextStyle(fontSize: 11)),
                    backgroundColor: AppTheme.darkGray,
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                Text(time,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: Text(match.team1Name,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500))),
                const SizedBox(width: 12),
                if (!_hasBet) ...[
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _score1Ctrl,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: '0',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('-', style: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _score2Ctrl,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: '0',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      ),
                    ),
                  ),
                ] else ...[
                  const Icon(Icons.check_circle,
                      color: Colors.green, size: 24),
                  const Text('¡Apostado!',
                      style: TextStyle(color: Colors.green)),
                ],
                const SizedBox(width: 12),
                Expanded(
                    child: Text(match.team2Name,
                        style: const TextStyle(fontWeight: FontWeight.w500))),
              ],
            ),
            if (!_hasBet) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _placeBet(context),
                  child: const Text('Apostar'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _placeBet(BuildContext context) {
    final s1 = int.tryParse(_score1Ctrl.text) ?? 0;
    final s2 = int.tryParse(_score2Ctrl.text) ?? 0;
    final p = context.read<AppProvider>();

    p.placeBet(Bet(
      id: 'bet_${DateTime.now().millisecondsSinceEpoch}',
      userId: p.userId!,
      userEmail: p.userEmail ?? '',
      matchId: widget.match.id,
      predictedTeam1Score: s1,
      predictedTeam2Score: s2,
      timestamp: DateTime.now(),
    ));

    setState(() => _hasBet = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apuesta registrada')),
    );
  }
}
