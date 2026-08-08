import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isMine,
    required this.timeLabel,
    this.isGift = false,
  });

  final String id;
  final String text;
  final bool isMine;
  final String timeLabel;
  final bool isGift;

  @override
  List<Object?> get props => [id, text, isMine, timeLabel, isGift];
}

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatStarted extends ChatEvent {
  const ChatStarted({
    this.initialCompliment,
    this.roseSent = false,
  });

  final String? initialCompliment;
  final bool roseSent;

  @override
  List<Object?> get props => [initialCompliment, roseSent];
}

class ChatTextChanged extends ChatEvent {
  const ChatTextChanged(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

class ChatMessageSent extends ChatEvent {
  const ChatMessageSent();
}

class ChatState extends Equatable {
  const ChatState({
    this.messages = const [],
    this.draft = '',
    this.sending = false,
  });

  final List<ChatMessage> messages;
  final String draft;
  final bool sending;

  bool get canSend => draft.trim().isNotEmpty && !sending;

  ChatState copyWith({
    List<ChatMessage>? messages,
    String? draft,
    bool? sending,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      draft: draft ?? this.draft,
      sending: sending ?? this.sending,
    );
  }

  @override
  List<Object?> get props => [messages, draft, sending];
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<ChatStarted>(_onStarted);
    on<ChatTextChanged>((e, emit) => emit(state.copyWith(draft: e.text)));
    on<ChatMessageSent>(_onSend);
  }

  void _onStarted(ChatStarted event, Emitter<ChatState> emit) {
    final messages = <ChatMessage>[];
    if (event.initialCompliment != null &&
        event.initialCompliment!.trim().isNotEmpty) {
      messages.add(
        ChatMessage(
          id: 'c1',
          text: event.initialCompliment!.trim(),
          isMine: true,
          timeLabel: _nowLabel(),
        ),
      );
    }
    if (event.roseSent) {
      messages.add(
        const ChatMessage(
          id: 'rose',
          text: 'Rose',
          isMine: true,
          timeLabel: '',
          isGift: true,
        ),
      );
    }
    emit(ChatState(messages: messages));
  }

  Future<void> _onSend(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    final text = state.draft.trim();
    if (text.isEmpty) return;
    emit(state.copyWith(sending: true));
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final next = List<ChatMessage>.from(state.messages)
      ..add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          isMine: true,
          timeLabel: _nowLabel(),
        ),
      );
    emit(ChatState(messages: next, draft: '', sending: false));
  }

  String _nowLabel() {
    final now = DateTime.now();
    final h = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final m = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }
}
