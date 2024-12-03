//Andy Guest - Nov 25 2024
//frontend for the leaderboard page, shows the drivers top 5 trips of the month

import 'package:flutter/material.dart';
import 'leaderboard_backend.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  LeaderboardPageState createState() => LeaderboardPageState();
}

class LeaderboardPageState extends State<LeaderboardPage> {
  List<LeaderboardEntry> leaderboardEntries = [];

  @override
  void initState() {
    super.initState();
    _fetchLeaderboardData();
  }

  void _fetchLeaderboardData() {
    //get leaderboard data from backend
    leaderboardEntries = getTripScoreData();
    leaderboardEntries = sortLeaderboard(leaderboardEntries);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 244, 234, 1), //match to the main screen bg colour
      appBar: AppBar(
        title: const Text('Leaderboard', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(86, 170, 200, 1),
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Your best trips this month!',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            
            //leaderboard entreies
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(225, 225, 225, 1),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true, //needed to stop the list from taking up extra space
                itemCount: leaderboardEntries.length,
                itemBuilder: (context, index) {
                  final entry = leaderboardEntries[index];
                  return LeaderboardItem(
                    date: entry.date,
                    score: entry.score,
                    rank: index + 1, //rank num auto increases
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaderboardItem extends StatelessWidget {
  final String date;
  final int score;
  final int rank;

  const LeaderboardItem({super.key, 
    required this.date,
    required this.score,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 7.0),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            //rank Icon
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(86, 170, 200, 1),
              ),
              child: _getRankIcon(rank),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Rank
                  Text(
                    '#$rank',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  //date
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  //score
                  Text(
                    '$score%',
                    style:TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                       color: _getScoreColour(score),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //icons, empty star for 1st place, half stars for 4 and 5th place. can be replaced with other icons
  Widget _getRankIcon(int rank) {
    if (rank == 1) {
      return const Icon(Icons.star_rounded, color: Colors.white, size: 30.0);
    } else if (rank == 2) {
      return const Icon(Icons.star_border_outlined, color: Colors.white, size: 30.0);
    } else if (rank == 3) {
      return const Icon(Icons.star_border_outlined, color: Colors.white, size: 30.0);
    } else {
      return const Icon(Icons.star_half, color: Colors.white, size: 30.0);
    }
  }

}

Color _getScoreColour(int score) {
  if (score >= 80) {
    return const Color.fromRGBO(170, 200, 86, 1);
  }
  else if (score >=60){
    return const Color.fromRGBO(211, 158, 0, 1);
  }
  else{
    return const Color.fromRGBO(168, 46, 12, 1);
  }
}