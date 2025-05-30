import '../repositories/chatbot_repository.dart';

class GetCarpoolOpportunitiesUseCase {
  final ChatbotRepository repository;

  GetCarpoolOpportunitiesUseCase(this.repository);

  Future<List<Map<String, dynamic>>> execute(String userId) {
    return repository.getCarpoolOpportunities(userId);
  }
}
