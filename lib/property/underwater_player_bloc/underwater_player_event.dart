part of 'underwater_player_bloc.dart';

abstract class UnderwaterPlayerEvent extends Equatable {
  const UnderwaterPlayerEvent();

  @override
  List<Object> get props => [];
}

class PlayerDamage extends UnderwaterPlayerEvent {
  const PlayerDamage();

  @override
  List<Object> get props => [];
}

class LosingBreath extends UnderwaterPlayerEvent {
  const LosingBreath();

  @override
  List<Object> get props => [];
}
