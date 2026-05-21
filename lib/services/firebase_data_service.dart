import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/team.dart';
import '../models/player.dart';
import '../models/match.dart';
import '../models/referee.dart';
import '../models/bet.dart';
import '../models/tournament.dart';
import '../models/event.dart';
import 'data_service.dart';

class FirebaseDataService implements DataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<Team>> getTeams() async {
    final snap = await _db.collection('teams').get();
    return snap.docs.map((d) => Team.fromJson(d.data())).toList();
  }

  @override
  Future<void> addTeam(Team team) async {
    await _db.collection('teams').doc(team.id).set(team.toJson());
  }

  @override
  Future<void> updateTeam(Team team) async {
    await _db.collection('teams').doc(team.id).update(team.toJson());
  }

  @override
  Future<void> deleteTeam(String teamId) async {
    await _db.collection('teams').doc(teamId).delete();
  }

  @override
  Future<List<Player>> getPlayers(String teamId) async {
    final snap = await _db
        .collection('players')
        .where('teamId', isEqualTo: teamId)
        .get();
    return snap.docs.map((d) => Player.fromJson(d.data())).toList();
  }

  @override
  Future<void> addPlayer(Player player) async {
    await _db.collection('players').doc(player.id).set(player.toJson());
  }

  @override
  Future<void> updatePlayer(Player player) async {
    await _db.collection('players').doc(player.id).update(player.toJson());
  }

  @override
  Future<void> deletePlayer(String playerId) async {
    await _db.collection('players').doc(playerId).delete();
  }

  @override
  Future<List<Match>> getMatches() async {
    final snap = await _db.collection('matches').get();
    return snap.docs.map((d) => Match.fromJson(d.data())).toList();
  }

  @override
  Future<List<Match>> getMatchesByDay(int day) async {
    final snap = await _db
        .collection('matches')
        .where('dayNumber', isEqualTo: day)
        .get();
    return snap.docs.map((d) => Match.fromJson(d.data())).toList();
  }

  @override
  Future<void> addMatch(Match match) async {
    await _db.collection('matches').doc(match.id).set(match.toJson());
  }

  @override
  Future<void> updateMatch(Match match) async {
    await _db.collection('matches').doc(match.id).update(match.toJson());
  }

  @override
  Future<void> deleteMatch(String matchId) async {
    await _db.collection('matches').doc(matchId).delete();
  }

  @override
  Future<List<Referee>> getReferees() async {
    final snap = await _db.collection('referees').get();
    return snap.docs.map((d) => Referee.fromJson(d.data())).toList();
  }

  @override
  Future<void> addReferee(Referee referee) async {
    await _db.collection('referees').doc(referee.id).set(referee.toJson());
  }

  @override
  Future<void> deleteReferee(String refereeId) async {
    await _db.collection('referees').doc(refereeId).delete();
  }

  @override
  Future<List<Bet>> getBets(String matchId) async {
    final snap = await _db
        .collection('bets')
        .where('matchId', isEqualTo: matchId)
        .get();
    return snap.docs.map((d) => Bet.fromJson(d.data())).toList();
  }

  @override
  Future<void> placeBet(Bet bet) async {
    await _db.collection('bets').doc(bet.id).set(bet.toJson());
  }

  @override
  Future<bool> hasUserBet(String userId, String matchId) async {
    final snap = await _db
        .collection('bets')
        .where('userId', isEqualTo: userId)
        .where('matchId', isEqualTo: matchId)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }

  @override
  Future<Tournament?> getTournament() async {
    final snap = await _db.collection('tournament').doc('config').get();
    if (!snap.exists) return null;
    return Tournament.fromJson(snap.data()!);
  }

  @override
  Future<void> saveTournament(Tournament tournament) async {
    await _db.collection('tournament').doc('config').set(tournament.toJson());
  }

  @override
  Future<List<Event>> getEvents() async {
    final snap = await _db.collection('events').get();
    return snap.docs.map((d) => Event.fromJson(d.data())).toList();
  }

  @override
  Future<void> addEvent(Event event) async {
    await _db.collection('events').doc(event.id).set(event.toJson());
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await _db.collection('events').doc(eventId).delete();
  }

  @override
  Future<bool> isAdmin(String userId) async {
    final snap = await _db.collection('admins').doc(userId).get();
    return snap.exists;
  }
}
