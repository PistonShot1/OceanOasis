import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'player_inventory_event.dart';
part 'player_inventory_state.dart';

class PlayerInventoryBloc
    extends Bloc<PlayerInventoryEvent, PlayerInventoryState> {
  PlayerInventoryBloc() : super(const PlayerInventoryState.initial()) {
    on<WeaponEquipped>(
      (event, emit) => emit(
        state.copyWith(tool: event.tool),
      ),
    );

    on<NextWeaponEquipped>((event, emit) {
      print('Next weapon was equipped');
      const values = ToolType.values;
      final i = values.indexOf(state.tool);
      if (i == values.length - 1) {
        emit(state.copyWith(tool: ToolType.rubbishpicker));
      } else {
        emit(state.copyWith(tool: values[i + 1]));
      }
    });
  }
}
