import '../entities/trip.dart';
import '../repositories/chatbot_repository.dart';

class BookRideUseCase {
  final ChatbotRepository repository;

  BookRideUseCase(this.repository);

  Future<Trip> execute(String userId, Map<String, dynamic> rideDetails) {
    return repository.bookRide(userId, rideDetails);
  }
}
