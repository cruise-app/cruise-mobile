import '../entities/message.dart';
import '../repositories/chatbot_repository.dart';

class ProcessMessageUseCase {
  final ChatbotRepository repository;

  ProcessMessageUseCase(this.repository);

  Future<Message> execute(String message, String userId, {String language = 'en'}) {
    return repository.processMessage(message, userId, language: language);
  }
}
