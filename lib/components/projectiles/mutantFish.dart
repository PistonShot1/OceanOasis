import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/components/projectiles/mutantFishDeath.dart';
import 'package:oceanoasis/routes/homescreen.dart';

class mutantFish extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks{
  double projectileSpeed = 300;
  late double projectileDirection;
  final Vector2 initialSize = Vector2.all(100);
  late final World currentWorld;
  int randomNumber = 0;
  final double hitboxOffsetX = 30;
  final double hitboxOffsetY = 0;

  mutantFish(double sourcePosition, World w) {
    currentWorld = w;
    super.angle = pi/2;


      

    super.position = Vector2(sourcePosition, 0);
    super.size = initialSize;
  }
  
  @override
  FutureOr<void> onLoad() async{
    Image image = await Flame.images.load('bossfight/mutantFish.png');
    priority = 2;
    animation = SpriteAnimation.fromFrameData(image, SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2.all(39),
      ));
      CircleHitbox c = CircleHitbox.relative(0.5, parentSize: initialSize, position: Vector2(hitboxOffsetX, hitboxOffsetY));

      add(c);
      debugMode = true;
    return super.onLoad();
  }

  void removeComponent() {
    if (position.y > 1000 ){
 
      mutantFishDeath m =  mutantFishDeath(super.position, currentWorld, super.size, Vector2(-100,0));
      currentWorld.add(m);

        super.removeFromParent();

    }
  }

  @override
  void update(double dt){
    position.y += (1* projectileSpeed * dt);
    removeComponent();
    super.update(dt);
  }
  
   int getRandomInt(int min, int max) {
    Random random = Random();
    return min + random.nextInt(max - min + 1);
  }
}
