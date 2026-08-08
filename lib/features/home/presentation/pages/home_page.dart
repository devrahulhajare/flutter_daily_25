import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../compliment/presentation/widgets/compliment_sheet.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/profile_card.dart';
import '../widgets/profile_detail_content.dart';
import '../widgets/swipeable_profile_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onOpenDrawer, this.onOpenNotifications});

  final VoidCallback? onOpenDrawer;
  final VoidCallback? onOpenNotifications;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _pageController;
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
    _pageController.addListener(() {
      if (!_pageController.hasClients) return;
      final next = _pageController.page ?? 0;
      if ((next - _page).abs() < 0.004) return;
      setState(() => _page = next);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<HomeBloc>();
    // Subscribe before dispatching so we don't miss the settled state.
    final settled = bloc.stream.firstWhere((s) => !s.isRefreshing);
    bloc.add(const HomeRefreshed());
    await settled;
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return const _FilterSheet();
      },
    );
  }

  void _onSwiped(SwipeDirection direction, UserEntity user) {
    final liked = direction == SwipeDirection.right;
    context.read<HomeBloc>().add(HomeProfileSwiped(liked: liked));
    _showSnack(
      liked ? 'Liked ${user.displayName}' : 'Passed on ${user.displayName}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeAppBar(
          onMenu: widget.onOpenDrawer,
          onBoost: () => _showSnack('Boost coming soon'),
          onFilter: _showFilterSheet,
          onNotifications: widget.onOpenNotifications,
        ),
        Expanded(
          child: BlocConsumer<HomeBloc, HomeState>(
            listenWhen: (prev, curr) =>
                prev.errorMessage != curr.errorMessage &&
                curr.errorMessage != null &&
                curr.status == HomeStatus.success,
            listener: (context, state) {
              if (state.errorMessage != null) {
                _showSnack('Couldn’t refresh. Showing previous profiles.');
              }
            },
            builder: (context, state) {
              switch (state.status) {
                case HomeStatus.initial:
                case HomeStatus.loading:
                  return const LoadingView();
                case HomeStatus.failure:
                  return ErrorView(
                    message:
                        state.errorMessage ??
                        'Unable to load profiles right now.',
                    onRetry: () =>
                        context.read<HomeBloc>().add(const HomeRetried()),
                  );
                case HomeStatus.success:
                  if (state.users.isEmpty) {
                    return _EmptyDeck(onRefresh: _onRefresh);
                  }
                  return RefreshIndicator(
                    color: AppColors.primary,
                    backgroundColor: Colors.white,
                    displacement: 48,
                    strokeWidth: 2.5,
                    // Nested CustomScrollView inside the card is depth > 0.
                    // Only allow pull-to-refresh when that scroll is at the top.
                    notificationPredicate: (notification) {
                      return notification.metrics.axis == Axis.vertical &&
                          notification.metrics.pixels <= 0;
                    },
                    onRefresh: _onRefresh,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 2, 12, 10),
                      child: ColoredBox(
                        color: AppColors.surfaceCream,
                        child: _ProfileFeed(
                          state: state,
                          pageController: _pageController,
                          page: _page,
                          onSwiped: _onSwiped,
                          onUndo: () {
                            if (state.canUndo) {
                              context.read<HomeBloc>().add(
                                const HomeSwipeUndone(),
                              );
                            } else {
                              context.read<HomeBloc>().add(
                                const HomeRefreshed(),
                              );
                            }
                          },
                          onMore: (name) => _showMoreSheet(name),
                          onRose: (user) =>
                              showComplimentSheet(context: context, user: user),
                          onComplimentPrompt: (user) => showComplimentSheet(
                            context: context,
                            user: user,
                            targetLabel: 'Prompt',
                          ),
                        ),
                      ),
                    ),
                  );
              }
            },
          ),
        ),
      ],
    );
  }

  void _showMoreSheet(String name) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title: const Text('Report profile'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.block_outlined),
                  title: const Text('Block'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.share_outlined),
                  title: const Text('Share profile'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileFeed extends StatelessWidget {
  const _ProfileFeed({
    required this.state,
    required this.pageController,
    required this.page,
    required this.onSwiped,
    required this.onUndo,
    required this.onMore,
    required this.onRose,
    this.onComplimentPrompt,
  });

  final HomeState state;
  final PageController pageController;
  final double page;
  final void Function(SwipeDirection direction, UserEntity user) onSwiped;
  final VoidCallback onUndo;
  final void Function(String name) onMore;
  final void Function(UserEntity user) onRose;
  final void Function(UserEntity user)? onComplimentPrompt;

  @override
  Widget build(BuildContext context) {
    // Keep PageController in sync when deck changes (swipe remove / undo / refresh).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!pageController.hasClients || state.users.isEmpty) return;
      final pageValue = pageController.page;
      if (pageValue == null) return;
      // Don't interrupt an in-progress page animation.
      if ((pageValue - pageValue.round()).abs() > 0.02) return;
      final target = state.currentIndex.clamp(0, state.users.length - 1);
      if (pageValue.round() != target) {
        pageController.jumpToPage(target);
      }
    });

    return PageView.builder(
      controller: pageController,
      scrollDirection: Axis.vertical,
      allowImplicitScrolling: true,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      itemCount: state.users.length,
      onPageChanged: (index) {
        context.read<HomeBloc>().add(HomePageChanged(index));
      },
      itemBuilder: (context, index) {
        final user = state.users[index];
        final distance = (page - index).abs();
        final t = Curves.easeOutCubic.transform(distance.clamp(0.0, 1.0));
        final isTopCard = distance < 0.5;

        final upcoming = <UserEntity>[
          if (index + 2 < state.users.length) state.users[index + 2],
        ];

        return Opacity(
          opacity: (1 - t * 0.2).clamp(0.75, 1.0),
          child: _DeckProfilePage(
            key: ValueKey(user.id),
            user: user,
            upcoming: upcoming,
            isTopCard: isTopCard,
            onSwiped: (direction) => onSwiped(direction, user),
            onUndo: onUndo,
            onMore: () => onMore(user.displayName),
            onRose: () => onRose(user),
            onSectionRose: () => (onComplimentPrompt ?? onRose)(user),
          ),
        );
      },
    );
  }
}

