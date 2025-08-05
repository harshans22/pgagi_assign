import 'package:pgagi_assign/models/startup_idea.dart';
import 'package:pgagi_assign/services/ai_rating_service.dart';
import 'package:pgagi_assign/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class StartupRepository {
  final StorageService _storageService;
  static const _uuid = Uuid();

  StartupRepository(this._storageService);

  // Submit a new startup idea
  Future<StartupIdea> submitIdea({
    required String name,
    required String tagline,
    required String description,
  }) async {
    // Generate AI rating
    final aiResult = await AiRatingService.processIdea(
      name: name,
      tagline: tagline,
      description: description,
    );

    final idea = StartupIdea(
      id: _uuid.v4(),
      name: name,
      tagline: tagline,
      description: description,
      aiRating: aiResult['rating'],
      createdAt: DateTime.now(),
    );

    // Save to storage
    final ideas = await getAllIdeas();
    ideas.add(idea);
    await _storageService.saveIdeas(ideas);

    return idea;
  }

  // Get all startup ideas
  Future<List<StartupIdea>> getAllIdeas() async {
    return await _storageService.getIdeas();
  }

  // Get ideas sorted by rating
  Future<List<StartupIdea>> getIdeasByRating() async {
    final ideas = await getAllIdeas();
    ideas.sort((a, b) => b.aiRating.compareTo(a.aiRating));
    return ideas;
  }

  // Get ideas sorted by votes
  Future<List<StartupIdea>> getIdeasByVotes() async {
    final ideas = await getAllIdeas();
    ideas.sort((a, b) => b.votes.compareTo(a.votes));
    return ideas;
  }

  // Get top ideas for leaderboard
  Future<List<StartupIdea>> getTopIdeas({int limit = 5}) async {
    final ideas = await getIdeasByVotes();
    return ideas.take(limit).toList();
  }

  // Vote for an idea
  Future<bool> voteForIdea(String ideaId) async {
    final votedIds = await _storageService.getVotedIdeas();

    // Check if already voted
    if (votedIds.contains(ideaId)) {
      return false;
    }

    final ideas = await getAllIdeas();
    final ideaIndex = ideas.indexWhere((idea) => idea.id == ideaId);

    if (ideaIndex == -1) {
      return false;
    }

    // Increment vote count
    final updatedIdea = ideas[ideaIndex].copyWith(
      votes: ideas[ideaIndex].votes + 1,
    );
    ideas[ideaIndex] = updatedIdea;

    // Save updated ideas and voted IDs
    votedIds.add(ideaId);
    await _storageService.saveIdeas(ideas);
    await _storageService.saveVotedIdeas(votedIds);

    return true;
  }

  // Check if user has voted for an idea
  Future<bool> hasVoted(String ideaId) async {
    final votedIds = await _storageService.getVotedIdeas();
    return votedIds.contains(ideaId);
  }

  // Get user's voted ideas
  Future<Set<String>> getVotedIdeas() async {
    return await _storageService.getVotedIdeas();
  }

  // Search ideas
  Future<List<StartupIdea>> searchIdeas(String query) async {
    final ideas = await getAllIdeas();
    final lowercaseQuery = query.toLowerCase();

    return ideas.where((idea) {
      return idea.name.toLowerCase().contains(lowercaseQuery) ||
          idea.tagline.toLowerCase().contains(lowercaseQuery) ||
          idea.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get idea by ID
  Future<StartupIdea?> getIdeaById(String id) async {
    final ideas = await getAllIdeas();
    try {
      return ideas.firstWhere((idea) => idea.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear all data
  Future<bool> clearAllData() async {
    return await _storageService.clearAllData();
  }
}
