import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:oceanoasis/components/Boss/bossfight.dart';
import 'package:oceanoasis/components/Boss/bossfightplayer.dart';
import 'package:oceanoasis/maps/underwater/joystickplayer.dart';

class BossAttackInput extends SpriteButtonComponent {
  PacificOceanBossFight sceneRef;
  BossAttackInput({
    required this.sceneRef,
  }) : super(
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
    if (sceneRef.player.currentTool.id == 'pistol' &&
        sceneRef.canShoot == true) {
      sceneRef.canShoot = false;
      sceneRef.playerShoot();
      Future.delayed(const Duration(milliseconds: 200), () {
        sceneRef.canShoot = true;
      });
    } else if (sceneRef.player.currentTool.id == 'freezeDevice' &&
        sceneRef.canShoot == true) {
      sceneRef.canShoot = false;
      sceneRef.playerFreeze();
      Future.delayed(const Duration(seconds: 1), () {
        sceneRef.canShoot = true;
      });
    }
    super.onTapDown(_);
  }
}
