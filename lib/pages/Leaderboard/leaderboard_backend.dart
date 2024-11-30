//Andy Guest - Nov 25 2024
//backend for the leaderboard page
//temporarily hardcoded due to needed items not being completed 

class LeaderboardEntry {
  final String date;
  final int score;

  LeaderboardEntry({
    required this.date,
    required this.score,
  });
}

//because neither the trip score or database is done yet this is hardcoded
List<LeaderboardEntry> getTripScoreData() {
  return [
    LeaderboardEntry(date: 'Linda - Nov 11', score: 100),
    LeaderboardEntry(date: 'Linda - Nov 1', score: 55),
    LeaderboardEntry(date: 'Linda - Nov 12', score: 73),
    LeaderboardEntry(date: 'Linda - Nov 22', score: 99),
    LeaderboardEntry(date: 'Linda - Nov 13', score: 65),
  ];
}

List<LeaderboardEntry> sortLeaderboard(List<LeaderboardEntry> entries) {
  //sort the scores by highest to lowest 
  entries.sort((a, b) => b.score.compareTo(a.score));
  return entries;
}