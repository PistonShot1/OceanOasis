import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:oceanoasis/components/maps/overworld/boundary_block.dart';
import 'package:oceanoasis/components/maps/overworld/collision_block.dart';
import 'package:oceanoasis/components/maps/overworld/ladder.dart';
import 'package:oceanoasis/components/maps/overworld/machines/glassMachine.dart';
import 'package:oceanoasis/components/maps/overworld/machines/metalMachine.dart';
import 'package:oceanoasis/components/maps/overworld/machines/paperMachine.dart';
import 'package:oceanoasis/components/maps/overworld/machines/plasticMachine.dart';
import 'package:oceanoasis/components/maps/overworld/machines/radioactiveMachine.dart';
import 'package:oceanoasis/components/maps/overworld/overworldplayer.dart';
import 'package:oceanoasis/my_game.dart';
import 'dart:io' show Platform;

class PacificOcean extends Component
    with HasCollisionDetection, HasGameReference<MyGame>, TapCallbacks {
  late final TiledComponent tiledMap;
  static const id = 'PacificOcean';
  late final World myWorld;
  late final OverworldPlayer player;

  List<CollisionBlock> collisionBlocks = [];

  PacificOcean({super.key});
  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    // game.camera.stop();
    overlaysSetting();
    myWorld = World();

    tiledMap = await TiledComponent.load('depositeland.tmx', Vector2.all(16));
    await myWorld.add(tiledMap);

    loadMachines();
    cameraSettings();
    loadPlayerJoystick();
    loadCollision();

    await add(myWorld);

    // add(MyScreenHitbox());
    return super.onLoad();
  }

  void cameraSettings() {
    game.camera = CameraComponent(world: myWorld);
    game.camera.viewfinder.visibleGameSize =
        Vector2(tiledMap.size.x / 3, tiledMap.size.y / 2);

    // game.camera.moveBy(Vector2(1920 / 2, 1080 / 2));
    game.camera.setBounds(Rectangle.fromCenter(
        center: Vector2(tiledMap.size.x / 2, tiledMap.size.y / 2),
        size: Vector2(tiledMap.size.x / 2 + 170, tiledMap.size.y / 2)));
  }

  void loadPlayerJoystick() {
    final spawnPoint = tiledMap.tileMap.getLayer<ObjectGroup>('Spawn Point');
    Color greyColor = Colors.grey.withOpacity(0.5);
    Paint innerPaint = Paint()
      ..color = greyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    Paint outterpaint = Paint()
      ..color = greyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    final joystick = JoystickComponent(
        key: ComponentKey.named('JoystickHUD'),
        knob: CircleComponent(
            radius: MediaQuery.of(game.buildContext!).size.width / 64,
            paint: innerPaint),
        background: CircleComponent(
            radius: MediaQuery.of(game.buildContext!).size.width / 16,
            paint: outterpaint),
        margin: const EdgeInsets.only(left: 40, bottom: 40),
        size: 50);
    player = OverworldPlayer(
      joystick: joystick,
      position:
          Vector2(spawnPoint!.objects.first.x, spawnPoint.objects.first.y - 32),
    )..anchor = Anchor.center;
    player.anchor = Anchor.center;

    tiledMap.add(player);
    (Platform.isAndroid || Platform.isIOS)
        ? game.camera.viewport.add(joystick)
        : '';

    game.camera.follow(player);
  }

  void loadCollision() {
    final collisionGroup =
        tiledMap.tileMap.getLayer<ObjectGroup>('Walking Platform');
    for (final object in collisionGroup!.objects) {
      if (object.isRectangle) {
        final platform = CollisionBlock(
          position: object.position,
          size: object.size,
          isPlatform: true,
        );

        collisionBlocks.add(platform);
        myWorld.add(platform);
      } else if (object.isPolygon) {
        final vertices = <Vector2>[];
        for (final point in object.polygon) {
          vertices.add(Vector2(point.x + object.x, point.y + object.y));
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
    final ladderCollision =
        tiledMap.tileMap.getLayer<ObjectGroup>('Climbing Platform');
    for (final object in ladderCollision!.objects) {
      if (object.isRectangle) {
        myWorld.add(
            LadderComponent(size: object.size, position: object.position)
              );
      }
    }

    final boundaryblocks =
        tiledMap.tileMap.getLayer<ObjectGroup>('Collision Boundary');
    for (final object in boundaryblocks!.objects) {
      if (object.isRectangle) {
        myWorld
            .add(BoundaryBlock(position: object.position, size: object.size));
      }
    }
  }

  void loadMachines() {
    final paperMachine =
        tiledMap.tileMap.getLayer<ObjectGroup>('Paper Machine')!.objects.first;
    final plasticMachine = tiledMap.tileMap
        .getLayer<ObjectGroup>('Plastic Machine')!
        .objects
        .first;
    final glassMachine =
        tiledMap.tileMap.getLayer<ObjectGroup>('Glass Machine')!.objects.first;
    final metalMachine =
        tiledMap.tileMap.getLayer<ObjectGroup>('Metal Machine')!.objects.first;
    final radioactiveMachine = tiledMap.tileMap
        .getLayer<ObjectGroup>('Radioactive Machine')!
        .objects
        .first;

    myWorld.add(PaperMachine(paperMachine.position));
    myWorld.add(PlasticMachine(plasticMachine.position));
    myWorld.add(GlassMachine(glassMachine.position));
    myWorld.add(MetalMachine(metalMachine.position));
    myWorld.add(RadioactiveMachine(radioactiveMachine.position));
  }


  @override
  void onTapUp(TapUpEvent event) {
    // TODO: implement onTapUp
    super.onTapUp(event);
  }

  void overlaysSetting() {
    if (game.overlays.isActive('ToFacility')) {
      game.overlays.remove('ToFacility');
    }
    game.overlays.add('ToMapSelection');
    game.overlays.add('TotalScores');
    game.overlays.add('GameBalance');
  }
}
