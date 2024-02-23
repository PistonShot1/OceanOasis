import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:oceanoasis/components/projectiles/mutantFish.dart';
import 'package:oceanoasis/components/projectiles/toxicSmoke.dart';
import 'package:oceanoasis/routes/homescreen.dart';

class crabBoss extends SpriteAnimationComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  final initialPosition = Vector2(1000, 700);
  final initialSize = Vector2(256, 256);
  final double speed = 700;
  late double moveDirection = 1;
  final leftBoundaries = 0;
  final rightBoundaries = 1700;
  final freezeDuration = 3;
  final cooldown = 7;
  final double leftDirection = -1;
  final double rightDirection = 1;
  int randomNumber = 0;
  bool freezing = false;
  World bossWorld = World();
  bool attackOnCooldown = false;
  bool switchingDirection = false;

  double currentHealth = 100;
  double maxHealth = 100;
  bool takeDamageEverySecond = true; // this just for testing

  MoveByEffect effect = MoveByEffect(
    Vector2(0, -10),
    EffectController(duration: 0.05, repeatCount: 20, reverseDuration: 0.05),
  );

  crabBoss(World w) {
    super.position = initialPosition;
    super.size = initialSize;
    bossWorld = w;
  }
  
  //Use this for health bar only
  @override
  void render(Canvas canvas) {
    // TODO: implement render
    double barWidth = (currentHealth / maxHealth) * size.x;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, barWidth, 20), Paint()..color = Colors.red);
    super.render(canvas);
  }

  @override
  FutureOr<void> onLoad() async {
    effect.removeOnFinish = false;
    add(effect);
    Image image = await Flame.images.load('bossfight/radioactive-boss.png');
    priority = 3;
    animation = SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
            amount: 14, stepTime: 0.2, textureSize: Vector2(512, 512)));
    add(RectangleHitbox());
    debugMode = true;

    add(PositionComponent()
      ..size = Vector2.all(50)
      ..debugMode = true);
    return super.onLoad();
  }

  Future<void> wait() {
    return Future.delayed(Duration(seconds: freezeDuration));
  }

  Future<void> attackCooldown() {
    return Future.delayed(Duration(seconds: cooldown));
  }

  int getRandomInt(int min, int max) {
    Random random = Random();
    return min + random.nextInt(max - min + 1);
  }

  double getRandomNumber(double min, double max) {
    Random random = Random();
    return min + random.nextDouble() * (max - min);
  }

  void horizontalMovement(double dt) {
    position.x += moveDirection * speed * dt;
  }

  Future<bool> vulnerableFrame() async {
    if (freezing == false) {
      freezing = true;
      await wait();
      freezing = false;
      return true;
    }
    return false;
  }

  void switchMovingDirection(double direction) async {
    if (switchingDirection == false) {
      switchingDirection = true;
      moveDirection = 0;
      await wait();
      if (await vulnerableFrame()) {
        moveDirection = direction;
        switchingDirection = false;
      }
    }
  }

  void toxicAttack() async {
    attackOnCooldown = true;
    toxicSmoke smoke = toxicSmoke(position.x, position.y);
    bossWorld.add(smoke);
    await attackCooldown();
    bossWorld.remove(smoke);
    attackOnCooldown = false;
  }

  void spawnMutantFish() async {
    attackOnCooldown = true;
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 2; j++) {
        mutantFish m = mutantFish(getRandomNumber(0, 1800));
        bossWorld.add(m);
      }
    }
    await attackCooldown();
    attackOnCooldown = false;
  }

  @override
  void update(double dt) {
    //Random random = new Random();
    //int randomNumber = random.nextInt(1);
    horizontalMovement(dt);
    if (position.x > rightBoundaries) {
      switchMovingDirection(leftDirection);
    } else if (position.x < leftBoundaries) {
      switchMovingDirection(rightDirection);
    }
    if (moveDirection == 0 && attackOnCooldown == false) {
      effect.reset();
      randomNumber = getRandomInt(0, 1);
      if (randomNumber == 0) {
        spawnMutantFish();
      } else {
        toxicAttack();
      }
    }

    if (takeDamageEverySecond) {
      takeDamage();
    }
    super.update(dt);
  }

  void takeDamage() {
    takeDamageEverySecond = false;
    Future.delayed(const Duration(seconds: 5), () {
      currentHealth = currentHealth - 5;
      takeDamageEverySecond = true;
    });
  }
}
