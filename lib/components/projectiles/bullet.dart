import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/components/Boss/crabBoss.dart';
import 'package:oceanoasis/components/projectiles/bossDamagedEffect.dart';
import 'package:oceanoasis/components/projectiles/mine.dart';
import 'package:oceanoasis/routes/homescreen.dart';

class bullet extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks{
  final destroyTime = 5;
  final projectileSpeed = 666;
  late double projectileDirection;
  final Vector2 initialSize = Vector2(128,128);
  late int thisfacingDirection = 0;
  final double bulletDamage = 0.2;
  final double fireRate = 0.5;
  bool inCollide = false;

  final double hitboxOffsetX = 30;
  final double hitboxOffsetY = 30;


  bullet(Vector2 sourcePosition, int facingDirection, Vector2 positionOffset) {

    thisfacingDirection = facingDirection;
    super.position = sourcePosition + positionOffset;
    super.size = initialSize;
    //super.angle = pi/2;
  }
  
  @override
  FutureOr<void> onLoad() async{
    Image image = await Flame.images.load('weapons/gun-effect.png');
    priority = 3;
    animation = SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 0.1, textureSize: Vector2(30,30)));
       CircleHitbox c = CircleHitbox.relative(0.2, parentSize: initialSize, position: Vector2(hitboxOffsetX, hitboxOffsetY));

      add(c);
      debugMode = true;
    return super.onLoad();
  }

  void removeComponent() {
      Future.delayed(const Duration(seconds: 5), () {
        super.removeFromParent();
      });
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

      if (other is crabBoss){
        other.takeDamage(bulletDamage);
        //bossDamagedEffect b = bossDamagedEffect(super.position, super.size);
        //currentWorld.add(b);
        super.removeFromParent();
      }
      if (other is mine){
        super.removeFromParent();
      }
    

  }

  @override
  void onCollisionEnd(PositionComponent other) {

    super.onCollisionEnd(other);
  }

  @override
  void update(double dt){
    
    position.x += (thisfacingDirection* projectileSpeed * dt);
    removeComponent();
    super.update(dt);
  }
}
