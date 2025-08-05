import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pgagi_assign/blocs/startup_bloc.dart';
import 'package:pgagi_assign/blocs/startup_event.dart';
import 'package:pgagi_assign/blocs/startup_state.dart';
import 'package:pgagi_assign/constants/app_constants.dart';
import 'package:pgagi_assign/utils/app_navigation.dart';
import 'package:pgagi_assign/widgets/common_widgets.dart';
import 'package:pgagi_assign/widgets/idea_card.dart';

class IdeasListScreen extends StatefulWidget {
  const IdeasListScreen({super.key});

  @override
  State<IdeasListScreen> createState() => _IdeasListScreenState();
}

class _IdeasListScreenState extends State<IdeasListScreen> {
  final _searchController = TextEditingController();
  final Set<String> _expandedIdeas = <String>{};
  SortType _currentSort = SortType.recent;

  @override
  void initState() {
    super.initState();
    context.read<StartupBloc>().add(LoadIdeas());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    context.read<StartupBloc>().add(SearchIdeas(query));
  }

  void _onSort(SortType sortType) {
    setState(() {
      _currentSort = sortType;
    });
    context.read<StartupBloc>().add(SortIdeas(sortType));
  }

  void _onRefresh() {
    context.read<StartupBloc>().add(RefreshIdeas());
  }

  void _toggleExpanded(String ideaId) {
    setState(() {
      if (_expandedIdeas.contains(ideaId)) {
        _expandedIdeas.remove(ideaId);
      } else {
        _expandedIdeas.add(ideaId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StartupBloc, StartupState>(
      listener: (context, state) {
        if (state is VoteSuccess) {
          Fluttertoast.showToast(
            msg: "Vote recorded! 🎉",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        } else if (state is VoteAlreadyCast) {
          Fluttertoast.showToast(
            msg: "You've already voted for this idea!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        } else if (state is StartupError) {
          Fluttertoast.showToast(
            msg: "Error: ${state.message}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      },
      builder: (context, state) {
        if (state is StartupLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is IdeasLoaded) {
          if (state.ideas.isEmpty) {
            return EmptyState(
              title: 'No Ideas Yet',
              message:
                  'Be the first to share your startup idea!\nTap the Submit tab to get started.',
              icon: Icons.lightbulb_outline,
              onAction: () {
                AppNavigation.goToSubmit();
              },
              actionText: 'Submit First Idea',
            );
          }

          return Column(
            children: [
              // Search and Filter Section
              Container(
                padding: EdgeInsets.all(16.w),
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      controller: _searchController,
                      onChanged: _onSearch,
                      decoration: InputDecoration(
                        hintText: 'Search ideas...',
                        prefixIcon: Icon(Icons.search, size: 20.sp),
                        suffixIcon:
                            _searchController.text.isNotEmpty
                                ? IconButton(
                                  icon: Icon(Icons.clear, size: 20.sp),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearch('');
                                  },
                                )
                                : null,
                      ),
                    ).animate().slideX(duration: 300.ms, begin: -0.1),

                    SizedBox(height: 16.h),

                    // Sort Options
                    Row(
                      children: [
                        Text(
                          'Sort by:',
                          style: AppTextStyles.subtitle2.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Row(
                            children: [
                              _buildSortChip('Recent', SortType.recent),
                              SizedBox(width: 8.w),
                              _buildSortChip('Rating', SortType.rating),
                              SizedBox(width: 8.w),
                              _buildSortChip('Votes', SortType.votes),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.refresh, size: 24.sp),
                          onPressed: _onRefresh,
                          tooltip: 'Refresh',
                        ),
                      ],
                    ).animate().fadeIn(delay: 200.ms),
                  ],
                ),
              ),

              // Results Info
              if (state.searchQuery.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Text(
                    '${state.displayedIdeas.length} results for "${state.searchQuery}"',
                    style: AppTextStyles.body2.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 12.sp,
                    ),
                  ),
                ).animate().slideY(duration: 200.ms, begin: -0.3),

              // Ideas List
              Expanded(
                child:
                    state.displayedIdeas.isEmpty
                        ? EmptyState(
                          title: 'No Results Found',
                          message: 'Try adjusting your search or filters.',
                          icon: Icons.search_off,
                        )
                        : RefreshIndicator(
                          onRefresh: () async {
                            _onRefresh();
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 32.h),
                            itemCount: state.displayedIdeas.length,
                            itemBuilder: (context, index) {
                              final idea = state.displayedIdeas[index];
                              final hasVoted = state.votedIdeas.contains(
                                idea.id,
                              );
                              final isExpanded = _expandedIdeas.contains(
                                idea.id,
                              );

                              return IdeaCard(
                                idea: idea,
                                hasVoted: hasVoted,
                                isExpanded: isExpanded,
                                onVote: () {
                                  context.read<StartupBloc>().add(
                                    VoteForIdea(idea.id),
                                  );
                                },
                                onToggleExpanded: () {
                                  _toggleExpanded(idea.id);
                                },
                              ).animate().fadeIn(
                                delay: (index * 100).ms,
                                duration: 400.ms,
                              );
                            },
                          ),
                        ),
              ),
            ],
          );
        }

        if (state is StartupError) {
          return EmptyState(
            title: 'Something Went Wrong',
            message: state.message,
            icon: Icons.error_outline,
            onAction: _onRefresh,
            actionText: 'Try Again',
          );
        }

        return const EmptyState(
          title: 'Welcome!',
          message: 'Loading your startup ideas...',
          icon: Icons.lightbulb_outline,
        );
      },
    );
  }

  Widget _buildSortChip(String label, SortType sortType) {
    final isSelected = _currentSort == sortType;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onSort(sortType),
        child: AnimatedContainer(
          duration: AppConstants.shortAnimationDuration,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
