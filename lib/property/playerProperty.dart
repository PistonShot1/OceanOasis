import 'package:flutter/foundation.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/tools/tools.dart';

class PlayerProperty extends ChangeNotifier {
  List<Tools> tools;
  List<Tools> weapons;
  ValueNotifier<double> currentScore = ValueNotifier(0);
  late ValueNotifier<Map<WasteType, double>> wasteScores;

  PlayerProperty({required this.tools, required this.weapons}) {
    Map<WasteType, double> wasteType = {};
    for (WasteType element in WasteType.values) {
      wasteType[element] = 0;
    }
    wasteScores = ValueNotifier(wasteType);
  }

  void addScore(double value) {
    currentScore.value += value;
    notifyListeners();
  }

  void addWasteScore(WasteType wasteType) {
    wasteScores.value[wasteType] = wasteScores.value[wasteType]! + 1;

    //DEBUG
    wasteScores.value.forEach((key, value) {
      print('$key:$value');
    });

    notifyListeners();
  }

  void resetScore() {
    wasteScores.value.forEach(
      (key, value) {
        wasteScores.value[key] = 0;
      },
    );
    notifyListeners();
  }
}
