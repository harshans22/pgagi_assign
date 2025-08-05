import 'dart:math';

class AiRatingService {
  static final Random _random = Random();

  // List of positive AI feedback phrases
  static const List<String> _feedbackPhrases = [
    "Revolutionary concept!",
    "Market disruption potential detected",
    "Strong scalability indicators",
    "Innovative solution approach",
    "High user engagement potential",
    "Promising revenue model",
    "Excellent timing for market entry",
    "Strong competitive advantage",
    "Outstanding execution potential",
    "Game-changing innovation",
    "Significant market opportunity",
    "Impressive business model",
    "Strong product-market fit",
    "Exceptional growth potential",
    "Breakthrough technology application",
  ];

  // Generate a fake AI rating between 0-100
  static int generateRating() {
    // Weighted random to favor higher scores (more realistic for submissions)
    final double weightedRandom = _random.nextDouble();

    if (weightedRandom < 0.1) {
      // 10% chance for low scores (0-40)
      return _random.nextInt(41);
    } else if (weightedRandom < 0.3) {
      // 20% chance for medium scores (41-70)
      return 41 + _random.nextInt(30);
    } else {
      // 70% chance for high scores (71-100)
      return 71 + _random.nextInt(30);
    }
  }

  // Generate fake AI feedback text
  static String generateFeedback() {
    return _feedbackPhrases[_random.nextInt(_feedbackPhrases.length)];
  }

  // Get rating color based on score
  static String getRatingCategory(int rating) {
    if (rating >= 90) return "Exceptional";
    if (rating >= 80) return "Excellent";
    if (rating >= 70) return "Good";
    if (rating >= 60) return "Average";
    if (rating >= 40) return "Below Average";
    return "Poor";
  }

  // Simulate AI processing delay
  static Future<Map<String, dynamic>> processIdea({
    required String name,
    required String tagline,
    required String description,
  }) async {
    // Simulate AI processing time
    await Future.delayed(Duration(milliseconds: 1500 + _random.nextInt(1000)));

    final rating = generateRating();
    final feedback = generateFeedback();
    final category = getRatingCategory(rating);

    return {'rating': rating, 'feedback': feedback, 'category': category};
  }
}
