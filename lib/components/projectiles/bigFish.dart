import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/components/Boss/crabBoss.dart';
import 'package:oceanoasis/components/Boss/overworldplayer.dart';
import 'package:oceanoasis/components/projectiles/mine.dart';
import 'package:oceanoasis/routes/homescreen.dart';

class bigFish extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks{
  final destroyTime = 5;
  final projectileSpeed = 666;
  late double projectileDirection;
  final Vector2 initialSize = Vector2(300,300);
  final double hitboxOffsetX = 100;
  final double hitboxOffsetY = 70;
  final double spawnOffsetX = -500;
  final double spawnOffsetY = 0;
  late final World currentWorld;

  bool mineCooldown = false;

  bigFish(sourcePosition, World w) {
    currentWorld = w;
    super.position = sourcePosition + Vector2(spawnOffsetX, spawnOffsetY);
    super.size = initialSize;

  }
  
  @override
  FutureOr<void> onLoad() async{
    Image image = await Flame.images.load('bossfight/fish-big.png');
    priority = 3;
    animation = SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.1, textureSize: Vector2(54, 54)));
       CircleHitbox c = CircleHitbox.relative(0.6, parentSize: initialSize, position: Vector2(hitboxOffsetX, hitboxOffsetY));

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
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is OverworldPlayer){
      other.takeDamage(50);
    }

  }

  @override
  void onCollisionEnd(PositionComponent other) {


    super.onCollisionEnd(other);
  }

  final double mineSpawnOffsetX = 50;
  final double mineSpawnOffsetY = 50;

  void spawnMine() {
    if (mineCooldown == false){
      mineCooldown = true;
      Future.delayed(const Duration(seconds: 1), () {
        mine m = mine(super.position, currentWorld, Vector2(mineSpawnOffsetX, mineSpawnOffsetY));
        currentWorld.add(m);
        mineCooldown = false;
      });
    }

  }


  @override
  void update(double dt){
    
    position.x += (1* projectileSpeed * dt);

      spawnMine();

    removeComponent();
    super.update(dt);
  }
}
