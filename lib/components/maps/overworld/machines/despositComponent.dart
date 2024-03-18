import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/components/maps/overworld/machines/machines.dart';
import 'package:oceanoasis/property/game_properties.dart';
import 'package:oceanoasis/my_game.dart';

class DepositComponent extends SpriteComponent
    with HasGameReference<MyGame>, TapCallbacks {
  final Machines machine;
  final WasteType machineType;
  DepositComponent({required this.machine, required this.machineType})
      : super.fromImage(Flame.images.fromCache('ui/item-ui.png'),
            srcPosition: Vector2(32, 32),
            srcSize: Vector2(32, 32),
            size: Vector2.all(100));
  @override
  FutureOr<void> onLoad() {
    add(SpriteComponent.fromImage(game.images.fromCache(_mapWasteMachineImage),
        size: Vector2.all(70), position: Vector2(15, 15)));
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    print(game.playerData.wasteScores);
    GameCurrency currencyExchange = GameCurrency();
    if (game.playerData.wasteScores[game.currentMachine]!.toInt() > 0) {
      game.playerData.addgameBalance(
          currencyExchange.calculateCurrencyExchange(
              game.playerData.wasteScores[game.currentMachine]!.toInt(),
              game.currentMachine!),
          game.currentMachine!);
      machine.playAnimation();
    } else {
      print('Insufficient resources');
    }

    super.onTapDown(event);
  }

  String get _mapWasteMachineImage {
    switch (machineType) {
      case WasteType.paper:
        return 'score-icon/paper.png';
      case WasteType.plastic:
        return 'score-icon/plastic.png';
      case WasteType.glass:
        return 'score-icon/glass.png';
      case WasteType.metal:
        return 'score-icon/metal.png';
      case WasteType.radioactive:
        return 'score-icon/nuclear.png';
    }
  }
}
