import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:oceanoasis/maps/overworld/collision_block.dart';
import 'package:oceanoasis/maps/overworld/ladder.dart';
import 'package:oceanoasis/maps/overworld/machines/paperMachine.dart';
import 'package:oceanoasis/maps/overworld/machines/plasticMachine.dart';
import 'package:oceanoasis/maps/overworld/overworldplayer.dart';
import 'package:oceanoasis/routes/gameplay.dart';
import 'dart:io' show Platform;

class PacificOcean extends Component
    with HasCollisionDetection, HasGameReference<MyGame>, TapCallbacks {
  late final TiledComponent tiledMap;
  static const id = 'PacificOcean';
  late final CameraComponent cameraComponent;
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
    loadPlayerJoystick();
    loadCollision();
    cameraSettings();
    await add(myWorld);

    // add(MyScreenHitbox());
    return super.onLoad();
  }

  void cameraSettings() {
    game.camera = CameraComponent(world: myWorld);
    game.camera.viewfinder.visibleGameSize =
        Vector2(tiledMap.size.x / 3, tiledMap.size.y / 2);

    // game.camera.moveBy(Vector2(1920 / 2, 1080 / 2));
    game.camera.follow(player);
    game.camera.setBounds(Rectangle.fromCenter(
        center: Vector2(tiledMap.size.x / 2, tiledMap.size.y / 2),
        size: Vector2(tiledMap.size.x / 2 + 170, tiledMap.size.y / 2)));
  }

  void loadPlayerJoystick() {
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
      position:
          Vector2(spawnPoint!.objects.first.x, spawnPoint.objects.first.y - 32),
    )
      ..anchor = Anchor.center
      ..debugMode = true;
    player.anchor = Anchor.center;

    tiledMap.add(player);
    (Platform.isAndroid || Platform.isIOS)
        ? game.camera.viewport.add(joystick)
        : '';
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
        )..debugMode = true;

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
              ..debugMode = true);
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
  }

  @override
  void onRemove() {
    cameraComponent.removeFromParent();
    myWorld.removeFromParent();
    super.onRemove();
  }

  @override
  void onTapUp(TapUpEvent event) {
    // TODO: implement onTapUp
    print('tapping');
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
  //SOME LEGIT CODE I COOK : MIGHT NEED IT LATER
  // for (final object in objectGroup!.objects) {
  //   if (object.isPolygon) {
  //     List<Vector2> polygonPoints = [];
  //     for (var element in object.polygon) {
  //       polygonPoints.add(Vector2(
  //           element.x / 2 + object.x / 2, element.y / 2 + object.y / 2));
  //     }
  //     game.gameComponents.add(
  //       PolygonComponent(
  //         polygonPoints,
  //       ),
  //     );
  //   } else if (object.isRectangle) {
  //     game.gameComponents.add(RectangleComponent(
  //         size: Vector2(object.width, object.height),
  //         position: Vector2(object.x, object.y),
  //         children: [RectangleHitbox()]));
  //   } else if (object.isEllipse) {
  //     game.gameComponents.add(CircleComponent(
  //         radius: 80,
  //         position: Vector2(object.x, object.y),
  //         paint: BasicPalette.green.paint()));
  //   }
  // }
}
