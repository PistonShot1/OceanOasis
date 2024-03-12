import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:oceanoasis/maps/underwater/joystickplayer.dart';
import 'package:oceanoasis/tools/slash_effect.dart';

class MagnetEffect extends SlashEffect {
  bool specialEffect1 = false;
  MagnetEffect(super.spriteSheetImage, super.slashType,
      {required super.frameAmount,
      required super.stepTime,
      required super.frameSize,
      required super.toolType,
      super.effects});
  MagnetEffect.clone({required super.slashEffect, required super.playerRef})
      : super.clone();
  @override
  void onMount() {
    // TODO: implement onMount
    size = Vector2(64, 32);
    scale = Vector2.all(2);
    hitEffect();
    super.onMount();
  }

  @override
  void hitEffect() {
    // TODO: implement hitEffect
    if (playerRef != null) {
      final effect = MoveEffect.by(
          Vector2(1920 * playerRef!.facingDirectionnum, 0),
          EffectController(duration: 5),
          onComplete: () {});
      add(effect);
    }

    super.hitEffect();
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is ScreenHitbox) {
      removeFromParent();
    }
  }
}
