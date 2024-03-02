import 'package:flutter/foundation.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/tools/tools.dart';

class PlayerProperty extends ChangeNotifier {
  List<Tools> tools;
  List<Tools> weapons;

  late ValueNotifier<Map<WasteType, double>> wasteScores;

  late ValueNotifier<Map<WasteType, double>> levelwasteScores;
  ValueNotifier<double> currentScore = ValueNotifier(0);

  PlayerProperty({required this.tools, required this.weapons}) {
    Map<WasteType, double> wasteType = {};
    for (WasteType element in WasteType.values) {
      wasteType[element] = 0;
    }
    levelwasteScores = ValueNotifier(wasteType);
    wasteScores = ValueNotifier(wasteType);
  }

  void addScore() {
    currentScore.value++;
    notifyListeners();
  }

  void addWasteScore(WasteType wasteType) {
    levelwasteScores.value[wasteType] = levelwasteScores.value[wasteType]! + 1;
    wasteScores.value[wasteType] = wasteScores.value[wasteType]! + 1;
    //DEBUG
    levelwasteScores.value.forEach((key, value) {
      print('$key:$value');
    });

    notifyListeners();
  }

  void resetScore() {
    levelwasteScores.value.forEach(
      (key, value) {
        levelwasteScores.value[key] = 0;
      },
    );
    notifyListeners();
  }
}
