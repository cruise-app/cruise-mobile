import '../repositories/chatbot_repository.dart';

class PerformSafetyCheckUseCase {
  final ChatbotRepository repository;

  PerformSafetyCheckUseCase(this.repository);

  Future<Map<String, dynamic>> execute(String userId) {
    return repository.performSafetyCheck(userId);
  }
}
