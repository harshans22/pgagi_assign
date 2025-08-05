import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pgagi_assign/blocs/startup_bloc.dart';
import 'package:pgagi_assign/blocs/startup_event.dart';
import 'package:pgagi_assign/blocs/startup_state.dart';
import 'package:pgagi_assign/constants/app_constants.dart';
import 'package:pgagi_assign/models/startup_idea.dart';
import 'package:pgagi_assign/utils/app_navigation.dart';
import 'package:pgagi_assign/widgets/common_widgets.dart';
import 'package:share_plus/share_plus.dart';

class IdeaDetailScreen extends StatefulWidget {
  final String ideaId;
  final StartupIdea? idea;
  final int? rank;

  const IdeaDetailScreen({
    super.key,
    required this.ideaId,
    this.idea,
    this.rank,
  });

  @override
  State<IdeaDetailScreen> createState() => _IdeaDetailScreenState();
}

class _IdeaDetailScreenState extends State<IdeaDetailScreen> {
  StartupIdea? _idea;
  bool _hasVoted = false;
  bool _isVoting = false;

  @override
  void initState() {
    super.initState();
    _idea = widget.idea;
    _loadIdeaDetails();
  }

  void _loadIdeaDetails() async {
    if (_idea == null) {
      // Load idea from repository if not provided
      final repository = context.read<StartupBloc>().repository;
      final idea = await repository.getIdeaById(widget.ideaId);
      if (idea != null) {
        setState(() {
          _idea = idea;
        });
      }
    }

    // Check if user has voted
    if (_idea != null) {
      final repository = context.read<StartupBloc>().repository;
      final hasVoted = await repository.hasVoted(_idea!.id);
      setState(() {
        _hasVoted = hasVoted;
      });
    }
  }

  void _handleVote() async {
    if (_isVoting || _hasVoted || _idea == null) return;

    setState(() {
      _isVoting = true;
    });

    context.read<StartupBloc>().add(VoteForIdea(_idea!.id));
  }

  void _shareIdea() {
    if (_idea == null) return;

    final text = '''
Check out this startup idea: ${_idea!.name}

"${_idea!.tagline}"

${_idea!.description}

AI Rating: ${_idea!.aiRating}/100
Votes: ${_idea!.votes}

${widget.rank != null ? 'Ranked #${widget.rank} on StartupHub' : 'Shared from StartupHub'}
''';
    Share.share(text);
  }

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

  LinearGradient? _getRankGradient(int? rank) {
    if (rank == null) return null;
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

  String _getRankEmoji(int? rank) {
    if (rank == null) return '';
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartupBloc, StartupState>(
      listener: (context, state) {
        if (state is VoteSuccess && state.ideaId == widget.ideaId) {
          setState(() {
            _isVoting = false;
            _hasVoted = true;
            if (_idea != null) {
              _idea = _idea!.copyWith(votes: _idea!.votes + 1);
            }
          });

          Fluttertoast.showToast(
            msg: "Vote recorded! 🎉",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        } else if (state is VoteAlreadyCast && state.ideaId == widget.ideaId) {
          setState(() {
            _isVoting = false;
          });

          Fluttertoast.showToast(
            msg: "You've already voted for this idea!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        } else if (state is StartupError) {
          setState(() {
            _isVoting = false;
          });

          Fluttertoast.showToast(
            msg: "Error: ${state.message}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      },
      child: Scaffold(
        body:
            _idea == null
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                  slivers: [
                    // App Bar with Gradient
                    SliverAppBar(
                      expandedHeight: 200.h,
                      pinned: true,
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        onPressed: () => AppNavigation.goBack(),
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                          onPressed: _shareIdea,
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient:
                                widget.rank != null
                                    ? _getRankGradient(widget.rank)
                                    : AppColors.primaryGradient,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.rank != null) ...[
                                Text(
                                  _getRankEmoji(widget.rank),
                                  style: TextStyle(fontSize: 48.sp),
                                ).animate().scale(duration: 600.ms),
                                Text(
                                  'Rank #${widget.rank}',
                                  style: AppTextStyles.heading3.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp,
                                  ),
                                ).animate().fadeIn(delay: 200.ms),
                              ] else ...[
                                Icon(
                                  Icons.lightbulb,
                                  size: 64.sp,
                                  color: Colors.white,
                                ).animate().scale(duration: 600.ms),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Content
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and Tagline
                            Text(
                              _idea!.name,
                              style: AppTextStyles.heading1.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 28.sp,
                              ),
                            ).animate().slideX(delay: 100.ms, begin: -0.3),

                            SizedBox(height: 8.h),

                            Text(
                              _idea!.tagline,
                              style: AppTextStyles.subtitle1.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                                fontSize: 16.sp,
                              ),
                            ).animate().slideX(delay: 200.ms, begin: -0.3),

                            SizedBox(height: 24.h),

                            // Stats Row
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    'AI Rating',
                                    '${_idea!.aiRating}/100',
                                    Icons.stars,
                                    _getRatingColor(_idea!.aiRating),
                                    _getRatingLabel(_idea!.aiRating),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: _buildStatCard(
                                    'Votes',
                                    '${_idea!.votes}',
                                    Icons.thumb_up,
                                    AppColors.primary,
                                    null,
                                  ),
                                ),
                              ],
                            ).animate().slideY(delay: 300.ms, begin: 0.3),

                            SizedBox(height: 24.h),

                            // Description Section
                            Text(
                              'Description',
                              style: AppTextStyles.heading3.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 20.sp,
                              ),
                            ).animate().fadeIn(delay: 400.ms),

                            SizedBox(height: 16.h),

                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                _idea!.description,
                                style: AppTextStyles.body1.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  height: 1.6,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ).animate().slideY(delay: 500.ms, begin: 0.3),

                            SizedBox(height: 24.h),

                            // Creation Date
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Submitted ${_formatDate(_idea!.createdAt)}',
                                    style: AppTextStyles.body2.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.7),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(delay: 600.ms),

                            SizedBox(height: 32.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        bottomNavigationBar:
            _idea == null
                ? null
                : Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: _hasVoted ? 'Voted' : 'Upvote',
                            onPressed: _hasVoted ? null : _handleVote,
                            isLoading: _isVoting,
                            icon: Icon(
                              _hasVoted
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined,
                              size: 20.sp,
                              color: _hasVoted ? AppColors.success : null,
                            ),
                            backgroundColor:
                                _hasVoted
                                    ? AppColors.success.withOpacity(0.1)
                                    : null,
                            textColor: _hasVoted ? AppColors.success : null,
                            height: 48.h,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        CustomButton(
                          text: 'Share',
                          onPressed: _shareIdea,
                          isOutlined: true,
                          icon: Icon(Icons.share, size: 20.sp),
                          width: 120.w,
                          height: 48.h,
                        ),
                      ],
                    ),
                  ),
                ).animate().slideY(delay: 700.ms, begin: 1),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String? subtitle,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: AppTextStyles.heading2.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontSize: 10.sp,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}
