import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:oceanoasis/components/players/joystickplayer.dart';

class AttackInput extends RectangleComponent with TapCallbacks {
  JoystickPlayer playerRef;
  AttackInput({required this.playerRef}) : super(size: Vector2.all(100));

  @override
  void onTapDown(TapDownEvent event) {
    // TODO: implement onTapDown
    if (isMounted) {
      playerRef.hitAction(null);
    }
    super.onTapDown(event);
  }
}
