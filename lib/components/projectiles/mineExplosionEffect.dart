import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/components/Boss/crabBoss.dart';
import 'package:oceanoasis/components/Boss/bossfightplayer.dart';
import 'package:oceanoasis/routes/gameplay.dart';

class mineExplosionEffect extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks{
  final Vector2 initialSize = Vector2.all(100);
  bool playingEffect = false;
  final double damageToOverWorldPlayer = 30;
  final double damageToBoss = 5;

  final scaleEffect = SizeEffect.by(
    Vector2(200, 200),
    EffectController(duration: 1, reverseDuration: 1),
  );
  final moveEffect = MoveEffect.by(
    Vector2(-100, -100),
    EffectController(duration: 1, reverseDuration: 1),
  );

  mineExplosionEffect(Vector2 sourcePosition ) {
    super.position = sourcePosition;
    super.size = initialSize;
  }
  
  @override
  FutureOr<void> onLoad() async{
    scaleEffect.removeOnFinish = false;
    moveEffect.removeOnFinish = false;
    add(scaleEffect);
    add(moveEffect);
    Image image = await Flame.images.load('bossfight/mineExplosion.png');
    priority = 3;
    animation = SpriteAnimation.fromFrameData(image, SpriteAnimationData.sequenced(
      amount: 11,
      stepTime: 0.1,
      textureSize: Vector2.all(78),
      ));

       add(CircleHitbox());
      debugMode = true;

    return super.onLoad();
  }

   void removeComponent() {
      Future.delayed(const Duration(seconds: 1), () {
        super.removeFromParent();
      });
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollisionStart
    if (other is BossFightPlayer){
      other.takeDamage(damageToOverWorldPlayer);
    }
    if (other is crabBoss){
      other.takeDamage(damageToBoss);
    }

    super.onCollisionStart(intersectionPoints, other);
    
  }
    
  

  @override 
  void update(double dt){
    removeComponent();
    super.update(dt);
  }
}

