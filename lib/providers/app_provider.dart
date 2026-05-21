import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/team.dart';
import '../models/player.dart';
import '../models/match.dart';
import '../models/referee.dart';
import '../models/bet.dart';
import '../models/tournament.dart';
import '../models/event.dart';
import '../services/data_service.dart';
import '../services/mock_data_service.dart';

class AppProvider extends ChangeNotifier {
  final DataService _service;

  AppProvider({DataService? service}) : _service = service ?? MockDataService();

  List<Team> _teams = [];
  List<Match> _matches = [];
  List<Referee> _referees = [];
  Tournament? _tournament;
  List<Event> _events = [];
  bool _isLoading = false;
  String? _userId;
  String? _userEmail;
  bool _isAdmin = false;

  List<Team> get teams => _teams;
  List<Match> get matches => _matches;
  List<Referee> get referees => _referees;
  Tournament? get tournament => _tournament;
  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  bool get isAdmin => _isAdmin;

  List<String> get groupNames => ['A', 'B', 'C', 'D'];

  List<Team> getTeamsByGroup(String group) =>
      _teams.where((t) => t.groupName == group).toList();

  List<Match> getMatchesByDay(int day) =>
      _matches.where((m) => m.dayNumber == day).toList();

  List<Match> getGroupMatches(String group) =>
      _matches.where((m) => m.groupName == group).toList();

  List<Match> getPlayoffMatches() =>
      _matches.where((m) => m.round != 'group').toList();

  Future<List<Player>> getPlayers(String teamId) =>
      _service.getPlayers(teamId);

  int getTeamStandingPoints(String teamId, String group) {
    int pts = 0;
    for (final m in _matches.where((m) =>
        m.groupName == group &&
        (m.team1Id == teamId || m.team2Id == teamId) &&
        m.status == 'finished')) {
      if (m.team1Score != null && m.team2Score != null) {
        if (m.team1Id == teamId) {
          if (m.team1Score! > m.team2Score!) {
            pts += 3;
          } else if (m.team1Score == m.team2Score) {
            pts += 1;
          }
        } else {
          if (m.team2Score! > m.team1Score!) {
            pts += 3;
          } else if (m.team1Score == m.team2Score) {
            pts += 1;
          }
        }
      }
    }
    return pts;
  }

  int getTeamGoalsFor(String teamId, String group) {
    int g = 0;
    for (final m in _matches.where((m) =>
        m.groupName == group &&
        (m.team1Id == teamId || m.team2Id == teamId) &&
        m.status == 'finished')) {
      if (m.team1Score != null) {
        if (m.team1Id == teamId) g += m.team1Score!;
        else g += m.team2Score!;
      }
    }
    return g;
  }

  int getTeamGoalsAgainst(String teamId, String group) {
    int g = 0;
    for (final m in _matches.where((m) =>
        m.groupName == group &&
        (m.team1Id == teamId || m.team2Id == teamId) &&
        m.status == 'finished')) {
      if (m.team1Score != null) {
        if (m.team1Id == teamId) g += m.team2Score!;
        else g += m.team1Score!;
      }
    }
    return g;
  }

  List<Map<String, dynamic>> getStandings(String group) {
    final teams = getTeamsByGroup(group);
    final standings = <Map<String, dynamic>>[];
    for (final t in teams) {
      standings.add({
        'team': t,
        'pts': getTeamStandingPoints(t.id, group),
        'gf': getTeamGoalsFor(t.id, group),
        'ga': getTeamGoalsAgainst(t.id, group),
        'gd': getTeamGoalsFor(t.id, group) - getTeamGoalsAgainst(t.id, group),
      });
    }
    standings.sort((a, b) {
      final c = (b['pts'] as int).compareTo(a['pts'] as int);
      if (c != 0) return c;
      return (b['gd'] as int).compareTo(a['gd'] as int);
    });
    return standings;
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    _teams = await _service.getTeams();
    _matches = await _service.getMatches();
    _referees = await _service.getReferees();
    _tournament = await _service.getTournament();
    _events = await _service.getEvents();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> seedIfEmpty() async {
    final teams = await _service.getTeams();
    if (teams.isNotEmpty) return;
    final mock = MockDataService();
    for (final t in await mock.getTeams()) await _service.addTeam(t);
    for (final t in await mock.getTeams()) {
      for (final p in await mock.getPlayers(t.id)) await _service.addPlayer(p);
    }
    for (final m in await mock.getMatches()) await _service.addMatch(m);
    for (final r in await mock.getReferees()) await _service.addReferee(r);
    final tour = await mock.getTournament();
    if (tour != null) await _service.saveTournament(tour);
    for (final e in await mock.getEvents()) await _service.addEvent(e);
    await loadData();
  }

  Future<void> addTeam(Team team) async {
    await _service.addTeam(team);
    await loadData();
  }

  Future<void> updateTeam(Team team) async {
    await _service.updateTeam(team);
    await loadData();
  }

  Future<void> deleteTeam(String id) async {
    await _service.deleteTeam(id);
    await loadData();
  }

  Future<void> addPlayer(Player player) async {
    await _service.addPlayer(player);
  }

  Future<void> updatePlayer(Player player) async {
    await _service.updatePlayer(player);
  }

  Future<void> deletePlayer(String id) async {
    await _service.deletePlayer(id);
  }

  Future<void> updateMatch(Match match) async {
    await _service.updateMatch(match);
    await loadData();
  }

  Future<void> addMatch(Match match) async {
    await _service.addMatch(match);
    await loadData();
  }

  Future<void> deleteMatch(String id) async {
    await _service.deleteMatch(id);
    await loadData();
  }

  Future<bool> hasUserBet(String matchId) async {
    if (_userId == null) return false;
    return _service.hasUserBet(_userId!, matchId);
  }

  Future<void> placeBet(Bet bet) async {
    await _service.placeBet(bet);
  }

  Future<void> login(String userId, String email) async {
    _userId = userId;
    _userEmail = email;
    _isAdmin = await _service.isAdmin(userId);
    notifyListeners();
  }

  Future<void> logout() async {
    _userId = null;
    _userEmail = null;
    _isAdmin = false;
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}
    notifyListeners();
  }

  Future<void> saveTournament(Tournament t) async {
    await _service.saveTournament(t);
    _tournament = t;
    notifyListeners();
  }

  Future<void> addReferee(Referee referee) async {
    await _service.addReferee(referee);
    await loadData();
  }

  Future<void> deleteReferee(String id) async {
    await _service.deleteReferee(id);
    await loadData();
  }

  Future<void> addEvent(Event event) async {
    await _service.addEvent(event);
    await loadData();
  }

  Future<void> deleteEvent(String id) async {
    await _service.deleteEvent(id);
    await loadData();
  }

  List<Event> getEventsByDay(int day) {
    final d = DateTime(2026, 12, 24 + day);
    return _events.where((e) =>
        e.date.year == d.year &&
        e.date.month == d.month &&
        e.date.day == d.day).toList();
  }
}
