import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import '../../features/chatbot/data/datasources/chatbot_api.dart';
import '../../features/chatbot/data/datasources/local_storage.dart';
import '../../features/chatbot/data/repositories/chatbot_repository.dart';
import '../../features/chatbot/data/repositories/user_repository.dart';
import '../../features/chatbot/domain/repositories/chatbot_repository.dart' as domain;
import '../../features/chatbot/domain/repositories/user_repository.dart' as domain;
import '../../features/chatbot/domain/usecases/process_message_usecase.dart';
import '../../features/chatbot/domain/usecases/book_ride_usecase.dart';
import '../../features/chatbot/domain/usecases/get_recommendations_usecase.dart';
import '../../features/chatbot/domain/usecases/get_carpool_opportunities_usecase.dart';
import '../../features/chatbot/domain/usecases/perform_safety_check_usecase.dart';
import '../../features/chatbot/presentation/bloc/chatbot_bloc.dart';
import '../config/app_config.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  
  // Dio HTTP client
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectionTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  sl.registerSingleton<Dio>(dio);
  
  // Data sources
  sl.registerLazySingleton<ChatbotApi>(
    () => ChatbotApi(baseUrl: AppConfig.apiBaseUrl),
  );
  sl.registerLazySingleton<LocalStorage>(
    () => LocalStorage(sl<SharedPreferences>()),
  );
  
  // Repositories
  sl.registerLazySingleton<domain.ChatbotRepository>(
    () => ChatbotRepositoryImpl(
      sl<ChatbotApi>(),
      sl<LocalStorage>(),
    ),
  );
  sl.registerLazySingleton<domain.UserRepository>(
    () => UserRepositoryImpl(
      sl<ChatbotApi>(),
      sl<LocalStorage>(),
    ),
  );
  
  // Use cases
  sl.registerLazySingleton<ProcessMessageUseCase>(
    () => ProcessMessageUseCase(sl<domain.ChatbotRepository>()),
  );
  sl.registerLazySingleton<BookRideUseCase>(
    () => BookRideUseCase(sl<domain.ChatbotRepository>()),
  );
  sl.registerLazySingleton<GetRecommendationsUseCase>(
    () => GetRecommendationsUseCase(sl<domain.ChatbotRepository>()),
  );
  sl.registerLazySingleton<GetCarpoolOpportunitiesUseCase>(
    () => GetCarpoolOpportunitiesUseCase(sl<domain.ChatbotRepository>()),
  );
  sl.registerLazySingleton<PerformSafetyCheckUseCase>(
    () => PerformSafetyCheckUseCase(sl<domain.ChatbotRepository>()),
  );
  
  // BLoCs
  sl.registerFactory<ChatbotBloc>(
    () => ChatbotBloc(
      processMessageUseCase: sl<ProcessMessageUseCase>(),
      bookRideUseCase: sl<BookRideUseCase>(),
      getRecommendationsUseCase: sl<GetRecommendationsUseCase>(),
      getCarpoolOpportunitiesUseCase: sl<GetCarpoolOpportunitiesUseCase>(),
      performSafetyCheckUseCase: sl<PerformSafetyCheckUseCase>(),
    ),
  );
}
