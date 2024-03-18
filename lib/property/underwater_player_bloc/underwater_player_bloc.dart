import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oceanoasis/components/maps/underwater/playerhealth.dart';

part 'underwater_player_event.dart';
part 'underwater_player_state.dart';

class UnderwaterPlayerBloc
    extends Bloc<UnderwaterPlayerEvent, UnderwaterPlayerState> {
  UnderwaterPlayerBloc() : super(UnderwaterPlayerState.initial()) {
    on<PlayerDamage>((event, emit) {
      emit(state.copyWith(
          playerHealth: PlayerHealth(health: state.playerHealth.health - 1)));
    });
    on<LosingBreath>((event, emit) {
      emit(state.copyWith(
        breathingSeconds: state.breathingSeconds - 1
      ));
    });
  }
}
