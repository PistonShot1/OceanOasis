import 'package:flame/events.dart';
import 'package:flame_tiled/flame_tiled.dart';

class TiledMapSelection extends TiledComponent with DragCallbacks {
  TiledMapSelection(RenderableTiledMap tileMap) : super(tileMap);
  @override
  Future<void>? onLoad() {
    // TODO: implement onLoad
    return super.onLoad();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // TODO: implement onDragUpdate

    //multiply by negative for opposing direction
    game.camera.moveBy(event.localDelta * -1); 
    super.onDragUpdate(event);
  }
}
