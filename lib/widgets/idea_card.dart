import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pgagi_assign/constants/app_constants.dart';
import 'package:pgagi_assign/models/startup_idea.dart';
import 'package:pgagi_assign/widgets/common_widgets.dart';
import 'package:share_plus/share_plus.dart';

class IdeaCard extends StatefulWidget {
  final StartupIdea idea;
  final bool hasVoted;
  final VoidCallback onVote;
  final bool isExpanded;
  final VoidCallback? onToggleExpanded;

  const IdeaCard({
    super.key,
    required this.idea,
    required this.hasVoted,
    required this.onVote,
    this.isExpanded = false,
    this.onToggleExpanded,
  });

  @override
  State<IdeaCard> createState() => _IdeaCardState();
}

class _IdeaCardState extends State<IdeaCard> {
  bool _isVoting = false;

  Color _getRatingColor(int rating) {
    if (rating >= 90) return AppColors.success;
    if (rating >= 80) return AppColors.primary;
    if (rating >= 70) return AppColors.warning;
    return AppColors.error;
  }

  String _getRatingLabel(int rating) {
    if (rating >= 90) return "Exceptional";
    if (rating >= 80) return "Excellent";
    if (rating >= 70) return "Good";
    if (rating >= 60) return "Average";
    return "Needs Work";
  }

  void _handleVote() async {
    if (_isVoting || widget.hasVoted) return;

    setState(() {
      _isVoting = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    widget.onVote();

    setState(() {
      _isVoting = false;
    });

    if (widget.hasVoted) {
      Fluttertoast.showToast(
        msg: "You've already voted for this idea!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Vote recorded! 🎉",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _shareIdea() {
    final text = '''
Check out this startup idea: ${widget.idea.name}

"${widget.idea.tagline}"

${widget.idea.description}

AI Rating: ${widget.idea.aiRating}/100
Votes: ${widget.idea.votes}

Shared from StartupHub
''';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratingColor = _getRatingColor(widget.idea.aiRating);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.mediumSpacing,
        vertical: AppConstants.smallSpacing,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and rating
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.idea.name,
                        style: AppTextStyles.heading3.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.idea.tagline,
                        style: AppTextStyles.subtitle2.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppConstants.mediumSpacing),
                // AI Rating Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ratingColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.largeRadius,
                    ),
                    border: Border.all(color: ratingColor, width: 1),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${widget.idea.aiRating}',
                        style: AppTextStyles.subtitle1.copyWith(
                          color: ratingColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'AI Score',
                        style: AppTextStyles.caption.copyWith(
                          color: ratingColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.mediumSpacing),

            // Description
            AnimatedCrossFade(
              firstChild: Text(
                widget.idea.description,
                style: AppTextStyles.body1.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              secondChild: Text(
                widget.idea.description,
                style: AppTextStyles.body1.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              crossFadeState:
                  widget.isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              duration: AppConstants.shortAnimationDuration,
            ),

            if (widget.idea.description.length > 150) ...[
              const SizedBox(height: AppConstants.smallSpacing),
              GestureDetector(
                onTap: widget.onToggleExpanded,
                child: Text(
                  widget.isExpanded ? 'Show less' : 'Read more',
                  style: AppTextStyles.body2.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],

            const SizedBox(height: AppConstants.mediumSpacing),

            // Rating Category and Date
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ratingColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.smallRadius,
                    ),
                  ),
                  child: Text(
                    _getRatingLabel(widget.idea.aiRating),
                    style: AppTextStyles.caption.copyWith(
                      color: ratingColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(widget.idea.createdAt),
                  style: AppTextStyles.caption.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.mediumSpacing),

            // Actions Row
            Row(
              children: [
                // Vote Button
                AnimatedContainer(
                  duration: AppConstants.shortAnimationDuration,
                  child: CustomButton(
                    width: 120.w,
                    text: widget.hasVoted ? 'Voted' : 'Upvote',
                    icon: Icon(
                      widget.hasVoted
                          ? Icons.thumb_up
                          : Icons.thumb_up_outlined,
                      size: 18,
                      color: widget.hasVoted ? AppColors.success : null,
                    ),
                    onPressed: widget.hasVoted ? null : _handleVote,
                    isLoading: _isVoting,
                    backgroundColor:
                        widget.hasVoted
                            ? AppColors.success.withOpacity(0.1)
                            : null,
                    textColor: widget.hasVoted ? AppColors.success : null,
                    height: 36.w,
                  ),
                ),

                const SizedBox(width: AppConstants.smallSpacing),

                // Vote Count
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(
                      AppConstants.mediumRadius,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.thumb_up,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.idea.votes}',
                        style: AppTextStyles.subtitle2.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Share Button
                IconButton(
                  onPressed: _shareIdea,
                  icon: const Icon(Icons.share_outlined),
                  tooltip: 'Share idea',
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
