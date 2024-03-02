import 'dart:async';

import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import 'package:oceanoasis/components/Boss/freezeEffect.dart';
import 'package:oceanoasis/components/Boss/overworldplayer.dart';

import 'package:oceanoasis/components/projectiles/mine.dart';
import 'package:oceanoasis/routes/homescreen.dart';

class bigFish extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks{
  final int destroyTime = 5;
  double projectileSpeed = 666;
  late double projectileDirection;
  final Vector2 initialSize = Vector2(300,300);
  final double hitboxOffsetX = 100;
  final double hitboxOffsetY = 70;
  final double spawnOffsetX = -500;
  final double spawnOffsetY = 0;
  late final World currentWorld;

  final double damageToPlayer = 30;

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
      Future.delayed(const Duration(seconds: 15), () {
        super.removeFromParent();
      });
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is OverworldPlayer){
      other.takeDamage(damageToPlayer);
    }
    if (other is freezeEffect && frozen == false){
      freezeEvent();
    }

  }

  @override
  void onCollisionEnd(PositionComponent other) {


    super.onCollisionEnd(other);
  }

  final double mineSpawnOffsetX = 50;
  final double mineSpawnOffsetY = 50;

  void spawnMine() {
    if (mineCooldown == false && frozen == false ){
      mineCooldown = true;
      Future.delayed(const Duration(seconds: 1), () {
        mine m = mine(super.position, currentWorld, Vector2(mineSpawnOffsetX, mineSpawnOffsetY));
        currentWorld.add(m);
        mineCooldown = false;
      });
    }

  }
  bool frozen = false;

  void freezeEvent(){
    frozen = true;
    projectileSpeed = 0;
    Future.delayed(const Duration(seconds: 7), () {
        projectileSpeed = 666;
        frozen = false;
      });
  }


  @override
  void update(double dt){
    
    position.x += (1* projectileSpeed * dt);

      spawnMine();

    removeComponent();
    super.update(dt);
  }
}
