import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pgagi_assign/blocs/startup_event.dart';
import 'package:pgagi_assign/blocs/startup_state.dart';
import 'package:pgagi_assign/models/startup_idea.dart';
import 'package:pgagi_assign/repositories/startup_repository.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState> {
  final StartupRepository _repository;

  StartupBloc(this._repository) : super(StartupInitial()) {
    on<LoadIdeas>(_onLoadIdeas);
    on<SubmitIdea>(_onSubmitIdea);
    on<VoteForIdea>(_onVoteForIdea);
    on<SortIdeas>(_onSortIdeas);
    on<SearchIdeas>(_onSearchIdeas);
    on<RefreshIdeas>(_onRefreshIdeas);
  }

  // Expose repository for screen access
  StartupRepository get repository => _repository;

  Future<void> _onLoadIdeas(LoadIdeas event, Emitter<StartupState> emit) async {
    try {
      emit(StartupLoading());

      final ideas = await _repository.getAllIdeas();
      final votedIdeas = await _repository.getVotedIdeas();

      // Sort by most recent by default
      final sortedIdeas = List<StartupIdea>.from(ideas);
      sortedIdeas.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      emit(
        IdeasLoaded(
          ideas: ideas,
          displayedIdeas: sortedIdeas,
          votedIdeas: votedIdeas,
          currentSort: SortType.recent,
        ),
      );
    } catch (e) {
      emit(StartupError('Failed to load ideas: ${e.toString()}'));
    }
  }

  Future<void> _onSubmitIdea(
    SubmitIdea event,
    Emitter<StartupState> emit,
  ) async {
    try {
      emit(StartupSubmitting());

      final submittedIdea = await _repository.submitIdea(
        name: event.name,
        tagline: event.tagline,
        description: event.description,
      );

      emit(IdeaSubmitted(submittedIdea));

      // Refresh the ideas list
      add(LoadIdeas());
    } catch (e) {
      emit(StartupError('Failed to submit idea: ${e.toString()}'));
    }
  }

  Future<void> _onVoteForIdea(
    VoteForIdea event,
    Emitter<StartupState> emit,
  ) async {
    try {
      final success = await _repository.voteForIdea(event.ideaId);

      if (success) {
        emit(VoteSuccess(event.ideaId));
        add(LoadIdeas());
      } else {
        emit(VoteAlreadyCast(event.ideaId));
      }
    } catch (e) {
      emit(StartupError('Failed to vote: ${e.toString()}'));
    }
  }

  Future<void> _onSortIdeas(SortIdeas event, Emitter<StartupState> emit) async {
    if (state is IdeasLoaded) {
      final currentState = state as IdeasLoaded;
      List<StartupIdea> sortedIdeas;

      switch (event.sortType) {
        case SortType.rating:
          sortedIdeas = List<StartupIdea>.from(currentState.ideas);
          sortedIdeas.sort((a, b) => b.aiRating.compareTo(a.aiRating));
          break;
        case SortType.votes:
          sortedIdeas = List<StartupIdea>.from(currentState.ideas);
          sortedIdeas.sort((a, b) => b.votes.compareTo(a.votes));
          break;
        case SortType.recent:
          sortedIdeas = List<StartupIdea>.from(currentState.ideas);
          sortedIdeas.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
      }

      if (currentState.searchQuery.isNotEmpty) {
        sortedIdeas = _filterIdeas(sortedIdeas, currentState.searchQuery);
      }

      emit(
        currentState.copyWith(
          displayedIdeas: sortedIdeas,
          currentSort: event.sortType,
        ),
      );
    }
  }

  Future<void> _onSearchIdeas(
    SearchIdeas event,
    Emitter<StartupState> emit,
  ) async {
    if (state is IdeasLoaded) {
      final currentState = state as IdeasLoaded;
      List<StartupIdea> filteredIdeas;

      if (event.query.isEmpty) {
        filteredIdeas = List<StartupIdea>.from(currentState.ideas);
      } else {
        filteredIdeas = _filterIdeas(currentState.ideas, event.query);
      }

      // Apply current sort
      switch (currentState.currentSort) {
        case SortType.rating:
          filteredIdeas.sort((a, b) => b.aiRating.compareTo(a.aiRating));
          break;
        case SortType.votes:
          filteredIdeas.sort((a, b) => b.votes.compareTo(a.votes));
          break;
        case SortType.recent:
          filteredIdeas.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
      }

      emit(
        currentState.copyWith(
          displayedIdeas: filteredIdeas,
          searchQuery: event.query,
        ),
      );
    }
  }

  Future<void> _onRefreshIdeas(
    RefreshIdeas event,
    Emitter<StartupState> emit,
  ) async {
    add(LoadIdeas());
  }

  List<StartupIdea> _filterIdeas(List<StartupIdea> ideas, String query) {
    final lowercaseQuery = query.toLowerCase();
    return ideas.where((idea) {
      return idea.name.toLowerCase().contains(lowercaseQuery) ||
          idea.tagline.toLowerCase().contains(lowercaseQuery) ||
          idea.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
