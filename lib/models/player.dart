class Player {
  String name;
  int score;

  Player({required this.name, this.score = 0});

  void addScore(int points) {
    score += points;
  }

  void resetScore() {
    score = 0;
  }
}
