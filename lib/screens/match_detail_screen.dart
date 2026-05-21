import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class MatchDetailScreen extends StatelessWidget {
  final String matchId;

  const MatchDetailScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final match = provider.matches.where((m) => m.id == matchId).firstOrNull;

    if (match == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Partido')),
        body: const Center(child: Text('Partido no encontrado')),
      );
    }

    final isFinished = match.status == 'finished';
    final time =
        '${match.dateTime.hour.toString().padLeft(2, '0')}:${match.dateTime.minute.toString().padLeft(2, '0')}';
    final date =
        '${match.dateTime.day}/${match.dateTime.month}/${match.dateTime.year}';

    final team1Goals =
        match.goals.where((g) => g.teamId == match.team1Id).toList();
    final team2Goals =
        match.goals.where((g) => g.teamId == match.team2Id).toList();
    final team1Cards =
        match.cards.where((c) => c.teamId == match.team1Id).toList();
    final team2Cards =
        match.cards.where((c) => c.teamId == match.team2Id).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Partido')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (match.groupName != null)
              Chip(
                label: Text('Grupo ${match.groupName}'),
                backgroundColor: AppTheme.darkGray,
              ),
            Text('$date - $time',
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.shield, size: 40, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(match.team1Name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.darkGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isFinished
                        ? '${match.team1Score} - ${match.team2Score}'
                        : 'vs',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryYellow,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.shield, size: 40, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(match.team2Name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            if (match.refereeName != null) ...[
              const SizedBox(height: 16),
              Text('Árbitro: ${match.refereeName}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
            if (isFinished) ...[
              const SizedBox(height: 24),
              _SectionTitle('Goles'),
              ...team1Goals.map((g) => _GoalRow(g, match.team1Name, true)),
              ...team2Goals.map((g) => _GoalRow(g, match.team2Name, false)),
              if (match.goals.isEmpty)
                const Text('Sin goles', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              _SectionTitle('Tarjetas'),
              ...team1Cards.map((c) => _CardRow(c, match.team1Name)),
              ...team2Cards.map((c) => _CardRow(c, match.team2Name)),
              if (match.cards.isEmpty)
                const Text('Sin tarjetas',
                    style: TextStyle(color: Colors.grey)),
            ],
            if (!isFinished) ...[
              const SizedBox(height: 32),
              const Text('Partido aún no jugado',
                  style: TextStyle(color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _SectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryYellow)),
    );
  }

  Widget _GoalRow(dynamic goal, String teamName, bool isLocal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isLocal ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isLocal) ...[
            const Icon(Icons.sports_soccer,
                size: 18, color: AppTheme.primaryYellow),
            const SizedBox(width: 8),
            Text('${goal.playerName} ${goal.minute}\'',
                style: const TextStyle(fontSize: 14)),
            if (goal.isOwnGoal)
              const Text(' (en contra)', style: TextStyle(color: Colors.red)),
          ] else ...[
            Text('${goal.playerName} ${goal.minute}\'',
                style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 8),
            const Icon(Icons.sports_soccer,
                size: 18, color: AppTheme.primaryYellow),
          ],
        ],
      ),
    );
  }

  Widget _CardRow(dynamic card, String teamName) {
    final isYellow = card.type == 'yellow';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isYellow ? Icons.rectangle : Icons.square,
            size: 18,
            color: isYellow ? Colors.yellow : Colors.red,
          ),
          const SizedBox(width: 8),
          Text('${card.playerName} ${card.minute}\'',
              style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
