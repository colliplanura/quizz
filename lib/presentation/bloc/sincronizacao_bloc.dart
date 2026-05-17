import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../services/sync_service.dart';
import '../../services/logging_service.dart';

// Events
abstract class SincronizacaoEvent extends Equatable {
  const SincronizacaoEvent();

  @override
  List<Object?> get props => [];
}

class SincronizacaoSolicitada extends SincronizacaoEvent {
  const SincronizacaoSolicitada({this.forcarSync = false});

  final bool forcarSync;

  @override
  List<Object?> get props => [forcarSync];
}

// States
abstract class SincronizacaoState extends Equatable {
  const SincronizacaoState();

  @override
  List<Object?> get props => [];
}

class SincronizacaoOcioso extends SincronizacaoState {
  const SincronizacaoOcioso();
}

class SincronizacaoEmAndamento extends SincronizacaoState {
  const SincronizacaoEmAndamento();
}

class SincronizacaoConcluida extends SincronizacaoState {
  const SincronizacaoConcluida();
}

class SincronizacaoFalhou extends SincronizacaoState {
  const SincronizacaoFalhou();
}

// BLoC
class SincronizacaoBloc extends Bloc<SincronizacaoEvent, SincronizacaoState> {
  SincronizacaoBloc(this._syncService) : super(const SincronizacaoOcioso()) {
    on<SincronizacaoSolicitada>(_onSolicitada);
  }

  final SyncService _syncService;

  Future<void> _onSolicitada(
    SincronizacaoSolicitada event,
    Emitter<SincronizacaoState> emit,
  ) async {
    // Sync é silencioso — não emite estado de loading visível na UI principal
    LoggingService.debug('Sync solicitado', contexto: 'SincronizacaoBloc');
    _syncService.sincronizarEmBackground(forcarSync: event.forcarSync);
    // Estado permanece Ocioso para não bloquear UI
  }
}
