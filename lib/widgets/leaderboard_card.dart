import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pgagi_assign/constants/app_constants.dart';
import 'package:pgagi_assign/models/startup_idea.dart';

class LeaderboardCard extends StatelessWidget {
  final StartupIdea idea;
  final int rank;
  final VoidCallback? onTap;

  const LeaderboardCard({
    super.key,
    required this.idea,
    required this.rank,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = _getRankGradient(rank);
    final rankIcon = _getRankIcon(rank);
    final rankEmoji = _getRankEmoji(rank);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.mediumSpacing,
          vertical: AppConstants.smallSpacing,
        ),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppConstants.largeRadius),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.mediumSpacing),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.95),
            borderRadius: BorderRadius.circular(AppConstants.largeRadius),
            border: Border.all(
              color: gradient.colors.first.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              // Rank Badge
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: gradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(rankEmoji, style: const TextStyle(fontSize: 20)),
                    Text(
                      '#$rank',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppConstants.mediumSpacing),

              // Idea Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            idea.name,
                            style: AppTextStyles.subtitle1.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (rank <= 3)
                          Icon(
                            rankIcon,
                            color: gradient.colors.first,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      idea.tagline,
                      style: AppTextStyles.body2.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppConstants.smallSpacing),
                    Row(
                      children: [
                        // Votes
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppConstants.smallRadius,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.thumb_up,
                                size: 14,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${idea.votes}',
                                style: AppTextStyles.caption.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppConstants.smallSpacing),
                        // AI Rating
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getRatingColor(
                              idea.aiRating,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppConstants.smallRadius,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.stars,
                                size: 14,
                                color: _getRatingColor(idea.aiRating),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${idea.aiRating}',
                                style: AppTextStyles.caption.copyWith(
                                  color: _getRatingColor(idea.aiRating),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: (400 + (rank * 100)).ms).slideX(begin: 0.3);
  }

  LinearGradient _getRankGradient(int rank) {
    switch (rank) {
      case 1:
        return AppColors.goldGradient;
      case 2:
        return AppColors.silverGradient;
      case 3:
        return AppColors.bronzeGradient;
      default:
        return AppColors.primaryGradient;
    }
  }

  IconData _getRankIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.military_tech;
      case 3:
        return Icons.workspace_premium;
      default:
        return Icons.star;
    }
  }

  String _getRankEmoji(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '⭐';
    }
  }

  Color _getRatingColor(int rating) {
    if (rating >= 90) return AppColors.success;
    if (rating >= 80) return AppColors.primary;
    if (rating >= 70) return AppColors.warning;
    return AppColors.error;
  }
}
