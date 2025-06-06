import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'chatbot_event.dart';
import 'chatbot_state.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/process_message_usecase.dart';
import '../../domain/usecases/book_ride_usecase.dart';
import '../../domain/usecases/get_recommendations_usecase.dart';
import '../../domain/usecases/get_carpool_opportunities_usecase.dart';
import '../../domain/usecases/perform_safety_check_usecase.dart';
import '../../data/models/message_model.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ProcessMessageUseCase processMessageUseCase;
  final BookRideUseCase bookRideUseCase;
  final GetRecommendationsUseCase getRecommendationsUseCase;
  final GetCarpoolOpportunitiesUseCase getCarpoolOpportunitiesUseCase;
  final PerformSafetyCheckUseCase performSafetyCheckUseCase;
  
  final List<Message> _messages = [];
  List<Message> get messages => List.unmodifiable(_messages);
  final uuid = Uuid();

  ChatbotBloc({
    required this.processMessageUseCase,
    required this.bookRideUseCase,
    required this.getRecommendationsUseCase,
    required this.getCarpoolOpportunitiesUseCase,
    required this.performSafetyCheckUseCase,
  }) : super(const ChatbotInitial()) {
    on<InitChatbotEvent>(_onInitChatbot);
    on<SendMessageEvent>(_onSendMessage);
    on<GetRecommendationsEvent>(_onGetRecommendations);
    on<GetCarpoolOpportunitiesEvent>(_onGetCarpoolOpportunities);
    on<PerformSafetyCheckEvent>(_onPerformSafetyCheck);
    on<BookRideEvent>(_onBookRide);
    on<CancelRideEvent>(_onCancelRide);
    on<GetAvailableCarsEvent>(_onGetAvailableCars);
  }

  Future<void> _onInitChatbot(InitChatbotEvent event, Emitter<ChatbotState> emit) async {
    emit(const ChatbotLoading());
    
    // Add initial bot greeting
    final greeting = MessageModel(
      id: uuid.v4(),
      content: 'Hello! I\'m RideBot. How can I assist you today with your transportation needs?',
      type: MessageType.text,
      sender: MessageSender.bot,
      timestamp: DateTime.now(),
    );
    
    _messages.add(greeting);
    emit(MessageSent(message: greeting, allMessages: List.from(_messages)));
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatbotState> emit) async {
    try {
      // First add user message to list
      final userMessage = MessageModel(
        id: uuid.v4(),
        content: event.message,
        type: MessageType.text,
        sender: MessageSender.user,
        timestamp: DateTime.now(),
      );
      
      _messages.add(userMessage);
      
      // Show loading state but keep all messages
      emit(MessageSending());
      
      try {
        // Process with AI
        final botResponse = await processMessageUseCase.execute(
          event.message,
          event.userId,
          language: event.language,
        );
        
        _messages.add(botResponse);
        
        emit(MessageSent(message: botResponse, allMessages: List.from(_messages)));
      } catch (e) {
        // Add error message to chat instead of failing completely
        final errorMessage = MessageModel(
          id: uuid.v4(),
          content: 'Sorry, I\'m having trouble connecting to my systems. Please try again in a moment.',
          type: MessageType.text,
          sender: MessageSender.bot,
          timestamp: DateTime.now(),
        );
        
        _messages.add(errorMessage);
        emit(MessageSent(message: errorMessage, allMessages: List.from(_messages)));
        
        // Also emit error state to show a notification
        emit(ChatbotError(message: 'Failed to get response: ${e.toString()}'));
      }
    } catch (e) {
      emit(ChatbotError(message: 'Failed to send message: ${e.toString()}'));
    }
  }

  Future<void> _onGetRecommendations(GetRecommendationsEvent event, Emitter<ChatbotState> emit) async {
    try {
      emit(const RecommendationsLoading());
      
      final recommendations = await getRecommendationsUseCase.execute(event.userId);
      
      // Add a message about recommendations
      if (recommendations.isNotEmpty) {
        final botMessage = MessageModel(
          id: uuid.v4(),
          content: recommendations.first['content'],
          type: MessageType.recommendation,
          sender: MessageSender.bot,
          timestamp: DateTime.now(),
          additionalData: {'recommendations': recommendations},
        );
        
        _messages.add(botMessage);
        emit(MessageSent(message: botMessage, allMessages: List.from(_messages)));
      }
      
      emit(RecommendationsLoaded(recommendations: recommendations));
    } catch (e) {
      emit(ChatbotError(message: 'Failed to get recommendations: ${e.toString()}'));
    }
  }

  Future<void> _onGetCarpoolOpportunities(GetCarpoolOpportunitiesEvent event, Emitter<ChatbotState> emit) async {
    try {
      emit(const CarpoolOpportunitiesLoading());
      
      final opportunities = await getCarpoolOpportunitiesUseCase.execute(event.userId);
      
      // Add a message about carpool opportunities
      if (opportunities.isNotEmpty) {
        final botMessage = MessageModel(
          id: uuid.v4(),
          content: 'I found ${opportunities.length} carpool opportunities for your route.',
          type: MessageType.carpool,
          sender: MessageSender.bot,
          timestamp: DateTime.now(),
          additionalData: {'opportunities': opportunities},
        );
        
        _messages.add(botMessage);
        emit(MessageSent(message: botMessage, allMessages: List.from(_messages)));
      } else {
        final botMessage = MessageModel(
          id: uuid.v4(),
          content: 'I don\'t see any carpool opportunities at the moment. Would you like to book a regular ride?',
          type: MessageType.text,
          sender: MessageSender.bot,
          timestamp: DateTime.now(),
        );
        
        _messages.add(botMessage);
        emit(MessageSent(message: botMessage, allMessages: List.from(_messages)));
      }
      
      emit(CarpoolOpportunitiesLoaded(opportunities: opportunities));
    } catch (e) {
      emit(ChatbotError(message: 'Failed to get carpool opportunities: ${e.toString()}'));
    }
  }

  Future<void> _onPerformSafetyCheck(PerformSafetyCheckEvent event, Emitter<ChatbotState> emit) async {
    try {
      emit(const SafetyCheckLoading());
      
      final safetyCheck = await performSafetyCheckUseCase.execute(event.userId);
      
      // Add a message about safety check
      final botMessage = MessageModel(
        id: uuid.v4(),
        content: 'Safety check completed. Recommendations: ${safetyCheck['recommendations']}',
        type: MessageType.safety,
        sender: MessageSender.bot,
        timestamp: DateTime.now(),
        additionalData: safetyCheck,
      );
      
      _messages.add(botMessage);
      
      emit(MessageSent(message: botMessage, allMessages: List.from(_messages)));
      emit(SafetyCheckLoaded(safetyCheck: safetyCheck));
    } catch (e) {
      emit(ChatbotError(message: 'Failed to perform safety check: ${e.toString()}'));
    }
  }

  Future<void> _onBookRide(BookRideEvent event, Emitter<ChatbotState> emit) async {
    try {
      emit(const BookingRide());
      
      final trip = await bookRideUseCase.execute(event.userId, event.rideDetails);
      
      // Add a message about booking
      final botMessage = MessageModel(
        id: uuid.v4(),
        content: 'Great! I\'ve booked your ride. Your booking ID is ${trip.id}.',
        type: MessageType.text,
        sender: MessageSender.bot,
        timestamp: DateTime.now(),
        additionalData: {'trip': trip},
      );
      
      _messages.add(botMessage);
      
      emit(MessageSent(message: botMessage, allMessages: List.from(_messages)));
      emit(RideBooked(trip: trip));
    } catch (e) {
      emit(ChatbotError(message: 'Failed to book ride: ${e.toString()}'));
    }
  }

  Future<void> _onCancelRide(CancelRideEvent event, Emitter<ChatbotState> emit) async {
    try {
      emit(const CancellingRide());
      
      final result = await processMessageUseCase.execute(
        'Cancel my ride with ID ${event.rideId}',
        event.userId,
      );
      
      _messages.add(result);
      
      emit(MessageSent(message: result, allMessages: List.from(_messages)));
      emit(const RideCancelled(result: {'status': 'cancelled'}));
    } catch (e) {
      emit(ChatbotError(message: 'Failed to cancel ride: ${e.toString()}'));
    }
  }

  Future<void> _onGetAvailableCars(GetAvailableCarsEvent event, Emitter<ChatbotState> emit) async {
    try {
      emit(const CarsLoading());
      
      // Would normally call a use case, but we haven't defined one for this
      // For now, just create some mock cars
      final cars = [
        MessageModel(
          id: uuid.v4(),
          content: 'Here are some available cars for your ride:',
          type: MessageType.carOptions,
          sender: MessageSender.bot,
          timestamp: DateTime.now(),
          additionalData: {
            'cars': [
              {
                'id': 'car_1',
                'model': 'Toyota Camry',
                'plateNumber': 'ABC 123',
                'type': 'standard',
                'imageUrl': 'assets/images/car_standard.png',
                'price': 25.0,
                'estimatedTimeMin': 5,
              },
              {
                'id': 'car_2',
                'model': 'Honda Accord',
                'plateNumber': 'DEF 456',
                'type': 'comfort',
                'imageUrl': 'assets/images/car_comfort.png',
                'price': 35.0,
                'estimatedTimeMin': 7,
              },
              {
                'id': 'car_3',
                'model': 'Mercedes S-Class',
                'plateNumber': 'GHI 789',
                'type': 'luxury',
                'imageUrl': 'assets/images/car_luxury.png',
                'price': 50.0,
                'estimatedTimeMin': 10,
              },
            ]
          },
        ),
      ];
      
      _messages.add(cars.first);
      
      emit(MessageSent(message: cars.first, allMessages: List.from(_messages)));
    } catch (e) {
      emit(ChatbotError(message: 'Failed to get available cars: ${e.toString()}'));
    }
  }

  // Clean up resources
  @override
  Future<void> close() {
    _messages.clear();
    return super.close();
  }
}
