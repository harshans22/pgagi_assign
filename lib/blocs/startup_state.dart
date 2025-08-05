import 'package:equatable/equatable.dart';
import 'package:pgagi_assign/blocs/startup_event.dart';
import 'package:pgagi_assign/models/startup_idea.dart';

abstract class StartupState extends Equatable {
  const StartupState();

  @override
  List<Object> get props => [];
}

class StartupInitial extends StartupState {}

class StartupLoading extends StartupState {}

class StartupSubmitting extends StartupState {}

class IdeasLoaded extends StartupState {
  final List<StartupIdea> ideas;
  final List<StartupIdea> displayedIdeas;
  final Set<String> votedIdeas;
  final SortType currentSort;
  final String searchQuery;

  const IdeasLoaded({
    required this.ideas,
    required this.displayedIdeas,
    required this.votedIdeas,
    this.currentSort = SortType.recent,
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [
    ideas,
    displayedIdeas,
    votedIdeas,
    currentSort,
    searchQuery,
  ];

  IdeasLoaded copyWith({
    List<StartupIdea>? ideas,
    List<StartupIdea>? displayedIdeas,
    Set<String>? votedIdeas,
    SortType? currentSort,
    String? searchQuery,
  }) {
    return IdeasLoaded(
      ideas: ideas ?? this.ideas,
      displayedIdeas: displayedIdeas ?? this.displayedIdeas,
      votedIdeas: votedIdeas ?? this.votedIdeas,
      currentSort: currentSort ?? this.currentSort,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class IdeaSubmitted extends StartupState {
  final StartupIdea submittedIdea;

  const IdeaSubmitted(this.submittedIdea);

  @override
  List<Object> get props => [submittedIdea];
}

class VoteSuccess extends StartupState {
  final String ideaId;

  const VoteSuccess(this.ideaId);

  @override
  List<Object> get props => [ideaId];
}

class VoteAlreadyCast extends StartupState {
  final String ideaId;

  const VoteAlreadyCast(this.ideaId);

  @override
  List<Object> get props => [ideaId];
}

class StartupError extends StartupState {
  final String message;

  const StartupError(this.message);

  @override
  List<Object> get props => [message];
}
