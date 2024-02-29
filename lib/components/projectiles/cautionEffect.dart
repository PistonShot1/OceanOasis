import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/components/Boss/crabBoss.dart';
import 'package:oceanoasis/components/Boss/overworldplayer.dart';
import 'package:oceanoasis/routes/homescreen.dart';

class cautiousEffect extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks{
  final int destroyTime = 5;

  final Vector2 initialSize = Vector2(100,100);
  final double hitboxOffsetX = 0;
  final double hitboxOffsetY = 70;
  
  bool effectPlaying = false;

  final MoveByEffect effect = MoveByEffect(
    Vector2(0, -5),
    EffectController(duration: 0.05, repeatCount: 100, reverseDuration: 0.05),
  );
  final MoveByEffect effect2 = MoveByEffect(
    Vector2(-5, 0),
    EffectController(duration: 0.05, repeatCount: 100, reverseDuration: 0.05),
  );

  
  cautiousEffect(sourcePosition) {
 
    super.position = sourcePosition + Vector2(hitboxOffsetX, hitboxOffsetY);
    super.size = initialSize;

  }
  
  @override
  FutureOr<void> onLoad() async{

    add(effect2);
    add(effect);

    

    Image image = await Flame.images.load('bossfight/cautiousEffect.png');
    priority = 3;
    animation = SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 1, textureSize: Vector2(54, 54)));
       
      debugMode = true;
    return super.onLoad();
  }

  void removeComponent() {
      Future.delayed(const Duration(seconds: 2), () {
        super.removeFromParent();
      });
  }



  

  @override
  void update(double dt){
 

    removeComponent();
    super.update(dt);
  }
}