/// Card stack like the screenshot: front card on top, next cards tucked
/// underneath (offset down), About panel scrolls below the stack.
class _DeckProfilePage extends StatefulWidget {
  const _DeckProfilePage({
    super.key,
    required this.user,
    required this.upcoming,
    required this.isTopCard,
    required this.onSwiped,
    required this.onUndo,
    required this.onMore,
    required this.onRose,
    this.onSectionRose,
  });

  final UserEntity user;
  final List<UserEntity> upcoming;
  final bool isTopCard;
  final void Function(SwipeDirection direction) onSwiped;
  final VoidCallback onUndo;
  final VoidCallback onMore;
  final VoidCallback onRose;
  final VoidCallback? onSectionRose;

  @override
  State<_DeckProfilePage> createState() => _DeckProfilePageState();
}

class _DeckProfilePageState extends State<_DeckProfilePage> {
  late final ScrollController _scrollController;
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final next = _scrollController.offset;
    if ((next - _offset).abs() < 0.5) return;
    setState(() => _offset = next);
  }

  bool get _detailsOpen => _offset > 16;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight = constraints.maxHeight;
        // Front + up to 2 behind = 3-card stack. Keep peek modest.
        final peekT = Curves.easeOutCubic.transform(
          (_offset / 80).clamp(0.0, 1.0),
        );
        final peekStep = 14.0 + 72.0 * peekT;
        final behindCount = widget.upcoming.length.clamp(0, 2);
        final peekExtent = peekStep * behindCount;
        final stackHeight = cardHeight + peekExtent;

        return CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: stackHeight,
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    for (var i = widget.upcoming.length - 1; i >= 0; i--)
                      _UpcomingCardLayer(
                        user: widget.upcoming[i],
                        depth: i + 1,
                        cardHeight: cardHeight,
                        peekStep: peekStep,
                      ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: cardHeight,
                      child: SwipeableProfileCard(
                        enabled: widget.isTopCard && !_detailsOpen,
                        onSwiped: widget.onSwiped,
                        child: ProfileCard(
                          user: widget.user,
                          enableDetails: false,
                          onUndo: widget.onUndo,
                          onMore: widget.onMore,
                          onRose: widget.onRose,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.surfaceCream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  child: ProfileDetailContent(
                    user: widget.user,
                    onRose: widget.onSectionRose ?? widget.onRose,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _UpcomingCardLayer extends StatelessWidget {
  const _UpcomingCardLayer({
    required this.user,
    required this.depth,
    required this.cardHeight,
    required this.peekStep,
  });

  final UserEntity user;
  final int depth;
  final double cardHeight;
  final double peekStep;

  @override
  Widget build(BuildContext context) {
    final dy = peekStep * depth;
    final inset = 5.0 * depth;

    return Positioned(
      top: dy,
      left: inset,
      right: inset,
      height: cardHeight,
      child: IgnorePointer(
        child: Transform.scale(
          scale: (1.0 - 0.03 * depth).clamp(0.94, 1.0),
          alignment: Alignment.topCenter,
          child: ProfileCard(user: user, enableDetails: false),
        ),
      ),
    );
  }
}

class _EmptyDeck extends StatelessWidget {
  const _EmptyDeck({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.55,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'You’re all caught up',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Pull to refresh for more profiles',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Filters',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'UI only — refine who appears in your Daily 25.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            const _FilterRow(label: 'Age', value: '21 – 35'),
            const _FilterRow(label: 'Distance', value: 'Within 25 km'),
            const _FilterRow(
              label: 'Looking for',
              value: 'Serious relationship',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
