class CreateTripResponse {
  final String? id;
  final bool? success;
  final String? message;

  CreateTripResponse({
    this.id,
    this.success,
    this.message,
  });

  factory CreateTripResponse.fromJson(Map<String, dynamic> json) {
    return CreateTripResponse(
      id: json['_id'] as String?,
      success: json['success'] as bool?,
      message: json['message'] as String?,
    );
  }
}
