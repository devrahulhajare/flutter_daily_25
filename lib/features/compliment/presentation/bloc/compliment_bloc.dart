import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── Events ──────────────────────────────────────────────────────────

abstract class ComplimentEvent extends Equatable {
  const ComplimentEvent();

  @override
  List<Object?> get props => [];
}

class ComplimentTextChanged extends ComplimentEvent {
  const ComplimentTextChanged(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

class ComplimentRoseToggled extends ComplimentEvent {
  const ComplimentRoseToggled();
}

class ComplimentLikedToggled extends ComplimentEvent {
  const ComplimentLikedToggled();
}

class ComplimentIdeaApplied extends ComplimentEvent {
  const ComplimentIdeaApplied(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

class ComplimentSubmitted extends ComplimentEvent {
  const ComplimentSubmitted();
}

class ComplimentReset extends ComplimentEvent {
  const ComplimentReset();
}

// ── State ───────────────────────────────────────────────────────────

enum ComplimentStatus { editing, sending, success }

class ComplimentState extends Equatable {
  const ComplimentState({
    this.text = '',
    this.roseSelected = true,
    this.liked = false,
    this.status = ComplimentStatus.editing,
    this.maxLength = 140,
  });

  final String text;
  final bool roseSelected;
  final bool liked;
  final ComplimentStatus status;
  final int maxLength;

  bool get canSend => text.trim().isNotEmpty && status != ComplimentStatus.sending;

  ComplimentState copyWith({
    String? text,
    bool? roseSelected,
    bool? liked,
    ComplimentStatus? status,
  }) {
    return ComplimentState(
      text: text ?? this.text,
      roseSelected: roseSelected ?? this.roseSelected,
      liked: liked ?? this.liked,
      status: status ?? this.status,
      maxLength: maxLength,
    );
  }

  @override
  List<Object?> get props => [text, roseSelected, liked, status, maxLength];
}

// ── Bloc ────────────────────────────────────────────────────────────

class ComplimentBloc extends Bloc<ComplimentEvent, ComplimentState> {
  ComplimentBloc() : super(const ComplimentState()) {
    on<ComplimentTextChanged>((e, emit) {
      final clipped = e.text.length > state.maxLength
          ? e.text.substring(0, state.maxLength)
          : e.text;
      emit(state.copyWith(text: clipped, status: ComplimentStatus.editing));
    });
    on<ComplimentRoseToggled>((_, emit) {
      emit(state.copyWith(roseSelected: !state.roseSelected));
    });
    on<ComplimentLikedToggled>((_, emit) {
      emit(state.copyWith(liked: !state.liked));
    });
    on<ComplimentIdeaApplied>((e, emit) {
      emit(state.copyWith(text: e.text, status: ComplimentStatus.editing));
    });
    on<ComplimentSubmitted>(_onSubmit);
    on<ComplimentReset>((_, emit) => emit(const ComplimentState()));
  }

  Future<void> _onSubmit(
    ComplimentSubmitted event,
    Emitter<ComplimentState> emit,
  ) async {
    if (!state.canSend) return;
    emit(state.copyWith(status: ComplimentStatus.sending));
    await Future<void>.delayed(const Duration(milliseconds: 450));
    emit(state.copyWith(status: ComplimentStatus.success));
  }
}
