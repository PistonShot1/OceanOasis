part of 'player_inventory_bloc.dart';

abstract class PlayerInventoryEvent extends Equatable {
  const PlayerInventoryEvent();
}

class WeaponEquipped extends PlayerInventoryEvent {
  final ToolType tool;

  const WeaponEquipped(this.tool);

  @override
  List<Object?> get props => [tool];
}

class NextWeaponEquipped extends PlayerInventoryEvent {
  const NextWeaponEquipped();

  @override
  List<Object?> get props => [];
}
