import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DateOpportunity extends Equatable {
  const DateOpportunity({
    required this.id,
    required this.venue,
    required this.distance,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
    required this.match,
    required this.seats,
    required this.pay,
    required this.host,
    required this.meta,
    required this.slot,
  });

  final String id;
  final String venue;
  final String distance;
  final String title;
  final String subtitle;
  final String time;
  final String type;
  final int match;
  final String seats;
  final String pay;
  final String host;
  final String meta;
  final String slot;

  @override
  List<Object?> get props => [id, slot, title, host];
}

abstract class DateEvent extends Equatable {
  const DateEvent();

  @override
  List<Object?> get props => [];
}

class DateStarted extends DateEvent {
  const DateStarted();
}

class DateSlotChanged extends DateEvent {
  const DateSlotChanged(this.slot);

  final String slot;

  @override
  List<Object?> get props => [slot];
}

class DateSkipped extends DateEvent {
  const DateSkipped();
}

class DateRequested extends DateEvent {
  const DateRequested();
}

class DateFeedbackCleared extends DateEvent {
  const DateFeedbackCleared();
}

class DateState extends Equatable {
  const DateState({
    this.slot = 'Today',
    this.index = 0,
    this.dates = const [],
    this.feedback,
    this.requesting = false,
  });

  final String slot;
  final int index;
  final List<DateOpportunity> dates;
  final String? feedback;
  final bool requesting;

  List<DateOpportunity> get filtered =>
      dates.where((d) => d.slot == slot).toList();

  DateOpportunity? get current {
    final list = filtered;
    if (list.isEmpty) return null;
    return list[index % list.length];
  }

  DateState copyWith({
    String? slot,
    int? index,
    List<DateOpportunity>? dates,
    String? feedback,
    bool clearFeedback = false,
    bool? requesting,
  }) {
    return DateState(
      slot: slot ?? this.slot,
      index: index ?? this.index,
      dates: dates ?? this.dates,
      feedback: clearFeedback ? null : (feedback ?? this.feedback),
      requesting: requesting ?? this.requesting,
    );
  }

  @override
  List<Object?> get props => [slot, index, dates, feedback, requesting];
}

class DateBloc extends Bloc<DateEvent, DateState> {
  DateBloc() : super(const DateState()) {
    on<DateStarted>(_onStarted);
    on<DateSlotChanged>((e, emit) {
      emit(state.copyWith(slot: e.slot, index: 0, clearFeedback: true));
    });
    on<DateSkipped>((_, emit) {
      final list = state.filtered;
      if (list.isEmpty) return;
      emit(
        state.copyWith(
          index: (state.index + 1) % list.length,
          feedback: 'Skipped',
        ),
      );
    });
    on<DateRequested>(_onRequest);
    on<DateFeedbackCleared>((_, emit) {
      emit(state.copyWith(clearFeedback: true));
    });
  }

  void _onStarted(DateStarted event, Emitter<DateState> emit) {
    emit(
      state.copyWith(
        dates: const [
          DateOpportunity(
            id: '1',
            venue: 'Olive Bar, Mahalaxmi',
            distance: '3.4 km away',
            title: 'Pasta & Honest Chats',
            subtitle: 'Foodie looking for a dinner buddy 🍝',
            time: '8:30 PM',
            type: 'Dinner',
            match: 88,
            seats: 'Just 1',
            pay: "I'll pay",
            host: 'Ananya, 25',
            meta: 'she/her · Foodie',
            slot: 'Today',
          ),
          DateOpportunity(
            id: '2',
            venue: 'Blue Tokai, Khar',
            distance: '2.1 km away',
            title: 'Coffee & Soft Starts',
            subtitle: 'Looking for calm conversation ☕',
            time: '5:00 PM',
            type: 'Coffee',
            match: 91,
            seats: 'Just 1',
            pay: 'Split',
            host: 'Meera, 24',
            meta: 'she/her · Reader',
            slot: 'Today',
          ),
          DateOpportunity(
            id: '3',
            venue: 'Social, Lower Parel',
            distance: '4.8 km away',
            title: 'Brunch & Book Recs',
            subtitle: 'Swap favorites over eggs 🍳',
            time: '11:30 AM',
            type: 'Brunch',
            match: 85,
            seats: 'Just 1',
            pay: 'Split',
            host: 'Riya, 26',
            meta: 'she/her · Bookworm',
            slot: 'Tomorrow',
          ),
          DateOpportunity(
            id: '4',
            venue: 'Cubbon Park',
            distance: '6.2 km away',
            title: 'Sunset Walk',
            subtitle: 'Golden hour company only 🌅',
            time: '6:00 PM',
            type: 'Walk',
            match: 90,
            seats: 'Just 1',
            pay: "I'll pay",
            host: 'Kabir, 28',
            meta: 'he/him · Explorer',
            slot: 'Weekend',
          ),
        ],
      ),
    );
  }

  Future<void> _onRequest(
    DateRequested event,
    Emitter<DateState> emit,
  ) async {
    final current = state.current;
    if (current == null) return;
    emit(state.copyWith(requesting: true));
    await Future<void>.delayed(const Duration(milliseconds: 500));
    emit(
      state.copyWith(
        requesting: false,
        feedback: 'Date requested with ${current.host.split(',').first}',
      ),
    );
  }
}
