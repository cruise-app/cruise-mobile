import '../repositories/chatbot_repository.dart';

class GetRecommendationsUseCase {
  final ChatbotRepository repository;

  GetRecommendationsUseCase(this.repository);

  Future<List<Map<String, dynamic>>> execute(String userId) {
    return repository.getRecommendations(userId);
  }
}
