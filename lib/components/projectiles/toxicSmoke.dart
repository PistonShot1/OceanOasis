import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/routes/homescreen.dart';

class toxicSmoke extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks{
  final destroyTime = 10;
  final projectileSpeed = 200;
  late double projectileDirection;
  final Vector2 initialSize = Vector2(256,256);
  final scaleEffect = SizeEffect.by(
    Vector2(200, 200),
    EffectController(duration: 1, reverseDuration: 1),
  );
  final moveEffect = MoveEffect.by(
    Vector2(-100, -100),
    EffectController(duration: 1, reverseDuration: 1),
  );
  
  toxicSmoke(double x, double y) {
    super.position = Vector2(x, y );
    super.size = initialSize;
    super.add(scaleEffect);
    super.add(moveEffect);
  }
  @override
  FutureOr<void> onLoad() async{
    Image image = await Flame.images.load('kot.png');
    priority = 2;
    animation = SpriteAnimation.fromFrameData(image, SpriteAnimationData.sequenced(
      amount: 1,
      stepTime: 1,
      textureSize: Vector2.all(512),
      ));
      add(RectangleHitbox());
      debugMode = true;
    return super.onLoad();
  }
  @override
  void update(double dt){
    super.update(dt);
  }
}