import '../models/team.dart';
import '../models/player.dart';
import '../models/match.dart';
import '../models/referee.dart';
import '../models/bet.dart';
import '../models/tournament.dart';
import '../models/event.dart';

abstract class DataService {
  Future<List<Team>> getTeams();
  Future<void> addTeam(Team team);
  Future<void> updateTeam(Team team);
  Future<void> deleteTeam(String teamId);

  Future<List<Player>> getPlayers(String teamId);
  Future<void> addPlayer(Player player);
  Future<void> updatePlayer(Player player);
  Future<void> deletePlayer(String playerId);

  Future<List<Match>> getMatches();
  Future<List<Match>> getMatchesByDay(int day);
  Future<void> addMatch(Match match);
  Future<void> updateMatch(Match match);
  Future<void> deleteMatch(String matchId);

  Future<List<Referee>> getReferees();
  Future<void> addReferee(Referee referee);
  Future<void> deleteReferee(String refereeId);

  Future<List<Bet>> getBets(String matchId);
  Future<void> placeBet(Bet bet);
  Future<bool> hasUserBet(String userId, String matchId);

  Future<Tournament?> getTournament();
  Future<void> saveTournament(Tournament tournament);

  Future<List<Event>> getEvents();
  Future<void> addEvent(Event event);
  Future<void> deleteEvent(String eventId);

  Future<bool> isAdmin(String userId);
}
