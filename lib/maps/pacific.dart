import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:oceanoasis/components/joystickplayer.dart';
import 'package:oceanoasis/components/Boss/overworldplayer.dart';
import 'package:oceanoasis/routes/gameplay.dart';
import 'dart:io' show Platform;

class PacificOcean extends Component
    with
        HasCollisionDetection,
        DragCallbacks,
        HasGameReference<MyGame>,
        TapCallbacks {
  late final TiledComponent tiledMap;
  static const id = 'PacificOcean';
  late final CameraComponent cameraComponent;
  late final World myWorld;
  late final OverworldPlayer player;

  bool _isDragged = false;

  PacificOcean({super.key});
  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    // game.camera.stop();
    overlaysSetting();
    myWorld = World();
    tiledMap = await TiledComponent.load('depositeland.tmx', Vector2.all(16));
    await myWorld.add(tiledMap);

    // loadCollision();
    loadPlayerJoystick();
    cameraSettings();
    await add(myWorld);
    // add(MyScreenHitbox());
    return super.onLoad();
  }

  void cameraSettings() {
    game.camera = CameraComponent(world: myWorld);
    game.camera.viewfinder.zoom = 1.5;
    game.camera.moveBy(Vector2(1920 / 2, 1080 / 2));
    game.camera.follow(player);
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
      joystick: joystick,
      position: Vector2.zero(),
      playerScene: 1,
      image: Flame.images.fromCache('character-walk1.png'),
      animationData: SpriteAnimationData.sequenced(
          amount: 7, stepTime: 0.1, textureSize: Vector2.all(128)),
    )
      ..anchor = Anchor.center
      ..debugMode = true;

    player.setPosition =
        Vector2(spawnPoint!.objects.first.x, spawnPoint.objects.first.y);
    player.anchor = Anchor.center;
    player.size = Vector2.all(64);

    tiledMap.add(player);
    (Platform.isAndroid || Platform.isIOS)
        ? game.camera.viewport.add(joystick)
        : '';
  }

  void loadCollision() {
    final collisionGroup =
        tiledMap.tileMap.getLayer<ObjectGroup>('Collision Objects');
    for (final object in collisionGroup!.objects) {
      // if (object.name.compareTo('Whirlpool') == 0) {
      //   myWorld.add(Whirlpool(
      //       Vector2(object.x, object.y), Vector2(object.width, object.height)));
      // }
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _isDragged = true;
    print('hello');
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    print('object');
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _isDragged = false;
  }

  @override
  void onRemove() {
    game.overlays.remove("TopMenu");
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
