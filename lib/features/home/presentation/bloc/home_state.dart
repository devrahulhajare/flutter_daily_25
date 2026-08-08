import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.users = const [],
    this.currentIndex = 0,
    this.isRefreshing = false,
    this.errorMessage,
    this.lastSwipedUser,
    this.lastSwipeLiked,
  });

  final HomeStatus status;
  final List<UserEntity> users;
  final int currentIndex;
  final bool isRefreshing;
  final String? errorMessage;
  final UserEntity? lastSwipedUser;
  final bool? lastSwipeLiked;

  UserEntity? get currentUser =>
      users.isEmpty ? null : users[currentIndex.clamp(0, users.length - 1)];

  UserEntity? get nextUser {
    if (users.length < 2) return null;
    final next = currentIndex + 1;
    if (next >= users.length) return null;
    return users[next];
  }

  bool get canUndo => lastSwipedUser != null;

  HomeState copyWith({
    HomeStatus? status,
    List<UserEntity>? users,
    int? currentIndex,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
    UserEntity? lastSwipedUser,
    bool? lastSwipeLiked,
    bool clearLastSwipe = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      users: users ?? this.users,
      currentIndex: currentIndex ?? this.currentIndex,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastSwipedUser:
          clearLastSwipe ? null : (lastSwipedUser ?? this.lastSwipedUser),
      lastSwipeLiked:
          clearLastSwipe ? null : (lastSwipeLiked ?? this.lastSwipeLiked),
    );
  }

  @override
  List<Object?> get props => [
        status,
        users,
        currentIndex,
        isRefreshing,
        errorMessage,
        lastSwipedUser,
        lastSwipeLiked,
      ];
}
