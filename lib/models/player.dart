class Player {
  String name;
  int score;
  String? uid; // Online için

  Player({required this.name, this.score = 0, this.uid});

  void addScore(int points) {
    score += points;
  }

  void resetScore() {
    score = 0;
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'score': score, 'uid': uid};
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      name: map['name'] ?? 'Oyuncu',
      score: map['score'] ?? 0,
      uid: map['uid'],
    );
  }
}
