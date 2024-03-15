import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';

class ThunderStorm extends PositionComponent {
  SpriteAnimation thunder = SpriteAnimation.fromFrameData(
      Flame.images.fromCache('events/thunder-strike.png'),
      SpriteAnimationData.sequenced(
        amount: 11,
        stepTime: 0.05,
        textureSize: Vector2(160, 233),
      ));
  Sprite cloud1 = Sprite(Flame.images.fromCache('events/black-cloud.png'),
      srcPosition: Vector2(0, 0), srcSize: Vector2(11 * 16, 7 * 16));
  Sprite cloud2 = Sprite(Flame.images.fromCache('events/black-cloud.png'),
      srcPosition: Vector2(11 * 16, 0), srcSize: Vector2(9 * 16, 7 * 16));
  ThunderStorm();
  @override
  void onMount() {
    // TODO: implement onMount
    _getCloudThunder();
    spawnClouds();
    // Future.delayed(const Duration(seconds: 1), () {
    //   removeFromParent();
    // });
    super.onMount();
  }

  PositionComponent _getCloudThunder() {
    final spawnThunder = SpawnComponent(
        factory: (i) => _getThunderStrike(),
        period: 3,
        area: Rectangle.fromCenter(
            center: Vector2(3 * 16, 4 * 16),
            size: Vector2(_getCloud1().size.x * 0.3, 2)));
    return PositionComponent(
        children: [_getCloud1()..priority = 1, spawnThunder]);
  }

  void spawnClouds() {
    Random random = Random();
    final spawnCloud = SpawnComponent(
      factory: (i) {
        final num = random.nextInt(3);
        final time = 10 + random.nextInt(20);
        switch (num) {
          case 0:
            return _getCloud1()
              ..addAll([
                RemoveEffect(delay: 10),
                MoveEffect.by(Vector2(1920, 0),
                    EffectController(duration: time.toDouble()))
              ]);
          case 1:
            return _getCloud2()
              ..add(RemoveEffect(delay: 10))
              ..addAll([
                RemoveEffect(delay: 10),
                MoveEffect.by(Vector2(1920, 0),
                    EffectController(duration: time.toDouble()))
              ]);
          case 2:
            return _getCloudThunder()
              ..add(RemoveEffect(delay: 10))
              ..addAll([
                RemoveEffect(delay: 10),
                MoveEffect.by(Vector2(1920, 0),
                    EffectController(duration: time.toDouble()))
              ]);
          default:
            return PositionComponent();
        }
      },
      period: 1.5,
      area: Rectangle.fromCenter(
          center: Vector2(1920*0.25, 50), size: Vector2(1920*0.5, 50)),
    );
    add(spawnCloud);
  }

  SpriteComponent _getCloud2() {
    return SpriteComponent(sprite: cloud2);
  }

  SpriteAnimationComponent _getThunderStrike() {
    return SpriteAnimationComponent(animation: thunder, size: Vector2(64, 180))
      ..add(RemoveEffect(delay: 1));
  }

  SpriteComponent _getCloud1() {
    return SpriteComponent(sprite: cloud1);
  }
}
