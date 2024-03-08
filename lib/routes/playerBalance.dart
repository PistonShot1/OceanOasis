import 'package:flutter/material.dart';
import 'package:oceanoasis/routes/gameplay.dart';

class BalanceWidget extends StatefulWidget {
  final MyGame game;
  const BalanceWidget({required this.game, super.key});

  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 50,
          height: 50,
          child: Material(
            color: Colors.red,
            child: ListenableBuilder(
                listenable: widget.game.playerData,
                builder: (BuildContext context, Widget? child) {
                  return Text(widget.game.playerData.gameBalance.toString());
                }),
          ),
        ));
  }
}
