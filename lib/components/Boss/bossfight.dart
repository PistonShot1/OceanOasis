import 'dart:async';
import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';

import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:oceanoasis/components/Boss/crabBoss.dart';
import 'package:oceanoasis/components/Boss/overworldplayer.dart';
import 'package:oceanoasis/components/projectiles/bullet.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/routes/homescreen.dart';
import 'package:oceanoasis/tools/slashEffect.dart';
import 'package:oceanoasis/tools/toolbox.dart';

class PacificOceanBossFight extends Component
    with HasCollisionDetection, HasGameReference<MyGame>, KeyboardHandler {
  late final TiledComponent tiledMap;
  static const id = 'PacificOceanBoss';
  late final World bossWorld;
  late final OverworldPlayer player;
  late final crabBoss boss;

  //DEFINE YOUR CONSTRUCTOR HERE
  PacificOceanBossFight() {}

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

    cameraSettings();
    add(ScreenHitbox());
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

  //For every frame update
  @override
  void update(double dt) {
    // ignore: avoid_print
    super.update(dt);
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
    player = OverworldPlayer(
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
    final toolbarPoint = tiledMap.tileMap.getLayer<ObjectGroup>('UI Layer');
    final objects = toolbarPoint!.objects;

    // toolbox
    for (TiledObject object in objects) {
      for (int i = 0; i < itemNum; i++) {
        final toolbox = ItemToolBox(() {},
            position: Vector2(object.x - 16 * 3, object.y + 16 * 2 * 3 * i),
            iconItem: WeaponProperty.weapons[i]['iconweapon']!,
            item: WeaponProperty.weapons[i]['weapon'],
            detectTap: true,
            player: player)
          ..scale = Vector2.all(3);
        await bossWorld.add(toolbox);

        // 16*2(the size of the tile image)* 3 (the set scale) * i (y positioning)
      }
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // TODO: implement onKeyEvent
    playerShoot(keysPressed);
    return super.onKeyEvent(event, keysPressed);
  }

  void playerAttack(Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      player.add(SlashEffect.clone(player.currentTool
          .slashEffect!)); //Makesure to use clone , this is to reference the same component and easier for reuse
    }
  }

  void playerShoot(Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      player.add(SlashEffect.clone(player.currentTool
          .slashEffect!)); //Makesure to use clone , this is to reference the same component and easier for reuse
      bossWorld.add(bullet(player.position, player.facingDirection, bossWorld));
    }
  }
}
