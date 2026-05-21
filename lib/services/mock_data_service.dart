import '../models/team.dart';
import '../models/player.dart';
import '../models/match.dart';
import '../models/referee.dart';
import '../models/bet.dart';
import '../models/tournament.dart';
import '../models/event.dart';
import 'data_service.dart';

class MockDataService implements DataService {
  List<Team> _teams = [];
  List<Player> _players = [];
  List<Match> _matches = [];
  List<Referee> _referees = [];
  List<Bet> _bets = [];
  Tournament? _tournament;
  List<Event> _events = [];

  MockDataService() {
    _initMockData();
  }

  void _initMockData() {
    _tournament = Tournament(
      id: 't1',
      name: 'Copa Carnaval',
      city: 'Lincoln',
      startDate: DateTime(2026, 12, 25),
      endDate: DateTime(2026, 12, 30),
    );

    _referees = [
      Referee(id: 'r1', name: 'Carlos Gómez'),
      Referee(id: 'r2', name: 'Juan Pérez'),
      Referee(id: 'r3', name: 'Luis Martínez'),
      Referee(id: 'r4', name: 'Andrés López'),
    ];

    final teamNames = {
      'A': ['Club Atlético Lincoln', 'DEF y Justicia Lincoln', 'Sportivo Lincoln'],
      'B': ['Barrio Norte FC', 'Unión de Lincoln', 'Juventud Unida'],
      'C': ['El Linqueño', 'Atlético Roberts', 'Social de Arenales'],
      'D': ['Ferrocarril Midland', 'Club Argentino', 'Independiente de'],
    };

    int teamIdx = 0;
    for (final group in teamNames.entries) {
      for (final name in group.value) {
        _teams.add(Team(
          id: 'team_$teamIdx',
          name: name,
          groupName: group.key,
        ));
        for (int p = 1; p <= 11; p++) {
          _players.add(Player(
            id: 'player_${teamIdx}_$p',
            name: 'Jugador ${group.key}_${teamIdx}_$p',
            number: p,
            teamId: 'team_$teamIdx',
          ));
        }
        teamIdx++;
      }
    }

    final startDate = DateTime(2026, 12, 25);
    int matchId = 0;
    int dayNum = 1;

    for (final group in ['A', 'B', 'C', 'D']) {
      final gTeams = _teams.where((t) => t.groupName == group).toList();
      for (int i = 0; i < gTeams.length; i++) {
        for (int j = i + 1; j < gTeams.length; j++) {
          _matches.add(Match(
            id: 'match_$matchId',
            round: 'group',
            groupName: group,
            team1Id: gTeams[i].id,
            team1Name: gTeams[i].name,
            team2Id: gTeams[j].id,
            team2Name: gTeams[j].name,
            dateTime: startDate.add(Duration(days: dayNum - 1))
                .add(Duration(hours: 14 + (matchId % 4) * 2)),
            refereeId: _referees[matchId % _referees.length].id,
            refereeName: _referees[matchId % _referees.length].name,
            status: 'scheduled',
            dayNumber: dayNum,
          ));
          matchId++;
          dayNum = (matchId % 4 == 0) ? dayNum + 1 : dayNum;
        }
      }
      if (matchId > 12) {
        while (matchId > 12 && matchId < 16) {
          dayNum++;
          matchId++;
        }
      }
    }

    matchId = 12;
    for (int day = 4; day <= 6; day++) {
      int matchesThisDay = (day == 4) ? 4 : (day == 5) ? 2 : 1;
      String round = (day == 4) ? 'quarter' : (day == 5) ? 'semi' : 'final';
      for (int m = 0; m < matchesThisDay; m++) {
        _matches.add(Match(
          id: 'match_$matchId',
          round: round,
          team1Id: _teams[matchId % _teams.length].id,
          team1Name: _teams[matchId % _teams.length].name,
          team2Id: _teams[(matchId + 1) % _teams.length].id,
          team2Name: _teams[(matchId + 1) % _teams.length].name,
          dateTime: startDate.add(Duration(days: day - 1))
              .add(Duration(hours: 14 + m * 2)),
          refereeId: _referees[matchId % _referees.length].id,
          refereeName: _referees[matchId % _referees.length].name,
          status: 'scheduled',
          dayNumber: day,
        ));
        matchId++;
      }
    }
  }

  @override
  Future<List<Team>> getTeams() async => _teams;

  @override
  Future<void> addTeam(Team team) async => _teams.add(team);

  @override
  Future<void> updateTeam(Team team) async {
    final i = _teams.indexWhere((t) => t.id == team.id);
    if (i != -1) _teams[i] = team;
  }

  @override
  Future<void> deleteTeam(String teamId) async =>
      _teams.removeWhere((t) => t.id == teamId);

  @override
  Future<List<Player>> getPlayers(String teamId) async =>
      _players.where((p) => p.teamId == teamId).toList();

  @override
  Future<void> addPlayer(Player player) async => _players.add(player);

  @override
  Future<void> updatePlayer(Player player) async {
    final i = _players.indexWhere((p) => p.id == player.id);
    if (i != -1) _players[i] = player;
  }

  @override
  Future<void> deletePlayer(String playerId) async =>
      _players.removeWhere((p) => p.id == playerId);

  @override
  Future<List<Match>> getMatches() async => _matches;

  @override
  Future<List<Match>> getMatchesByDay(int day) async =>
      _matches.where((m) => m.dayNumber == day).toList();

  @override
  Future<void> addMatch(Match match) async => _matches.add(match);

  @override
  Future<void> updateMatch(Match match) async {
    final i = _matches.indexWhere((m) => m.id == match.id);
    if (i != -1) _matches[i] = match;
  }

  @override
  Future<void> deleteMatch(String matchId) async =>
      _matches.removeWhere((m) => m.id == matchId);

  @override
  Future<List<Referee>> getReferees() async => _referees;

  @override
  Future<void> addReferee(Referee referee) async => _referees.add(referee);

  @override
  Future<void> deleteReferee(String refereeId) async =>
      _referees.removeWhere((r) => r.id == refereeId);

  @override
  Future<List<Bet>> getBets(String matchId) async =>
      _bets.where((b) => b.matchId == matchId).toList();

  @override
  Future<void> placeBet(Bet bet) async => _bets.add(bet);

  @override
  Future<bool> hasUserBet(String userId, String matchId) async =>
      _bets.any((b) => b.userId == userId && b.matchId == matchId);

  @override
  Future<Tournament?> getTournament() async => _tournament;

  @override
  Future<void> saveTournament(Tournament tournament) async =>
      _tournament = tournament;

  @override
  Future<List<Event>> getEvents() async => _events;

  @override
  Future<void> addEvent(Event event) async => _events.add(event);

  @override
  Future<void> deleteEvent(String eventId) async =>
      _events.removeWhere((e) => e.id == eventId);

  @override
  Future<bool> isAdmin(String userId) async => false;
}
