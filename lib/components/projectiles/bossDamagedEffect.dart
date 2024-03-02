import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/routes/gameplay.dart';

class bossDamagedEffect extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks{
  final Vector2 initialSize = Vector2.all(100);
  bool playingEffect = false;
   final double Xoffset = 100;
  final double Yoffset = 100;
  

  bossDamagedEffect(Vector2 sourcePosition, Vector2 size ) {
    super.position = sourcePosition + Vector2(Xoffset, Yoffset);
    super.size = initialSize;
  }
  
  @override
  FutureOr<void> onLoad() async{
    
    Image image = await Flame.images.load('bossfight/boss-damaged.png');
    priority = 3;
    animation = SpriteAnimation.fromFrameData(image, SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2.all(23),
      ));
    removeComponent();
    return super.onLoad();
  }

   void removeComponent() {
      Future.delayed(const Duration(milliseconds: 400), () {
        super.removeFromParent();
      });
  }
}

