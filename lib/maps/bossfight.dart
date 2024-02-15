import 'dart:async';
import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/painting.dart';
import 'package:oceanoasis/components/joystickplayer.dart';
import 'package:oceanoasis/homescreen.dart';

class PacificOceanBossFight extends Component
    with HasCollisionDetection, HasGameReference<MyGame> {
  late final TiledComponent tiledMap;
  static const id = 'PacificOceanBoss';
  late final CameraComponent cameraComponent;
  late final World bossWorld;
  late final JoystickPlayer player;

  //DEFINE YOUR CONSTRUCTOR HERE
  

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
    // add component to the world
    await bossWorld.add(tiledMap);
    cameraComponent = CameraComponent(world: bossWorld)
      ..viewport.anchor = Anchor.center;
    cameraComponent.moveBy(Vector2(1920 * 0.5, 1080 * 0.5));
    //define  and add player
    addPlayer();

    //CONTINUE <------

    //finally add world and camera
    await add(bossWorld);
    await add(cameraComponent);
    // tiledMap = TiledComponent.load(fileName, destTileSize)
    return super.onLoad();
  }

  //For every frame update
  @override
  void update(double dt) {
    // TODO: implement update
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
    final player = JoystickPlayer(
        joystick: joystick,
        position:
            Vector2(spawnPoint!.objects.first.x, spawnPoint!.objects.first.y),
        playerScene: 0, image: Flame.images.fromCache('character2-swim1.png'), animationData: SpriteAnimationData.sequenced(
                amount: 6, // Number of frames in your animation
                stepTime: 0.15, // Duration of each frame
                textureSize: Vector2(48, 48)) );
    bossWorld.add(player);
    (Platform.isAndroid || Platform.isIOS)
        ? game.camera.viewport.add(joystick)
        : '';
  }
}
