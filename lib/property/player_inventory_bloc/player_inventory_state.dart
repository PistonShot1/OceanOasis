part of 'player_inventory_bloc.dart';

enum ToolType { rubbishpicker, magnet, dropper }

class PlayerInventoryState extends Equatable {
  final ToolType tool;

  const PlayerInventoryState({
    required this.tool,
  });

  const PlayerInventoryState.initial() : this(tool: ToolType.rubbishpicker);

  PlayerInventoryState copyWith({
    ToolType? tool,
  }) {
    return PlayerInventoryState(tool: tool ?? this.tool);
  }

  @override
  List<Object?> get props => [tool];
}
