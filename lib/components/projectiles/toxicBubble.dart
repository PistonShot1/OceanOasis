import 'dart:async';
import 'dart:developer';
import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/components/Boss/crabBoss.dart';
import 'package:oceanoasis/components/Boss/freezeEffect.dart';
import 'package:oceanoasis/components/Boss/bossfightplayer.dart';
import 'package:oceanoasis/components/projectiles/mutantFish.dart';
import 'package:oceanoasis/components/projectiles/mutantFishDeath.dart';
import 'package:oceanoasis/routes/gameplay.dart';

class toxicBubble extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks{

   double projectileSpeed = 666;
  late double projectileDirection;
  final Vector2 initialSize = Vector2(128,128);
  late Vector2 thisfacingDirection;
  late double xdirectionRatio;
  late double ydirectionRatio;
  final double hitboxOffsetX = 30;
  final double hitboxOffsetY = 30;
  late final World currentWorld;
  final double damageToOverworldPlayer = 10;

  toxicBubble(Vector2 sourcePosition, Vector2 destinationPos, World w) {
    currentWorld = w;
    thisfacingDirection  = destinationPos - sourcePosition;
    xdirectionRatio = thisfacingDirection.y / thisfacingDirection.x;
    if (xdirectionRatio < 0 ){
      xdirectionRatio = -xdirectionRatio;
    }
    super.flipHorizontally();
    super.position = sourcePosition;
    super.size = initialSize;
  }
  
  @override
  FutureOr<void> onLoad() async{
    Image image = await Flame.images.load('bossfight/homingFish.png');
    priority = 3;
    animation = SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.1, textureSize: Vector2(32,32)));
            CircleHitbox c = CircleHitbox.relative(0.6, parentSize: initialSize, position: Vector2(hitboxOffsetX, hitboxOffsetY));

      add(c);
      debugMode = true;
    return super.onLoad();
  }

  void removeComponent() {
      Future.delayed(const Duration(seconds: 15), () {
        super.removeFromParent();
      });
  }

  final Vector2 overWorldPlayerOffset = Vector2(-60,-60);

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is BossFightPlayer){
      other.takeDamage(damageToOverworldPlayer);
      currentWorld.add(mutantFishDeath(other.position, super.size, overWorldPlayerOffset));
      super.removeFromParent();
    }
    if (other is freezeEffect && frozen == false){
      freezeEvent();
    }

  }
  bool frozen = false;
  static const int freezeDuration = 7;

  void freezeEvent(){
    frozen = true;
    projectileSpeed = 0;
    Future.delayed(const Duration(seconds: freezeDuration), () {
        projectileSpeed = 666;
        frozen = false;
      });
  }



  @override
  void update(double dt){
    if (xdirectionRatio > 1) {
      if (thisfacingDirection.x > 0 && thisfacingDirection.y < 0) {
      super.position.y += (-1 * projectileSpeed * dt);
      super.position.x += (1/xdirectionRatio * projectileSpeed * dt);
    } else if (thisfacingDirection.x > 0 && thisfacingDirection.y > 0) {
      super.position.y += (1 * projectileSpeed * dt);
      super.position.x += ((1/xdirectionRatio) * projectileSpeed * dt);
    } else if (thisfacingDirection.x < 0 && thisfacingDirection.y < 0){
      super.position.y += (-1 * projectileSpeed * dt);
      super.position.x += (-(1/xdirectionRatio) * projectileSpeed * dt);
    } else if (thisfacingDirection.x < 0 && thisfacingDirection.y > 0){
      super.position.y += (1 * projectileSpeed * dt);
      super.position.x += (-(1/xdirectionRatio) * projectileSpeed * dt);
    }
    } else if (xdirectionRatio < 1){
      if (thisfacingDirection.x > 0 && thisfacingDirection.y < 0) {
      super.position.y += (-xdirectionRatio * projectileSpeed * dt);
      super.position.x += (1 * projectileSpeed * dt);
    } else if (thisfacingDirection.x > 0 && thisfacingDirection.y > 0) {
      super.position.y += (xdirectionRatio * projectileSpeed * dt);
      super.position.x += (1 * projectileSpeed * dt);
    } 
    else if (thisfacingDirection.x < 0 && thisfacingDirection.y < 0) {
      super.position.y += (-xdirectionRatio * projectileSpeed * dt);
      super.position.x += (-1 * projectileSpeed * dt);
    } 
    else if (thisfacingDirection.x < 0 && thisfacingDirection.y > 0) {
      super.position.y += (xdirectionRatio * projectileSpeed * dt);
      super.position.x += (-1 * projectileSpeed * dt);
    } 

  
    }


    removeComponent();
    super.update(dt);
  }
}
