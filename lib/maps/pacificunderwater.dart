import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oceanoasis/components/rectangleCollider.dart';
import 'package:oceanoasis/components/toolbox.dart';
import 'package:oceanoasis/homescreen.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/wasteComponents/newspaper.dart';

class PacificOceanUnderwater extends Component
    with HasGameReference<MyGame>, HasCollisionDetection {
  static const id = 'PacificOceanUnderwater';
  late final TiledComponent tiledMap;
  late final World underwaterWorld;
  CameraComponent cameraComponent = CameraComponent();
  late final ItemToolBox uiComponent;
  late final Map<String, double> spawnArea;
  final int levelNumber;
  bool startSpawn = false;
  int wasteList = 0;
  int playeritems;
  PacificOceanUnderwater(
      {required this.levelNumber, required this.playeritems});
  @override
  Future<void> onLoad() async {
    // TODO: implement onLoad
    game.camera.stop();

    underwaterWorld = World();
    tiledMap =
        await TiledComponent.load('pacific-ocean-final.tmx', Vector2.all(16));
    await underwaterWorld.add(tiledMap);

    //JoyStick addition and player for mobile

    loadPlayerJoystick();
    initspawnWaste();
    cameraSettings();
    loadToolbar(playeritems);
    await add(underwaterWorld);
    await add(cameraComponent);

    //DEBUG
    // ChildCounterComponent counterComponent = ChildCounterComponent(
    //   target: underwaterWorld,
    // );
    // add(counterComponent);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    wasteSpawn();
    super.update(dt);
  }

  void wasteSpawn() {
    if (startSpawn &&
        wasteList < LevelProperty.levelProperty['$levelNumber']['maxSpawn']) {
      startSpawn = false;
      Component waste = NewsPaper(position: spawnLogic());
      Future.delayed(const Duration(seconds: 3), () async {
        await underwaterWorld.add(waste);
        startSpawn = true;
        wasteList++;
      });
    }
  }

  //check pacific.dart for camera movement
  void cameraSettings() {
    cameraComponent = CameraComponent(world: underwaterWorld);
    cameraComponent.viewport.anchor = Anchor.center;
    cameraComponent.viewfinder.zoom = 1;
    cameraComponent.moveBy(Vector2(1920 * 0.5, 1184 * 0.5));

    // if (Platform.isAndroid) {
    //   cameraComponent.viewport.add(game.joystick);
    // }

    cameraComponent.viewport.add(game.joystick);
  }

  void loadPlayerJoystick() {
    final spawnPoint = tiledMap.tileMap.getLayer<ObjectGroup>("Player Spawn");
    game.player.setPosition =
        Vector2(spawnPoint!.objects.first.x, spawnPoint.objects.first.y);
    underwaterWorld.add(game.player);
    (Platform.isAndroid || Platform.isIOS)
        ? cameraComponent.viewport.add(game.joystick)
        : '';
  }

  void _initSpawnArea(double minX, double minY, double maxX, double maxY) {
    spawnArea = {'minX': minX, 'minY': minY, 'maxX': maxX, 'maxY': maxY};
  }

  void initspawnWaste() {
    final spawnPoints = tiledMap.tileMap.getLayer<ObjectGroup>('Spawn Layer');
    final objects = spawnPoints!.objects;
    for (TiledObject object in objects) {
      underwaterWorld.add(RectangleCollidable(Vector2(object.x, object.y),
          Vector2(object.width, object.height), false));
      _initSpawnArea(object.x, object.y, object.x + object.width,
          object.y + object.height);
    }

    startSpawn = true;
  }

  void loadToolbar(int itemNum) async {
    final toolbarPoint = tiledMap.tileMap.getLayer<ObjectGroup>('UI layer');
    final objects = toolbarPoint!.objects;

    //keybinding and text to toolbox
    final regular = TextPaint(
        style: TextStyle(
            fontSize: 10.0,
            color: BasicPalette.white.color,
            fontFamily: 'Retro Gaming'));
    final keyMap = {
      0: LogicalKeyboardKey.digit1,
      1: LogicalKeyboardKey.digit2,
      2: LogicalKeyboardKey.digit3
    };
    for (TiledObject object in objects) {
      for (int i = 0; i < itemNum; i++) {
        final toolbox = ItemToolBox(() {},
            position: Vector2(object.x, object.y + 16 * 2 * 2 * i),
            iconItem: ToolSlashProperty.toolIcon[i]['icontool']!,
            item: ToolSlashProperty.toolIcon[i]['tool'],
            keybind: keyMap[i]!);
        await underwaterWorld.add(toolbox);
        toolbox.add(TextComponent(
            text: '${i + 1}', textRenderer: regular, position: Vector2.zero()));

        // 16*2(the size of the tile image)* 2 (the set scale) * i (y positioning)
      }
    }
  }

  Vector2 spawnLogic() {
    Random random = Random();
    double x = spawnArea['minX']! +
        random.nextInt(
            spawnArea['maxX']!.round() - spawnArea['minX']!.round() + 1);
    double y = spawnArea['minY']! +
        random.nextInt(
            spawnArea['maxY']!.round() - spawnArea['minY']!.round() + 1);
    return Vector2(x, y);
  }

  void loadPuzzle() {}
}
