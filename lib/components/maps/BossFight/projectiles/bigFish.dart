import 'dart:async';

import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/components/maps/BossFight/bossfightplayer.dart';

import 'package:oceanoasis/components/maps/BossFight/projectiles/freezeEffect.dart';

import 'package:oceanoasis/my_game.dart';
import 'package:oceanoasis/components/maps/BossFight/projectiles/mine.dart';

class bigFish extends SpriteAnimationComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  final int destroyTime = 5;
  double projectileSpeed = 666;
  late double projectileDirection;
  final Vector2 initialSize = Vector2(300, 300);
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
  FutureOr<void> onLoad() async {
    Image image = await Flame.images.load('bossfight/fish-big.png');
    priority = 3;
    animation = SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.1, textureSize: Vector2(54, 54)));
    CircleHitbox c = CircleHitbox.relative(0.6,
        parentSize: initialSize,
        position: Vector2(hitboxOffsetX, hitboxOffsetY));

    add(c);

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
    if (other is BossFightPlayer) {
      other.takeDamage(damageToPlayer);
    }
    if (other is freezeEffect && frozen == false) {
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
    if (mineCooldown == false && frozen == false) {
      mineCooldown = true;
      bool check = true;
      Future.delayed(const Duration(seconds: 1), () {
        mine m = mine(super.position, currentWorld,
            Vector2(mineSpawnOffsetX, mineSpawnOffsetY));

        currentWorld.children.whereType<mine>().forEach((mine element) {
          if (m.position.x >= (element.position.x - 100) &&
              m.position.x <= (element.position.x + element.size.x + 100) &&
              m.position.y >= element.position.y - 50 &&
              m.position.y <= (element.position.y + 50)) {
            check = false;
          }
        });
        if (check) {
          currentWorld.add(m);
          print('M new : ${m.position}');
        }

        mineCooldown = false;
      });
    }
  }

  bool frozen = false;

  void freezeEvent() {
    frozen = true;
    projectileSpeed = 0;
    Future.delayed(const Duration(seconds: 7), () {
      projectileSpeed = 666;
      frozen = false;
    });
  }

  @override
  void update(double dt) {
    position.x += (1 * projectileSpeed * dt);

    spawnMine();

    removeComponent();
    super.update(dt);
  }
}
