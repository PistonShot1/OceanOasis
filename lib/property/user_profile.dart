import 'package:flutter/material.dart';
import 'package:oceanoasis/property/game_properties.dart';
import 'package:oceanoasis/property/level_property.dart';

class UserProfile extends ChangeNotifier {
  String? uid;
  String? email;
  int? gamebalance;
  List<double>? wastebalance;
  List<double>? levelhighestScore;
  UserProfile(
      {this.uid,
      this.email,
      this.gamebalance,
      this.levelhighestScore,
      this.wastebalance});

  Future<void> setData(Map<String, dynamic> data) async {
    uid = data['uid'] as String?;
    email = data['email'] as String?;
    gamebalance = data['gamebalance'] as int?;
    wastebalance = data['wastebalance'];
    levelhighestScore = data['levelhighestScore'] as List<double>?;
    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'gamebalance': gamebalance};
  }

  //default user instance
  static Map<String, dynamic> getuserInstance(String uid, String email) {
    return {
      'uid': uid,
      'email': email,
      'gamebalance': 0,
      'wastebalance': _getDefaultWasteBalance(),
      'levelhighestScore': _levelhighestScore()
    };
  }

  static List<double> _getDefaultWasteBalance() {
    List<double> defaults = [];
    for (WasteType type in WasteType.values) {
      defaults.add(0);
    }
    return defaults;
  }

  static List<double> _levelhighestScore() {
    List<double> defaults = [];
    for (Levels level in Levels.values) {
      defaults.add(0);
    }
    return defaults;
  }
}
