import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pgagi_assign/blocs/startup_bloc.dart';
import 'package:pgagi_assign/blocs/startup_event.dart';
import 'package:pgagi_assign/blocs/startup_state.dart';
import 'package:pgagi_assign/constants/app_constants.dart';
import 'package:pgagi_assign/models/startup_idea.dart';
import 'package:pgagi_assign/utils/app_navigation.dart';
import 'package:pgagi_assign/widgets/common_widgets.dart';
import 'package:pgagi_assign/widgets/leaderboard_card.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late Animation<double> _headerScaleAnimation;

  bool _sortByVotes = true; 

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _headerScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _headerAnimationController.forward();
    context.read<StartupBloc>().add(LoadIdeas());
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    super.dispose();
  }

  List<StartupIdea> _getTopIdeas(List<StartupIdea> ideas) {
    final sortedIdeas = List<StartupIdea>.from(ideas);
    if (_sortByVotes) {
      sortedIdeas.sort((a, b) => b.votes.compareTo(a.votes));
    } else {
      sortedIdeas.sort((a, b) => b.aiRating.compareTo(a.aiRating));
    }
    return sortedIdeas.take(10).toList(); // Show top 10
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartupBloc, StartupState>(
      builder: (context, state) {
        if (state is StartupLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is IdeasLoaded) {
          if (state.ideas.isEmpty) {
            return EmptyState(
              title: 'No Ideas to Rank',
              message: 'Submit some ideas first to see the leaderboard!',
              icon: Icons.emoji_events_outlined,
              onAction: () {
                AppNavigation.goToSubmit();
              },
              actionText: 'Submit First Idea',
            );
          }

          final topIdeas = _getTopIdeas(state.ideas);
          final totalIdeas = state.ideas.length;
          final totalVotes = state.ideas.fold<int>(
            0,
            (sum, idea) => sum + idea.votes,
          );

          return RefreshIndicator(
            onRefresh: () async {
              context.read<StartupBloc>().add(RefreshIdeas());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedBuilder(
                    animation: _headerAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _headerScaleAnimation.value,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(
                            AppConstants.mediumSpacing,
                          ),
                          padding: const EdgeInsets.all(
                            AppConstants.largeSpacing,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.goldGradient,
                            borderRadius: BorderRadius.circular(
                              AppConstants.largeRadius,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.emoji_events,
                                size: 64,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: AppConstants.mediumSpacing,
                              ),
                              Text(
                                '🏆 Top Startup Ideas',
                                style: AppTextStyles.heading2.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppConstants.smallSpacing),
                              Text(
                                'Community favorites ranked by ${_sortByVotes ? 'votes' : 'AI rating'}',
                                style: AppTextStyles.body1.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Stats Row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.mediumSpacing,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Ideas',
                            '$totalIdeas',
                            Icons.lightbulb,
                            AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppConstants.mediumSpacing),
                        Expanded(
                          child: _buildStatCard(
                            'Total Votes',
                            '$totalVotes',
                            Icons.thumb_up,
                            AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ).animate().slideY(delay: 300.ms, begin: 0.3),

                  const SizedBox(height: AppConstants.largeSpacing),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.mediumSpacing,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Rank by:',
                          style: AppTextStyles.subtitle1.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: AppConstants.mediumSpacing),
                        Expanded(
                          child: Row(
                            children: [
                              _buildToggleChip('Votes', _sortByVotes, true),
                              const SizedBox(width: AppConstants.smallSpacing),
                              _buildToggleChip(
                                'AI Rating',
                                !_sortByVotes,
                                false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: AppConstants.mediumSpacing),

                  if (topIdeas.length >= 3)
                    Container(
                      height: 200,
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppConstants.mediumSpacing,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: _buildPodiumCard(topIdeas[1], 2, 150.h),
                          ),
                          Expanded(
                            child: _buildPodiumCard(topIdeas[0], 1, 190.h),
                          ),
                          Expanded(
                            child: _buildPodiumCard(topIdeas[2], 3, 120.h),
                          ),
                        ],
                      ),
                    ).animate().slideY(delay: 500.ms, begin: 0.5),

                  const SizedBox(height: AppConstants.largeSpacing),

                  // Full Leaderboard
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.mediumSpacing,
                    ),
                    child: Text(
                      'Full Leaderboard',
                      style: AppTextStyles.heading3.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms),

                  const SizedBox(height: AppConstants.mediumSpacing),

                  // Leaderboard List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: topIdeas.length,
                    itemBuilder: (context, index) {
                      final idea = topIdeas[index];
                      return LeaderboardCard(
                        idea: idea,
                        rank: index + 1,
                        onTap: () {
                          AppNavigation.goToIdeaDetail(
                            idea.id,
                            idea: idea,
                            rank: index + 1,
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: AppConstants.extraLargeSpacing),
                ],
              ),
            ),
          );
        }

        if (state is StartupError) {
          return EmptyState(
            title: 'Something Went Wrong',
            message: state.message,
            icon: Icons.error_outline,
            onAction: () {
              context.read<StartupBloc>().add(RefreshIdeas());
            },
            actionText: 'Try Again',
          );
        }

        return const EmptyState(
          title: 'Loading Leaderboard',
          message: 'Fetching the best startup ideas...',
          icon: Icons.emoji_events_outlined,
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.mediumSpacing),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppConstants.smallSpacing),
          Text(
            value,
            style: AppTextStyles.heading3.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleChip(String label, bool isSelected, bool isVotes) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _sortByVotes = isVotes;
          });
        },
        child: AnimatedContainer(
          duration: AppConstants.shortAnimationDuration,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.mediumSpacing,
            vertical: AppConstants.smallSpacing,
          ),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(AppConstants.largeRadius),
          ),
          child: Text(
            label,
            style: AppTextStyles.body2.copyWith(
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildPodiumCard(StartupIdea idea, int rank, double height) {
    final gradient =
        rank == 1
            ? AppColors.goldGradient
            : rank == 2
            ? AppColors.silverGradient
            : AppColors.bronzeGradient;

    final emoji =
        rank == 1
            ? '🥇'
            : rank == 2
            ? '🥈'
            : '🥉';

    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.mediumRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.smallSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: AppConstants.smallSpacing),
            Text(
              idea.name,
              style: AppTextStyles.body2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppConstants.smallSpacing),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppConstants.smallRadius),
              ),
              child: Text(
                _sortByVotes ? '${idea.votes} votes' : '${idea.aiRating}/100',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(delay: (rank * 200).ms, duration: 600.ms);
  }

  void _showIdeaDetails(StartupIdea idea, int rank) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.largeRadius),
        ),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            builder: (context, scrollController) {
              return Padding(
                padding: const EdgeInsets.all(AppConstants.mediumSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.mediumSpacing),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(
                            AppConstants.smallSpacing,
                          ),
                          decoration: BoxDecoration(
                            gradient:
                                rank <= 3
                                    ? (rank == 1
                                        ? AppColors.goldGradient
                                        : rank == 2
                                        ? AppColors.silverGradient
                                        : AppColors.bronzeGradient)
                                    : AppColors.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '#$rank',
                            style: AppTextStyles.subtitle1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppConstants.mediumSpacing),
                        Expanded(
                          child: Text(idea.name, style: AppTextStyles.heading2),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.mediumSpacing),
                    Text(
                      idea.tagline,
                      style: AppTextStyles.subtitle1.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: AppConstants.largeSpacing),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description', style: AppTextStyles.subtitle1),
                            const SizedBox(height: AppConstants.smallSpacing),
                            Text(idea.description, style: AppTextStyles.body1),
                            const SizedBox(height: AppConstants.largeSpacing),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDetailStat(
                                    'Votes',
                                    '${idea.votes}',
                                    Icons.thumb_up,
                                    AppColors.primary,
                                  ),
                                ),
                                const SizedBox(
                                  width: AppConstants.mediumSpacing,
                                ),
                                Expanded(
                                  child: _buildDetailStat(
                                    'AI Rating',
                                    '${idea.aiRating}/100',
                                    Icons.stars,
                                    AppColors.warning,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  Widget _buildDetailStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.mediumSpacing),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: AppConstants.smallSpacing),
          Text(
            value,
            style: AppTextStyles.heading3.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
