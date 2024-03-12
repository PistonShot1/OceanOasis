import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/components/Boss/bossfightplayer.dart';
import 'package:oceanoasis/components/projectiles/bullet.dart';
import 'package:oceanoasis/components/projectiles/mineExplosionEffect.dart';
import 'package:oceanoasis/routes/gameplay.dart';

class mine extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks{
  final Vector2 initialSize = Vector2.all(100);
  bool playingEffect = false;
  late final World currentWorld;


  final scaleEffect = SizeEffect.by(
    Vector2(50, 50),
    EffectController(duration: 1, reverseDuration: 1),
  );
  final moveEffect = MoveEffect.by(
    Vector2(0, -25),
    EffectController(duration: 1, reverseDuration: 1),
  );

  mine(Vector2 sourcePosition, World w, Vector2 spawnOffset) {
    currentWorld = w;
    super.position = sourcePosition + Vector2(spawnOffset.x, spawnOffset.y);
    super.size = initialSize;
  }
  
  @override
  FutureOr<void> onLoad() async{
    //scaleEffect.removeOnFinish = false;
    moveEffect.removeOnFinish = false;
    //add(scaleEffect);
    add(moveEffect);
    Image image = await Flame.images.load('bossfight/mine.png');
    priority = 3;
    animation = SpriteAnimation.fromFrameData(image, SpriteAnimationData.sequenced(
      amount: 1,
      stepTime: 1,
      textureSize: Vector2.all(45),
      ));
      add(CircleHitbox());
      
    return super.onLoad();
  }

    
  void removeComponent() {
    mineExplosionEffect m =  mineExplosionEffect(super.position);
    currentWorld.add(m);
    super.removeFromParent();
  }

 @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollisionStart
    if (other is BossFightPlayer){
      removeComponent();
    }
    if (other is bullet){
      removeComponent();
    }
    super.onCollisionStart(intersectionPoints, other);
    
  }


  @override 
  void update(double dt){
    if (playingEffect == false){
      playingEffect = true;
      //scaleEffect.reset();
      moveEffect.reset();
      Future.delayed(const Duration(seconds: 2), () {
        playingEffect = false;
      });
    }
    super.update(dt);
  }
}

