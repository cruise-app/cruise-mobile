import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class InputField extends StatefulWidget {
  final Function(String) onSend;
  final String hintText;
  final bool isLoading;

  const InputField({
    Key? key,
    required this.onSend,
    this.hintText = 'Type a message...',
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  void _handleSend() {
    if (_controller.text.isNotEmpty && !widget.isLoading) {
      widget.onSend(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Microphone button (can be used for voice input)
          IconButton(
            onPressed: () {
              // Could implement voice input here
            },
            icon: Icon(
              Icons.mic,
              color: AppColors.iconColor,
            ),
          ),
          
          // Text input field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: AppColors.textColorLight,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(
                  fontSize: 16.0,
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (value) => _handleSend(),
                enabled: !widget.isLoading,
              ),
            ),
          ),
          
          // Send button
          IconButton(
            onPressed: _hasText ? _handleSend : null,
            icon: widget.isLoading
                ? SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryColor,
                      ),
                    ),
                  )
                : Icon(
                    Icons.send,
                    color: _hasText
                        ? AppColors.primaryColor
                        : AppColors.iconColor.withOpacity(0.5),
                  ),
          ),
        ],
      ),
    );
  }
}
