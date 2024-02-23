import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/routes/gameplay.dart';

class mutantFish extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks{
  final destroyTime = 10;
  final projectileSpeed = 444;
  late double projectileDirection;
  final Vector2 initialSize = Vector2.all(100);

  mutantFish(sourcePosition) {
    super.position = Vector2(sourcePosition, 0);
    super.size = initialSize;
  }
  
  @override
  FutureOr<void> onLoad() async{
    Image image = await Flame.images.load('kot.png');
    priority = 2;
    animation = SpriteAnimation.fromFrameData(image, SpriteAnimationData.sequenced(
      amount: 1,
      stepTime: 1,
      textureSize: Vector2.all(128),
      ));
      add(RectangleHitbox());
      debugMode = true;
    return super.onLoad();
  }

  void removeComponent() {
    if (position.y > 1000){
      super.removeFromParent();
    }
  }

  @override
  void update(double dt){
    position.y += (1* projectileSpeed * dt);
    removeComponent();
    super.update(dt);
  }
}
