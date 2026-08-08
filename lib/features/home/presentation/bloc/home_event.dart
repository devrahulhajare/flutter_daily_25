import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeRefreshed extends HomeEvent {
  const HomeRefreshed();
}

class HomeRetried extends HomeEvent {
  const HomeRetried();
}

class HomePageChanged extends HomeEvent {
  const HomePageChanged(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class HomeProfileSwiped extends HomeEvent {
  const HomeProfileSwiped({required this.liked});

  final bool liked;

  @override
  List<Object?> get props => [liked];
}

class HomeSwipeUndone extends HomeEvent {
  const HomeSwipeUndone();
}

class HomeUsersUpdated extends HomeEvent {
  const HomeUsersUpdated(this.users);

  final List<UserEntity> users;

  @override
  List<Object?> get props => [users];
}
