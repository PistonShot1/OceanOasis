import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/components/shoptools/tools.dart';

class PlayerProperty extends ChangeNotifier {
  late User userIdentity;
  List<Tools> tools;
  List<Tools> weapons;

  Map<WasteType, double> wasteScores = {};
  double currentScore = 0;

  Map<WasteType, double> levelwasteScores = {};

  double levelcurrentScore = 0;

  int gameBalance = 0;

  PlayerProperty({required this.tools, required this.weapons}) {
    Map<WasteType, double> wasteType = {};
    for (WasteType element in WasteType.values) {
      wasteType[element] = 0;
    }

    levelwasteScores = Map.from(wasteType);
    wasteScores = Map.from(wasteType);
  }

  void addScore() {
    currentScore++;
    notifyListeners();
  }

  void addlevelScore() {
    levelcurrentScore++;
    notifyListeners();
  }

  void addlevelWasteScore(WasteType wasteType) {
    levelwasteScores[wasteType] = levelwasteScores[wasteType]! + 1;
    notifyListeners();
  }

  void addplayerWasteScore(WasteType wasteType) {
    wasteScores[wasteType] = wasteScores[wasteType]! + 1;
    notifyListeners();
  }

  void resetwasteScore() {
    levelwasteScores.forEach(
      (key, value) {
        levelwasteScores[key] = 0;
      },
    );
    notifyListeners();
  }

  void resetcurrentScore() {
    levelcurrentScore = 0;
    notifyListeners();
  }

  void addgameBalance(int value, WasteType wasteType) {
    wasteScores[wasteType] = 0;
    gameBalance += value;
    notifyListeners();
  }
}
