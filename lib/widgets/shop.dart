import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oceanoasis/my_game.dart';

// ignore: must_be_immutable
class ShopUI extends StatefulWidget {
  static const id = 'ShopUI';
  MyGame game;
  ShopUI({super.key, required this.game});

  @override
  State<ShopUI> createState() => _ShopUIState();
}

class _ShopUIState extends State<ShopUI> {
  late Sprite shopLabelImg, buybuttonImg, coinImg;
  @override
  void initState() {
    // TODO: implement initState
    shopLabelImg = Sprite(widget.game.images.fromCache('ui/ui-buttons.png'),
        srcPosition: Vector2(0, 0), srcSize: Vector2(15 * 16, 5 * 16));
    buybuttonImg = Sprite(widget.game.images.fromCache('ui/ui-buttons.png'),
        srcPosition: Vector2(0, 13 * 16), srcSize: Vector2(10 * 16, 5 * 16));
    coinImg = Sprite(widget.game.images.fromCache('ui/ui-buttons.png'),
        srcPosition: Vector2(10 * 16, 14 * 16), srcSize: Vector2.all(3 * 16));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: Image.asset(
          'assets/images/ui/shop-background.png',
          fit: BoxFit.fill,
        )),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                color: Color(0Xf4d690).withOpacity(0.8),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            _getDisplayItemBox(
                                Sprite(
                                  widget.game.images
                                      .fromCache('weapons/fire-sword.png'),
                                ),
                                'Fire Sword',
                                2000)
                          ],
                        ),
                        Row(children: [
                          _getDisplayItemBox(
                              Sprite(
                                widget.game.images
                                    .fromCache('weapons/laser-gun.png'),
                              ),
                              'Laser Gun',
                              1500)
                        ])
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10),
            child: IconButton(
              onPressed: () {
                widget.game.router.pop();
              },
              icon: const Icon(
                Icons.cancel_outlined,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 5),
            child: SpriteButton(
                sprite: shopLabelImg,
                pressedSprite: shopLabelImg,
                onPressed: () {},
                width: 200,
                height: 70,
                label: Material(
                    color: Colors.transparent,
                    child: Center(
                        child: Text(
                      'SHOP',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    )))),
          ),
        )
      ],
    );
  }

  Widget _getDisplayItemBox(Sprite itemImg, String itemName, int itemPrice) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1a1a1a).withOpacity(0.8),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      width: 200,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(child: SpriteWidget(sprite: itemImg),height: MediaQuery.of(context).size.height * 0.2,),
            Text(
              itemName,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SpriteButton(
                sprite: buybuttonImg,
                pressedSprite: buybuttonImg,
                onPressed: () {},
                width: 150,
                height: (Platform.isAndroid || Platform.isIOS) ? 40 : 80,
                label: Padding(
                  padding: const EdgeInsets.only(right: 20.0, bottom: 5),
                  child: Text(
                    itemPrice.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
