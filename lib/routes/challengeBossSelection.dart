import 'package:flutter/material.dart';

class ChallengeBossSelection extends StatefulWidget {
  static String id = 'ChallengeBossSelection';
  VoidCallback toBossWorldSelection;
  VoidCallback toChallengeLevel;
  String locationName;
  Map<String,dynamic> data = {};
  ChallengeBossSelection(
      {required this.toBossWorldSelection,
      required this.toChallengeLevel,
      required this.locationName,
      super.key});

  @override
  State<ChallengeBossSelection> createState() => _ChallengeBossSelectionState();
}

class _ChallengeBossSelectionState extends State<ChallengeBossSelection> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(color: Colors.amber),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Hello'),
    //           ListView.builder(itemCount: ,itemBuilder:  (context, index) {
    // return ListTile(
    //   title: Text(items[index]),
    // );),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        widget.toChallengeLevel();
                      },
                      child: const Text(
                        'Underwater\nCleaning',
                        style: TextStyle(),
                        textAlign: TextAlign.center,
                      )),
                  ElevatedButton(
                    onPressed: () {
                      widget.toBossWorldSelection();
                    },
                    child: const Text(
                      'BossFight\nChallenge',
                      style: TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
