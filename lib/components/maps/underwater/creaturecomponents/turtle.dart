import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/components/maps/underwater/creaturecomponents/creature.dart';

class Turtle extends Creature {
  Turtle()
      : super(SpriteAnimationComponent.fromFrameData(
            Flame.images.fromCache('creatures/turtle/Walk.png'),
            SpriteAnimationData.sequenced(
                amount: 6, // Number of frames in your animation
                stepTime: 0.1, // Duration of each frame
                textureSize: Vector2(48, 48))));
}
