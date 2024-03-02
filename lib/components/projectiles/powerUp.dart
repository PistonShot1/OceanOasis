import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/components/Boss/overworldplayer.dart';
import 'package:oceanoasis/components/projectiles/bullet.dart';
import 'package:oceanoasis/components/projectiles/mineExplosionEffect.dart';
import 'package:oceanoasis/routes/homescreen.dart';

class powerUp extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks{
  final Vector2 initialSize = Vector2.all(50);
  bool playingEffect = false;
  final double energyRecharge = 25;


  final scaleEffect = SizeEffect.by(
    Vector2(50, 50),
    EffectController(duration: 1, reverseDuration: 1),
  );
  final moveEffect = MoveEffect.by(
    Vector2(0, -25),
    EffectController(duration: 1, reverseDuration: 1),
  );

  powerUp(Vector2 sourcePosition, Vector2 spawnOffset) {

    super.position = sourcePosition + Vector2(spawnOffset.x, spawnOffset.y);
    super.size = initialSize;
  }
  
  @override
  FutureOr<void> onLoad() async{
    //scaleEffect.removeOnFinish = false;
    moveEffect.removeOnFinish = false;
    //add(scaleEffect);
    add(moveEffect);
    Image image = await Flame.images.load('bossfight/powerUp.png');
    priority = 3;
    animation = SpriteAnimation.fromFrameData(image, SpriteAnimationData.sequenced(
      amount: 1,
      stepTime: 1,
      textureSize: Vector2.all(45),
      ));
      add(CircleHitbox());
      debugMode = true;

       removeComponent();

    return super.onLoad();
  }

    
  void removeComponent() {
    Future.delayed(const Duration(seconds: 10), () {
        super.removeFromParent();
      });
  }

 @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollisionStart
    if (other is OverworldPlayer){
      other.chargeEnergy(energyRecharge);
      super.removeFromParent();
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

