import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/routes/homescreen.dart';

class mutantFishDeath extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks{

  late final World currentWorld;


  mutantFishDeath(Vector2 sourcePosition , World w, Vector2 size, Vector2 offset) {

    currentWorld = w;
    super.position = sourcePosition;
    super.position.x = super.position.x + offset.x;
    super.position.y = super.position.y + offset.y;
    super.size = size;
  }
  
  @override
  FutureOr<void> onLoad() async{
    Image image = await Flame.images.load('bossfight/mutantFishDeath.png');
    priority = 3;
    animation = SpriteAnimation.fromFrameData(image, SpriteAnimationData.sequenced(
      amount: 6,
      stepTime: 0.2,
      textureSize: Vector2.all(54),
      ));
      
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
