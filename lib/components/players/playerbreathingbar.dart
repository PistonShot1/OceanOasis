import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/routes/gameplay.dart';

class PlayerBreathingBar extends PositionComponent
    with HasGameReference<MyGame> {
  // One bubble equals to one breathing seconds

  int breathingSeconds; //indicates the count of bubbles (length of bubble bar)
  final Sprite bubblesprite =
      Sprite(Flame.images.fromCache('character-bar/bubble-bar.png'));

  List<SpriteComponent> breathingBar = [];
  PlayerBreathingBar({required this.breathingSeconds});

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    for (int i = 0; i < breathingSeconds; i++) {
      final bubbleSpriteComponent = SpriteComponent(sprite: bubblesprite)
        ..size = Vector2.all(16)
        ..scale = Vector2.all(2);
      breathingBar.add(bubbleSpriteComponent
        ..position = Vector2(
            bubbleSpriteComponent.size.x * bubbleSpriteComponent.scale.x * i +
                0,
            0));
    }
    addAll(breathingBar);
    return super.onLoad();
  }
}
