//Andy Guest - dec 3 2024
//backend for the prev page
//temporarily hardcoded due to needed items not being completed 

class PrevTripEntry {
  final String date;
  final int score;
  final double distance;
  final String map;

  PrevTripEntry({
    required this.date,
    required this.score,
    required this.distance,
    this.map = 'assets/img/squaremap.png'
  });
}

//because neither the trip score or database is done yet this is hardcoded
List<PrevTripEntry> getPrevTripData() {
  return [
    PrevTripEntry(date: 'Dec 04, 2024', score: 100, distance: 0.1),
    PrevTripEntry(date: 'Dec 04, 2024', score: 100, distance: 0.3, map: 'assets/img/squaremap2.png'),
    PrevTripEntry(date: 'Dec 04, 2024', score: 95, distance: 0.1),
    PrevTripEntry(date: 'Dec 03, 2024', score: 80, distance: 0.5),
  ];
}