import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Image;

import 'package:oceanoasis/components/Boss/bossfightplayer.dart';
import 'package:oceanoasis/components/Boss/screenFreezeEffect.dart';
import 'package:oceanoasis/components/projectiles/bigFish.dart';
import 'package:oceanoasis/components/projectiles/bossDamagedEffect.dart';
import 'package:oceanoasis/components/projectiles/cautionEffect.dart';

import 'package:oceanoasis/components/projectiles/mutantFish.dart';
import 'package:oceanoasis/components/projectiles/mutantFishDeath.dart';
import 'package:oceanoasis/components/projectiles/toxicSmoke.dart';
import 'package:oceanoasis/components/projectiles/toxicBubble.dart';
import 'package:oceanoasis/routes/gameplay.dart';

class crabBoss extends SpriteAnimationComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  final Vector2 initialPosition = Vector2(1600, 700);
  final Vector2 initialSize = Vector2(256, 256);
   double speed = 300;
  late double moveDirection = 1;
  final double leftBoundaries = 0;
  final double rightBoundaries = 1700;
  final int freezeDuration = 1;
  late double movingDirectionVertical = 1;
  final TiledComponent tiledMap;

  final double topBoundaries = 50;
  final double bottomBoundaries = 700;

  final double leftDirection = -1;
  final double rightDirection = 1;
  late final BossFightPlayer player;
  int randomNumber = 0;
  bool freezing = false;
  World bossWorld = World();
  bool attackOnCooldown = false;
  bool switchingDirection = false;
  bool toxicBubbleCooldown = false;
  bool canDamage = true;


  final double hitboxOffsetX = 60;
  final double hitboxOffsetY = 60;

  double currentHealth = 100;
  double maxHealth = 100;
  bool takeDamageEverySecond = true; // this just for testing

  MoveByEffect effect = MoveByEffect(
    Vector2(0, -10),
    EffectController(duration: 0.05, repeatCount: 20, reverseDuration: 0.05),
  );

  String state = 'Loading';

  crabBoss(World w, BossFightPlayer p, this.tiledMap) {
    player = p;
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
        Rect.fromLTWH(0, 0, barWidth, 10), Paint()..color = Colors.red);
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
    CircleHitbox c = CircleHitbox.relative(0.8,
        parentSize: initialSize,
        position: Vector2(hitboxOffsetX, hitboxOffsetY));

    add(c);
    debugMode = true;

    add(PositionComponent()
      ..size = Vector2.all(50)
      ..debugMode = true);
    return super.onLoad();
  }

  Future<void> wait() {
    return Future.delayed(Duration(seconds: freezeDuration));
  }

  Future<void> attackCooldown(cooldown) {
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

  /* void horizontalMovement(double dt) {
    
    position.x += moveDirection * speed * dt;
  }*/

  void verticalMovement(double dt) {
    position.y += movingDirectionVertical * speed * dt;
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

  void switchMovingDirectionTop(double direction) async {
    switchingDirection = true;
    movingDirectionVertical = 0;
    await wait();
    if (await vulnerableFrame()) {
      movingDirectionVertical = direction;
      while (position.y < topBoundaries) {
        await wait();
      }
      switchingDirection = false;
    }
  }

  void switchMovingDirectionBot(double direction) async {
    if (switchingDirection == false) {
      switchingDirection = true;
      movingDirectionVertical = 0;
      await wait();
      if (await vulnerableFrame()) {
        movingDirectionVertical = direction;
        while (position.y > bottomBoundaries) {
          await wait();
        }
        switchingDirection = false;
      }
    }
  }

  void toxicAttack() async {
    attackOnCooldown = true;
    toxicSmoke smoke = toxicSmoke(position.x, position.y);
    bossWorld.add(smoke);
    await attackCooldown(7);
    bossWorld.remove(smoke);
    attackOnCooldown = false;
  }

  bool canSpawntoxicBubble = true;

  void spawntoxicBubble() async {
    if (canSpawntoxicBubble == true) {
      toxicBubbleCooldown = true;
      bossWorld.add(toxicBubble(super.position, player.getPlayerPosition(), bossWorld));
      await attackCooldown(1);
      toxicBubbleCooldown = false;
    }

  }

  void spawnMutantFish() async {
    attackOnCooldown = true;
    for (int i = 0; i < 5; i++) {
      mutantFish m = mutantFish(getRandomNumber(0, 1800), bossWorld);
      bossWorld.add(m);
    }
    await attackCooldown(3);
    attackOnCooldown = false;
  }

  @override
  void update(double dt) {
    //Random random = new Random();
    //int randomNumber = random.nextInt(1);
    if (state.compareTo('Start') == 0) {
      if (toxicBubbleCooldown == false) {
        spawntoxicBubble();
      }

      verticalMovement(dt);

      if (position.y < topBoundaries) {
        if (switchingDirection == false) {
          switchMovingDirectionTop(1);
        }
      } else if (position.y > bottomBoundaries) {
        if (switchingDirection == false) {
          switchMovingDirectionBot(-1);
        }
      }

      /*if (position.x > rightBoundaries) {
      switchMovingDirection(leftDirection);
    } else if (position.x < leftBoundaries) {
      switchMovingDirection(rightDirection);
    }*/

      if (movingDirectionVertical == 0 && attackOnCooldown == false) {
        effect.reset();
        randomNumber = getRandomInt(0, 1);
        if (randomNumber == 0) {
          spawnMutantFish();
        } else {
          spawnBigFish();
        }
      }

      if (currentHealth < 0) {
        bossDefeated();
      }
    }

    super.update(dt);
  }

  void takeDamage(double damage) {
    bossDamagedEffect b = bossDamagedEffect(super.position, super.size);
    bossWorld.add(b);
    currentHealth = currentHealth - damage;
  }

  void spawnBigFish() async {
    attackOnCooldown = true;
    final bigFishspawnPoint =
        tiledMap.tileMap.getLayer<ObjectGroup>('BigFishSpawn');
    randomNumber = getRandomInt(0, 2);

    if (randomNumber == 0) {
      for (final spawnPoint in bigFishspawnPoint!.objects) {
        if (spawnPoint.name == 'top') {
          bossWorld.add(cautiousEffect(Vector2(spawnPoint.x, spawnPoint.y)));
          Future.delayed(const Duration(seconds: 2), () {
            bossWorld
                .add(bigFish(Vector2(spawnPoint.x, spawnPoint.y), bossWorld));
          });
        }
      }
    } else if (randomNumber == 1) {
      for (final spawnPoint in bigFishspawnPoint!.objects) {
        if (spawnPoint.name == 'mid') {
          bossWorld.add(cautiousEffect(Vector2(spawnPoint.x, spawnPoint.y)));
          Future.delayed(const Duration(seconds: 2), () {
            bossWorld
                .add(bigFish(Vector2(spawnPoint.x, spawnPoint.y), bossWorld));
          });
        }
      }
    } else if (randomNumber == 2) {
      for (final spawnPoint in bigFishspawnPoint!.objects) {
        if (spawnPoint.name == 'bot') {
          bossWorld.add(cautiousEffect(Vector2(spawnPoint.x, spawnPoint.y)));
          Future.delayed(const Duration(seconds: 2), () {
            bossWorld
                .add(bigFish(Vector2(spawnPoint.x, spawnPoint.y), bossWorld));
          });
        }
      }
    }
    await attackCooldown(3);
    attackOnCooldown = false;
  }

  void bossDefeated() {
    mutantFishDeath m =
        mutantFishDeath(super.position, super.size, Vector2(0, 0));
    super.removeFromParent();
    bossWorld.add(m);
  }

  @override
  void onMount() {
    // TODO: implement onMount
    cutscene();
    super.onMount();
  }
  void freezeEvent(){
    canSpawntoxicBubble = false;
    speed = 0;
    screenFreezeEffect b = screenFreezeEffect(Vector2(0,0));
    bossWorld.add(b);
    Future.delayed(const Duration(seconds: 7), () {
        speed = 300;
         canSpawntoxicBubble = true;
      });
  }

  void cutscene() {
    position = tiledMap.size / 2 - size / 2;
    // game.camera.viewfinder.visibleGameSize = size;
    // game.camera.follow(this);
    final dialog = TextComponent(text: 'nanda gey')..position = Vector2.zero();
    add(dialog);
    game.camera.viewfinder.add(ScaleEffect.by(
        Vector2.all(2), EffectController(duration: 2), onComplete: () async {
      await Future.delayed(Duration(seconds: 1), () async {
        dialog.text = 'Face your fears';
        await Future.delayed(Duration(seconds: 1), () {
          remove(dialog);
        });
      });
      game.camera.viewfinder.add(ScaleEffect.by(
          Vector2.all(0.5), EffectController(duration: 2), onComplete: () {
        position = initialPosition;
        state = 'Start';
      }));
    }));

    
  }
}
