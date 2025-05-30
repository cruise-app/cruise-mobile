import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/car.dart';
import '../bloc/chatbot_bloc.dart';
import '../bloc/chatbot_event.dart';
import '../bloc/chatbot_state.dart';
import '../widgets/message_bubble.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/input_field.dart';
import '../widgets/car_card.dart';
import '../widgets/carpool_card.dart';
import '../widgets/safety_check_card.dart';
import '../widgets/recommendation_card.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  // Simulated user ID for development
  final String userId = 'user_1234';
  final ScrollController _scrollController = ScrollController();
  late ChatbotBloc _chatbotBloc;
  
  @override
  void initState() {
    super.initState();
    _chatbotBloc = sl<ChatbotBloc>();
    _chatbotBloc.add(const InitChatbotEvent());
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _chatbotBloc,
      child: BlocConsumer<ChatbotBloc, ChatbotState>(
        listener: (context, state) {
          if (state is MessageSent) {
            _scrollToBottom();
          } else if (state is ChatbotError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            appBar: _buildAppBar(),
            body: Column(
              children: [
                // Chat messages
                Expanded(
                  child: _buildChatMessages(state),
                ),
                
                // Input field
                InputField(
                  isLoading: state is MessageSending,
                  onSend: (message) {
                    _chatbotBloc.add(SendMessageEvent(
                      message: message,
                      userId: userId,
                    ));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          const ProfileAvatar(
            sender: MessageSender.bot,
            size: 36.0,
          ),
          const SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'RideBot',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Always active',
                style: TextStyle(
                  fontSize: 12.0,
                  color: AppColors.textColorLight,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }
  
  Widget _buildChatMessages(ChatbotState state) {
    List<Message> messages = [];
    bool isLoading = false;
    
    if (state is MessageSent) {
      messages = state.allMessages;
    } else if (state is MessageSending && _chatbotBloc.messages.isNotEmpty) {
      // Show existing messages while loading
      messages = _chatbotBloc.messages;
      isLoading = true;
    } else if (state is ChatbotLoading && _chatbotBloc.messages.isNotEmpty) {
      messages = _chatbotBloc.messages;
    }
    
    return messages.isEmpty
        ? const Center(
            child: Text(
              'Start a conversation!',
              style: TextStyle(color: AppColors.textColorLight),
            ),
          )
        : Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: messages.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (isLoading && index == messages.length) {
                    // Add typing indicator when loading
                    return _buildTypingIndicator();
                  }
                  
                  final message = messages[index];
                  return Column(
                    children: [
                      // Date header for first message or when date changes
                      if (index == 0 || _shouldShowDateHeader(messages, index))
                        _buildDateHeader(message.timestamp),
                      
                      // Message content
                      _buildMessageContent(message),
                    ],
                  );
                },
              ),
            ],
          );
  }
  
  bool _shouldShowDateHeader(List<Message> messages, int index) {
    if (index == 0) return true;
    
    final currentDate = DateTime(
      messages[index].timestamp.year,
      messages[index].timestamp.month,
      messages[index].timestamp.day,
    );
    
    final previousDate = DateTime(
      messages[index - 1].timestamp.year,
      messages[index - 1].timestamp.month,
      messages[index - 1].timestamp.day,
    );
    
    return currentDate != previousDate;
  }
  
  Widget _buildDateHeader(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );
    
    String dateText;
    if (messageDate == today) {
      dateText = 'Today';
    } else if (messageDate == yesterday) {
      dateText = 'Yesterday';
    } else {
      dateText = DateFormat('MMM d, yyyy').format(timestamp);
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 6.0,
          ),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Text(
            dateText,
            style: TextStyle(
              color: AppColors.textColorLight,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildMessageContent(Message message) {
    // Handle different message types
    switch (message.type) {
      case MessageType.carOptions:
        return _buildCarOptionsMessage(message);
      
      case MessageType.carpool:
        return _buildCarpoolMessage(message);
      
      case MessageType.safety:
        return _buildSafetyMessage(message);
      
      case MessageType.recommendation:
        return _buildRecommendationMessage(message);
      
      case MessageType.location:
        return _buildLocationMessage(message);
      
      case MessageType.text:
      default:
        return _buildTextMessage(message);
    }
  }
  
  Widget _buildTextMessage(Message message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar for bot messages
          if (message.sender == MessageSender.bot)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ProfileAvatar(
                sender: message.sender,
                size: 32.0,
              ),
            ),
          
          // Message bubble
          Expanded(
            child: MessageBubble(
              message: message,
              onTap: () {},
            ),
          ),
          
          // Avatar for user messages (empty space to align)
          if (message.sender == MessageSender.user)
            const SizedBox(width: 40.0),
        ],
      ),
    );
  }
  
  Widget _buildCarOptionsMessage(Message message) {
    final cars = (message.additionalData?['cars'] as List?)?.map((car) {
      return Car(
        id: car['id'],
        model: car['model'],
        plateNumber: car['plateNumber'],
        type: _mapCarTypeFromString(car['type']),
        imageUrl: car['imageUrl'],
        price: car['price'],
        estimatedTimeMin: car['estimatedTimeMin'],
      );
    }).toList() ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bot message
        _buildTextMessage(message),
        
        // Car options
        ...cars.map((car) => Padding(
          padding: const EdgeInsets.only(
            left: 40.0,
            right: 8.0,
            bottom: 8.0,
          ),
          child: CarCard(
            car: car,
            onTap: () {
              _chatbotBloc.add(BookRideEvent(
                userId: userId,
                rideDetails: {
                  'car_id': car.id,
                  'pickup': 'Current Location',
                  'dropoff': 'Destination',
                },
              ));
            },
          ),
        )).toList(),
      ],
    );
  }
  
  Widget _buildCarpoolMessage(Message message) {
    final opportunities = (message.additionalData?['opportunities'] as List? ?? []);
    
    if (opportunities.isEmpty) {
      return _buildTextMessage(message);
    }
    
    final opportunity = opportunities.first;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bot message
        _buildTextMessage(message),
        
        // Carpool opportunity
        Padding(
          padding: const EdgeInsets.only(
            left: 40.0,
            right: 8.0,
            bottom: 8.0,
          ),
          child: CarpoolCard(
            driverName: opportunity['driver'],
            pickupLocation: opportunity['pickup'],
            dropoffLocation: opportunity['dropoff'],
            time: DateTime.parse(opportunity['time']),
            seats: opportunity['seats'],
            price: opportunity['price'].toDouble(),
            onJoin: () {
              _chatbotBloc.add(SendMessageEvent(
                message: 'I want to join this carpool',
                userId: userId,
              ));
            },
            onCancel: () {
              _chatbotBloc.add(SendMessageEvent(
                message: 'Show me other options',
                userId: userId,
              ));
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildSafetyMessage(Message message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bot message
        _buildTextMessage(message),
        
        // Safety check card
        Padding(
          padding: const EdgeInsets.only(
            left: 40.0,
            right: 8.0,
            bottom: 8.0,
          ),
          child: SafetyCheckCard(
            title: 'Safety Check',
            recommendation: message.content,
            isPassing: true,
            onAction: () {
              _chatbotBloc.add(SendMessageEvent(
                message: 'Yes, I\'m safe',
                userId: userId,
              ));
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildRecommendationMessage(Message message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bot message
        _buildTextMessage(message),
        
        // Recommendation card
        Padding(
          padding: const EdgeInsets.only(
            left: 40.0,
            right: 8.0,
            bottom: 8.0,
          ),
          child: RecommendationCard(
            title: 'Recommended Ride',
            description: message.content,
            icon: Icons.star,
            onTap: () {
              _chatbotBloc.add(SendMessageEvent(
                message: 'Tell me more about this recommendation',
                userId: userId,
              ));
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildLocationMessage(Message message) {
    // For now, just show as a text message
    return _buildTextMessage(message);
  }
  
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ProfileAvatar(
                sender: MessageSender.bot,
                size: 32.0,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 10.0,
                right: 50.0,
                top: 5.0,
                bottom: 5.0,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                color: AppColors.bubbleColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(0.0),
                  bottomRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor.withOpacity(0.1),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDot(),
                  const SizedBox(width: 4),
                  _buildDot(delay: 300),
                  const SizedBox(width: 4),
                  _buildDot(delay: 600),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDot({int delay = 0}) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Opacity(
        opacity: 0.7,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.5, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
  
  CarType _mapCarTypeFromString(String type) {
    switch (type) {
      case 'comfort':
        return CarType.comfort;
      case 'luxury':
        return CarType.luxury;
      case 'suv':
        return CarType.suv;
      case 'standard':
      default:
        return CarType.standard;
    }
  }
}
