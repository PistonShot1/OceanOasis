import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/routes/gameplay.dart';

class freezeEffect extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks{


  final Vector2 initialSize = Vector2(0,0);
  final double positionOffsetX = 0;
  final double positionOffsetY = 0;
  
  final double hitboxOffsetX = 0;
  final double hitboxOffsetY = 0;

  bool effectPlaying = false;



  final scaleEffect = SizeEffect.by(
    Vector2(2000, 2000),
    EffectController(duration: 1),
  );
  final moveEffect = MoveEffect.by(
    Vector2(-1000, -1000),
    EffectController(duration: 1),
  );

  
  freezeEffect(sourcePosition) {
 
    super.position = sourcePosition + Vector2(positionOffsetX, positionOffsetY);
    super.size = initialSize;

  }
  
  @override
  FutureOr<void> onLoad() async{

    add(scaleEffect);
    add(moveEffect);

    

    Image image = await Flame.images.load('bossfight/freezeEffect.png');
    priority = 3;
    animation = SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
            amount: 10, stepTime: 0.1, textureSize: Vector2(128, 128)));
        CircleHitbox c = CircleHitbox();
      add(c);
      debugMode = true;
    return super.onLoad();
  }

  void removeComponent() {
      Future.delayed(const Duration(seconds: 1), () {
        super.removeFromParent();
      });
  }



  

  @override
  void update(double dt){
 

    removeComponent();
    super.update(dt);
  }
}
