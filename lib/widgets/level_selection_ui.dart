import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/my_game.dart';
import 'package:flame/widgets.dart';

// ignore: must_be_immutable
class LevelSelectionUI extends StatefulWidget {
  MyGame game;
  LevelSelectionUI({super.key, required this.game});

  @override
  State<LevelSelectionUI> createState() => _LevelSelectionUIState();
}

class _LevelSelectionUIState extends State<LevelSelectionUI> {
  bool isPressed = false;
  late bool isMuted;
  late Sprite image1, image2, shopCart, muteImg, unmuteImg;
  @override
  void initState() {
    // TODO: implement initState
    image1 = Sprite(widget.game.images.fromCache('ui/ui-buttons.png'),
        srcPosition: Vector2(0, 5 * 16), srcSize: Vector2.all(4 * 16));
    image2 = Sprite(widget.game.images.fromCache('ui/ui-buttons.png'),
        srcPosition: Vector2(4 * 16, 9 * 16), srcSize: Vector2.all(4 * 16));
    shopCart = Sprite(widget.game.images.fromCache('ui/ui-buttons.png'),
        srcPosition: Vector2(0, 9 * 16), srcSize: Vector2.all(4 * 16));
    unmuteImg = Sprite(widget.game.images.fromCache('ui/ui-buttons.png'),
        srcPosition: Vector2(5 * 4 * 16, 5 * 16), srcSize: Vector2.all(4 * 16));
    muteImg = Sprite(widget.game.images.fromCache('ui/ui-buttons.png'),
        srcPosition: Vector2(6 * 4 * 16, 5 * 16), srcSize: Vector2.all(4 * 16));

    isMuted = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 50,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    widget.game.toFacility();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                            boxShadow: const [
                              BoxShadow(color: Colors.black, blurRadius: 2)
                            ]),
                        child: Stack(
                          children: [
                            Positioned.fill(
                                child: Image.asset(
                              'assets/images/ui/button-ui.png',
                              fit: BoxFit.fill,
                            )),
                            Center(
                                child: Image.asset(
                                    'assets/images/ui/recycle.png',
                                    fit: BoxFit.cover))
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                SpriteButton(
                  sprite: (!isPressed) ? image1 : image2,
                  pressedSprite: (!isPressed) ? image1 : image2,
                  onPressed: () {
                    setState(() {
                      isPressed = !isPressed;
                    });
                  },
                  width: 4 * 16,
                  height: 4 * 16,
                  label: const Text(''),
                ),
                ...showSelectionMenu()
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> showSelectionMenu() {
    List<SpriteButton> spriteButtons = [
      SpriteButton(
          sprite: shopCart,
          pressedSprite: shopCart,
          onPressed: () {
            widget.game.router.pushOverlay('ShopUI');
          },
          width: 4 * 16,
          height: 4 * 16,
          label: Text('')),
      SpriteButton(
          sprite: (isMuted) ? muteImg : unmuteImg,
          pressedSprite: (isMuted) ? muteImg : unmuteImg,
          onPressed: () {},
          width: 4 * 16,
          height: 4 * 16,
          label: Text('')),
    ];
    if (isPressed) {
      return spriteButtons;
    } else {
      return [];
    }
  }
}
