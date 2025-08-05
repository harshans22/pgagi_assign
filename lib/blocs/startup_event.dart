import 'package:equatable/equatable.dart';

enum SortType { rating, votes, recent }

abstract class StartupEvent extends Equatable {
  const StartupEvent();

  @override
  List<Object> get props => [];
}

class LoadIdeas extends StartupEvent {}

class SubmitIdea extends StartupEvent {
  final String name;
  final String tagline;
  final String description;

  const SubmitIdea({
    required this.name,
    required this.tagline,
    required this.description,
  });

  @override
  List<Object> get props => [name, tagline, description];
}

class VoteForIdea extends StartupEvent {
  final String ideaId;

  const VoteForIdea(this.ideaId);

  @override
  List<Object> get props => [ideaId];
}

class SortIdeas extends StartupEvent {
  final SortType sortType;

  const SortIdeas(this.sortType);

  @override
  List<Object> get props => [sortType];
}

class SearchIdeas extends StartupEvent {
  final String query;

  const SearchIdeas(this.query);

  @override
  List<Object> get props => [query];
}

class RefreshIdeas extends StartupEvent {}
