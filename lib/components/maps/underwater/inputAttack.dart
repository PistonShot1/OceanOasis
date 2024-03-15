import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:oceanoasis/components/maps/underwater/joystickplayer.dart';

class AttackInput extends SpriteButtonComponent {
  JoystickPlayer playerRef;
  AttackInput({required this.playerRef})
      : super(
          button: Sprite(Flame.images.fromCache('ui/hit-button.png')),
          buttonDown: Sprite(Flame.images.fromCache('ui/hit-button-ontap.png')),
          size: Vector2.all(100),
        );
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    // Paint defaultPaint = Paint()
    //   ..color = Colors.grey.withOpacity(0.5)
    //   ..style = PaintingStyle.fill
    //   ..strokeWidth = 10;
    // paint = defaultPaint;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent _) {
    // TODO: implement onTapDown
    if (isMounted) {
      playerRef.hitAction(null);
    }
    super.onTapDown(_);
  }
}
