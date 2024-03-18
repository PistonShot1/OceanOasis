part of 'underwater_player_bloc.dart';

enum PlayerStatus { initial, alive, died }

class UnderwaterPlayerState extends Equatable {
  final PlayerHealth playerHealth;
  final int breathingSeconds;

  const UnderwaterPlayerState(
      {required this.playerHealth, required this.breathingSeconds});
  UnderwaterPlayerState.initial()
      : this(playerHealth: PlayerHealth(health: 3), breathingSeconds: 10);

  UnderwaterPlayerState copyWith(
      {PlayerHealth? playerHealth, int? breathingSeconds}) {
    return UnderwaterPlayerState(
        playerHealth: playerHealth ?? this.playerHealth,
        breathingSeconds: breathingSeconds ?? this.breathingSeconds);
  }

  @override
  List<Object> get props => [playerHealth, breathingSeconds];
}
