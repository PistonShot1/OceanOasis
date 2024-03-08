import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';

import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:oceanoasis/components/Boss/crabBoss.dart';
import 'package:oceanoasis/components/Boss/freezeEffect.dart';
import 'package:oceanoasis/components/Boss/bossfightplayer.dart';
import 'package:oceanoasis/components/projectiles/bullet.dart';
import 'package:oceanoasis/components/projectiles/powerUp.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/routes/gameplay.dart';
import 'package:oceanoasis/tools/toolbox.dart';

class PacificOceanBossFight extends Component
    with HasCollisionDetection, HasGameReference<MyGame>, KeyboardHandler {
  late final TiledComponent tiledMap;
  static const id = 'PacificOceanBoss';
  late final World bossWorld;
  late final BossFightPlayer player;
  late final crabBoss boss;

  //DEFINE YOUR CONSTRUCTOR HERE
  PacificOceanBossFight();

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    //World is bossWorld, add all component to world

    //stop previous camera session
    game.camera.stop();

    //define tiled map
    tiledMap =
        await TiledComponent.load('boss-fight-scene.tmx', Vector2.all(16));
    //define camera and intialize world
    bossWorld = World();
    // add tiledmap component to the world
    await bossWorld.add(tiledMap);

    //define  and add player

    //finally add world
    await add(bossWorld);
    bossWorld.add(ScreenHitbox()..debugMode = true);
    
    cameraSettings();

    addPlayer();
    spawnBoss();
    loadToolbar(WeaponProperty.weapons.length);
    return super.onLoad();
  }

  void cameraSettings() {
    game.camera = CameraComponent(world: bossWorld)
      ..viewfinder.anchor = Anchor.center;
    game.camera.moveBy(tiledMap.size / 2);
    game.camera.viewfinder.visibleGameSize =
        Vector2(tiledMap.size.x * 0.9, tiledMap.size.y * 0.9);
    game.camera.setBounds(Rectangle.fromPoints(
        Vector2(0, 0), Vector2(tiledMap.size.x * 0.5, tiledMap.size.y * 0.5)));
    // game.camera.moveBy(Vector2(1920 * 0.5, 1080 * 0.5));
  }

  void addPlayer() {
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    final joystick = JoystickComponent(
      key: ComponentKey.named('JoystickHUD'),
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    final spawnPoint = tiledMap.tileMap.getLayer<ObjectGroup>('Spawn Point');
    player = BossFightPlayer(
      currentWorld: bossWorld,
      joystick: joystick,
      position:
          Vector2(spawnPoint!.objects.first.x, spawnPoint!.objects.first.y),
      playerScene: 0,
      image: Flame.images.fromCache('main-character-1/Idle.png'),
      animationData: SpriteAnimationData.sequenced(
          amount: 6, // Number of frames in your animation
          stepTime: 0.15, // Duration of each frame
          textureSize: Vector2(35, 39)),
    );
    player.scale = Vector2.all(2);

    bossWorld.add(player);

    bossWorld.add(PositionComponent()
      ..size = Vector2(tiledMap.size.x - 50, tiledMap.size.y - 50)
      ..position = Vector2.all(25)
      ..debugMode = true); //just for debug
    player.setPlayerBoundary = [
      25,
      tiledMap.size.x - 50,
      25,
      tiledMap.size.y
    ]; //Here to set boundary
    (Platform.isAndroid || Platform.isIOS)
        ? game.camera.viewport.add(joystick)
        : '';
  }

  void spawnBoss() {
    boss = crabBoss(bossWorld, player, tiledMap);
    bossWorld.add(boss);
  }

  void loadToolbar(int itemNum) async {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      for (int i = 0; i < itemNum; i++) {
        final toolbox = ItemToolBox(() {},
            position: Vector2(
                tiledMap.size.x / 2 - 400 + 54 * i, tiledMap.size.y * 0.58),
            iconItem: WeaponProperty.weapons[i]['iconweapon']!,
            item: WeaponProperty.weapons[i]['weapon'],
            keybind: _mapKeyBind(i),
            detectTap: true,
            player: player)
          ..size = Vector2.all(54);
        await game.camera.viewport.add(toolbox);

        // 16*2(the size of the tile image)* 3 (the set scale) * i (y positioning)
      }
    } else {
      for (int i = 0; i < itemNum; i++) {
        final toolbox = ItemToolBox(() {},
            position: Vector2(
                tiledMap.size.x / 2 - 100 + 32 * 3 * i, tiledMap.size.y * 0.9),
            iconItem: WeaponProperty.weapons[i]['iconweapon']!,
            item: WeaponProperty.weapons[i]['weapon'],
            detectTap: true,
            player: player)
          ..scale = Vector2.all(3);
        await game.camera.viewport.add(toolbox);
        await game.camera.viewport.add(toolbox);

        // 16*2(the size of the tile image)* 3 (the set scale) * i (y positioning)
      }
    }
  }

  LogicalKeyboardKey? _mapKeyBind(int i) {
    switch (i) {
      case 0:
        return LogicalKeyboardKey.digit1;
      case 1:
        return LogicalKeyboardKey.digit2;
      case 2:
        return LogicalKeyboardKey.digit3;
      default:
        return null;
    }
  }

  int randomNumber = 0;
  Vector2 spawnOffset = Vector2(0, 0);

  int getRandomInt(int min, int max) {
    Random random = Random();
    return min + random.nextInt(max - min + 1);
  }

  bool spawnPowerUpCooldown = false;

  void spawnPowerUps() {
    if (spawnPowerUpCooldown == false) {
      // ignore: avoid_print
      print("HEY");
      spawnPowerUpCooldown = true;
      final bigFishspawnPoint =
          tiledMap.tileMap.getLayer<ObjectGroup>('powerUpSpawn');
      randomNumber = getRandomInt(1, 9);
      switch (randomNumber) {
        case 1:
          for (final spawnPoint in bigFishspawnPoint!.objects) {
            if (spawnPoint.name == '1') {
              powerUp p = powerUp(Vector2(spawnPoint.x, spawnPoint.y),
                  Vector2(spawnOffset.x, spawnOffset.y));
              bossWorld.add(p);
            }
          }
          break;
        case 2:
          for (final spawnPoint in bigFishspawnPoint!.objects) {
            if (spawnPoint.name == '2') {
              powerUp p = powerUp(Vector2(spawnPoint.x, spawnPoint.y),
                  Vector2(spawnOffset.x, spawnOffset.y));
              bossWorld.add(p);
            }
          }
          break;
        case 3:
          for (final spawnPoint in bigFishspawnPoint!.objects) {
            if (spawnPoint.name == '3') {
              powerUp p = powerUp(Vector2(spawnPoint.x, spawnPoint.y),
                  Vector2(spawnOffset.x, spawnOffset.y));
              bossWorld.add(p);
            }
          }
          break;
        case 4:
          for (final spawnPoint in bigFishspawnPoint!.objects) {
            if (spawnPoint.name == '4') {
              powerUp p = powerUp(Vector2(spawnPoint.x, spawnPoint.y),
                  Vector2(spawnOffset.x, spawnOffset.y));
              bossWorld.add(p);
            }
          }
          break;
        case 5:
          for (final spawnPoint in bigFishspawnPoint!.objects) {
            if (spawnPoint.name == '5') {
              powerUp p = powerUp(Vector2(spawnPoint.x, spawnPoint.y),
                  Vector2(spawnOffset.x, spawnOffset.y));
              bossWorld.add(p);
            }
          }
          break;
        case 6:
          for (final spawnPoint in bigFishspawnPoint!.objects) {
            if (spawnPoint.name == '6') {
              powerUp p = powerUp(Vector2(spawnPoint.x, spawnPoint.y),
                  Vector2(spawnOffset.x, spawnOffset.y));
              bossWorld.add(p);
            }
          }
          break;
        case 7:
          for (final spawnPoint in bigFishspawnPoint!.objects) {
            if (spawnPoint.name == '7') {
              powerUp p = powerUp(Vector2(spawnPoint.x, spawnPoint.y),
                  Vector2(spawnOffset.x, spawnOffset.y));
              bossWorld.add(p);
            }
          }
          break;
        case 8:
          for (final spawnPoint in bigFishspawnPoint!.objects) {
            if (spawnPoint.name == '8') {
              powerUp p = powerUp(Vector2(spawnPoint.x, spawnPoint.y),
                  Vector2(spawnOffset.x, spawnOffset.y));
              bossWorld.add(p);
            }
          }
          break;
        case 9:
          for (final spawnPoint in bigFishspawnPoint!.objects) {
            if (spawnPoint.name == '9') {
              powerUp p = powerUp(Vector2(spawnPoint.x, spawnPoint.y),
                  Vector2(spawnOffset.x, spawnOffset.y));
              bossWorld.add(p);
            }
          }
          break;
        default:
          break;
      }
      Future.delayed(const Duration(seconds: 10), () {
        spawnPowerUpCooldown = false;
      });
    }
  }

  bool canShoot = true;
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // TODO: implement onKeyEvent
    if (keysPressed.contains(LogicalKeyboardKey.space) &&
        player.currentTool.id == 'pistol' &&
        canShoot == true) {
      canShoot = false;
      playerShoot();
      Future.delayed(const Duration(milliseconds: 200), () {
        canShoot = true;
      });
    } else if (keysPressed.contains(LogicalKeyboardKey.space) &&
        player.currentTool.id == 'freezeDevice' &&
        canShoot == true) {
      canShoot = false;
      playerFreeze();
      Future.delayed(const Duration(seconds: 1), () {
        canShoot = true;
      });
    }
    return super.onKeyEvent(event, keysPressed);
  }

  final Vector2 bulletPositionOffset = Vector2(0, -30);

  void playerShoot() {
    bossWorld.add(
        bullet(player.position, player.facingDirection, bulletPositionOffset));
  }

  void playerFreeze() {
    if (player.currentEnergyLevel >= 0) {
      //energy to use the device
      player.currentEnergyLevel =
          player.currentEnergyLevel - 0; //subtract accordingly
      bossWorld.add(freezeEffect(player.position));
      Future.delayed(const Duration(seconds: 1), () {
        boss.freezeEvent();
      });
    }
  }

  @override
  void update(double dt) {
    spawnPowerUps();
    super.update(dt);
  }
}
