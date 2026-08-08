import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_users_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._getUsers) : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeRefreshed>(_onRefreshed);
    on<HomeRetried>(_onRetried);
    on<HomePageChanged>(_onPageChanged);
    on<HomeProfileSwiped>(_onProfileSwiped);
    on<HomeSwipeUndone>(_onSwipeUndone);
  }

  final GetUsersUseCase _getUsers;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading, clearError: true));
    await _loadUsers(emit);
  }

  Future<void> _onRefreshed(
    HomeRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true, clearError: true));
    await _loadUsers(emit, keepExistingOnError: true);
  }

  Future<void> _onRetried(HomeRetried event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading, clearError: true));
    await _loadUsers(emit);
  }

  void _onPageChanged(HomePageChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }

  void _onProfileSwiped(HomeProfileSwiped event, Emitter<HomeState> emit) {
    if (state.users.isEmpty) return;

    final index = state.currentIndex.clamp(0, state.users.length - 1);
    final swiped = state.users[index];
    final remaining = List.of(state.users)..removeAt(index);
    final nextIndex = remaining.isEmpty
        ? 0
        : index.clamp(0, remaining.length - 1);

    emit(
      state.copyWith(
        users: remaining,
        currentIndex: nextIndex,
        lastSwipedUser: swiped,
        lastSwipeLiked: event.liked,
      ),
    );
  }

  void _onSwipeUndone(HomeSwipeUndone event, Emitter<HomeState> emit) {
    final last = state.lastSwipedUser;
    if (last == null) return;

    final restored = List.of(state.users)..insert(state.currentIndex, last);
    emit(
      state.copyWith(
        users: restored,
        clearLastSwipe: true,
      ),
    );
  }

  Future<void> _loadUsers(
    Emitter<HomeState> emit, {
    bool keepExistingOnError = false,
  }) async {
    try {
      final users = await _getUsers();
      emit(
        state.copyWith(
          status: HomeStatus.success,
          users: users,
          currentIndex: 0,
          isRefreshing: false,
          clearError: true,
          clearLastSwipe: true,
        ),
      );
    } catch (e) {
      if (keepExistingOnError && state.users.isNotEmpty) {
        emit(
          state.copyWith(
            status: HomeStatus.success,
            isRefreshing: false,
            errorMessage: e.toString(),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            isRefreshing: false,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }
}
