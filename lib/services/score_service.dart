import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreEntry {
  final double score;
  final DateTime date;
  final String playerName;

  ScoreEntry({
    required this.score,
    required this.date,
    required this.playerName,
  });

  Map<String, dynamic> toJson() => {
    'score': score,
    'date': date.toIso8601String(),
    'playerName': playerName,
  };

  factory ScoreEntry.fromJson(Map<String, dynamic> json) => ScoreEntry(
    score: (json['score'] as num).toDouble(),
    date: DateTime.parse(json['date']),
    playerName: json['playerName'],
  );
}

class ScoreService {
  static const String _key = 'circle_scores';

  Future<void> saveScore(double score, {String playerName = 'Гравець'}) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> rawList = prefs.getStringList(_key) ?? [];

    final newEntry = ScoreEntry(
      score: score,
      date: DateTime.now(),
      playerName: playerName.isEmpty ? 'Гравець' : playerName,
    );

    rawList.add(jsonEncode(newEntry.toJson()));
    await prefs.setStringList(_key, rawList);
  }

  Future<List<ScoreEntry>> getTopScores() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> rawList = prefs.getStringList(_key) ?? [];

    final List<ScoreEntry> scores = rawList
        .map((e) => ScoreEntry.fromJson(jsonDecode(e)))
        .toList();

    // Сортуємо від більшого до меншого
    scores.sort((a, b) => b.score.compareTo(a.score));

    return scores.take(15).toList(); // Повертаємо топ 15
  }

  Future<ScoreEntry?> getDailyBest() async {
    final scores = await getTopScores();
    final now = DateTime.now();

    final todayScores = scores.where((e) {
      return e.date.year == now.year &&
          e.date.month == now.month &&
          e.date.day == now.day;
    }).toList();

    if (todayScores.isEmpty) return null;
    return todayScores.first; // Вже відсортовано
  }

  Future<void> clearAllScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<ScoreEntry?> getAllTimeBest() async {
    final scores = await getTopScores();
    if (scores.isEmpty) return null;
    return scores.first;
  }
}
