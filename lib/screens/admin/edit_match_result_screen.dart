import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/match.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';

class EditMatchResultScreen extends StatefulWidget {
  final String matchId;
  const EditMatchResultScreen({super.key, required this.matchId});

  @override
  State<EditMatchResultScreen> createState() => _EditMatchResultScreenState();
}

class _EditMatchResultScreenState extends State<EditMatchResultScreen> {
  late TextEditingController _score1Ctrl;
  late TextEditingController _score2Ctrl;
  final _goalPlayerCtrl = TextEditingController();
  final _goalMinuteCtrl = TextEditingController();
  String _goalTeam = '';
  final _cardPlayerCtrl = TextEditingController();
  final _cardMinuteCtrl = TextEditingController();
  String _cardType = 'yellow';
  String _cardTeam = '';
  List<Map<String, dynamic>> _goals = [];
  List<Map<String, dynamic>> _cards = [];

  @override
  void initState() {
    super.initState();
    _score1Ctrl = TextEditingController();
    _score2Ctrl = TextEditingController();
    final provider = context.read<AppProvider>();
    final match = provider.matches.where((m) => m.id == widget.matchId).firstOrNull;
    if (match != null && match.status == 'finished') {
      _score1Ctrl.text = '${match.team1Score ?? 0}';
      _score2Ctrl.text = '${match.team2Score ?? 0}';
      _goals = match.goals
          .map((g) => {
                'playerName': g.playerName,
                'minute': g.minute,
                'teamId': g.teamId,
                'isOwnGoal': g.isOwnGoal,
              })
          .toList();
      _cards = match.cards
          .map((c) => {
                'playerName': c.playerName,
                'minute': c.minute,
                'teamId': c.teamId,
                'type': c.type,
              })
          .toList();
    }
  }

  @override
  void dispose() {
    _score1Ctrl.dispose();
    _score2Ctrl.dispose();
    _goalPlayerCtrl.dispose();
    _goalMinuteCtrl.dispose();
    _cardPlayerCtrl.dispose();
    _cardMinuteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final match = provider.matches.where((m) => m.id == widget.matchId).firstOrNull;

    if (match == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resultado')),
        body: const Center(child: Text('Partido no encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cargar Resultado')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('${match.team1Name}  vs  ${match.team2Name}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _score1Ctrl,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              labelText: match.team1Name,
                              labelStyle:
                                  const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('-',
                              style: TextStyle(fontSize: 24)),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _score2Ctrl,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              labelText: match.team2Name,
                              labelStyle:
                                  const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _saveResult(context, match),
                        child: const Text('Guardar Resultado'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Goles',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryYellow)),
            const SizedBox(height: 8),
            ..._goals.map((g) => ListTile(
                  dense: true,
                  title: Text(
                      '${g['playerName']} ${g['minute']}\' ${g['isOwnGoal'] ? "(e/c)" : ""}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: () =>
                        setState(() => _goals.remove(g)),
                  ),
                )),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _goalPlayerCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Jugador', isDense: true),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _goalMinuteCtrl,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Min', isDense: true),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _goalTeam.isEmpty ? null : _goalTeam,
                  hint: const Text('Eq', style: TextStyle(fontSize: 12)),
                  items: [
                    DropdownMenuItem(
                        value: match.team1Id,
                        child: Text(match.team1Name.split(' ').last,
                            style: const TextStyle(fontSize: 12))),
                    DropdownMenuItem(
                        value: match.team2Id,
                        child: Text(match.team2Name.split(' ').last,
                            style: const TextStyle(fontSize: 12))),
                  ],
                  onChanged: (v) => setState(() => _goalTeam = v!),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle,
                      color: AppTheme.primaryYellow),
                  onPressed: () {
                    if (_goalPlayerCtrl.text.isEmpty) return;
                    setState(() {
                      _goals.add({
                        'playerName': _goalPlayerCtrl.text,
                        'minute': int.tryParse(_goalMinuteCtrl.text) ?? 0,
                        'teamId': _goalTeam,
                        'isOwnGoal': false,
                      });
                      _goalPlayerCtrl.clear();
                      _goalMinuteCtrl.clear();
                      _goalTeam = '';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Tarjetas',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryYellow)),
            const SizedBox(height: 8),
            ..._cards.map((c) => ListTile(
                  dense: true,
                  leading: Icon(
                    c['type'] == 'yellow'
                        ? Icons.rectangle
                        : Icons.square,
                    size: 18,
                    color: c['type'] == 'yellow'
                        ? Colors.yellow
                        : Colors.red,
                  ),
                  title: Text('${c['playerName']} ${c['minute']}\''),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: () =>
                        setState(() => _cards.remove(c)),
                  ),
                )),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cardPlayerCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Jugador', isDense: true),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _cardMinuteCtrl,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Min', isDense: true),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _cardTeam.isEmpty ? null : _cardTeam,
                  hint: const Text('Eq', style: TextStyle(fontSize: 12)),
                  items: [
                    DropdownMenuItem(
                        value: match.team1Id,
                        child: Text(match.team1Name.split(' ').last,
                            style: const TextStyle(fontSize: 12))),
                    DropdownMenuItem(
                        value: match.team2Id,
                        child: Text(match.team2Name.split(' ').last,
                            style: const TextStyle(fontSize: 12))),
                  ],
                  onChanged: (v) => setState(() => _cardTeam = v!),
                ),
                const SizedBox(width: 4),
                DropdownButton<String>(
                  value: _cardType,
                  items: const [
                    DropdownMenuItem(
                        value: 'yellow',
                        child: Text('Amarilla',
                            style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(
                        value: 'red',
                        child: Text('Roja',
                            style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (v) => setState(() => _cardType = v!),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle,
                      color: AppTheme.primaryYellow),
                  onPressed: () {
                    if (_cardPlayerCtrl.text.isEmpty) return;
                    setState(() {
                      _cards.add({
                        'playerName': _cardPlayerCtrl.text,
                        'minute': int.tryParse(_cardMinuteCtrl.text) ?? 0,
                        'teamId': _cardTeam,
                        'type': _cardType,
                      });
                      _cardPlayerCtrl.clear();
                      _cardMinuteCtrl.clear();
                      _cardTeam = '';
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveResult(BuildContext context, Match match) {
    final s1 = int.tryParse(_score1Ctrl.text) ?? 0;
    final s2 = int.tryParse(_score2Ctrl.text) ?? 0;

    final updated = match.copyWith(
      status: 'finished',
      team1Score: s1,
      team2Score: s2,
      goals: _goals
          .map((g) => Goal(
                id: 'g_${DateTime.now().millisecondsSinceEpoch}_${_goals.indexOf(g)}',
                playerId: '',
                playerName: g['playerName'] as String,
                teamId: g['teamId'] as String,
                minute: g['minute'] as int,
                isOwnGoal: g['isOwnGoal'] as bool? ?? false,
              ))
          .toList(),
      cards: _cards
          .map((c) => MatchCard(
                id: 'c_${DateTime.now().millisecondsSinceEpoch}_${_cards.indexOf(c)}',
                playerId: '',
                playerName: c['playerName'] as String,
                teamId: c['teamId'] as String,
                minute: c['minute'] as int,
                type: c['type'] as String,
              ))
          .toList(),
    );

    context.read<AppProvider>().updateMatch(updated);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resultado guardado')),
    );
  }
}
