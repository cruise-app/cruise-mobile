import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // TODO: Change this to your backend URL
  static const String baseUrl =
      'http://10.0.2.2:3000'; // Android emulator localhost
  // Use 'http://localhost:3000' for iOS simulator
  // Use your actual IP address when testing on physical devices

  // Login or create user
  Future<Map<String, dynamic>> loginOrCreateUser(String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login/create user: ${response.body}');
    }
  }

  // Get user feed
  Future<List<dynamic>> getFeed(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/feed/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load feed: ${response.body}');
    }
  }

  // Create new post with image
  Future<Map<String, dynamic>> createPost({
    required String userId,
    required String text,
    required File imageFile,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/posts'));

    // Add text fields
    request.fields['userId'] = userId;
    request.fields['text'] = text;
    request.fields['postType'] = 'image';

    // Add image file
    var imageStream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile(
      'file',
      imageStream,
      length,
      filename: 'image.jpg',
    );
    request.files.add(multipartFile);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create post: ${response.body}');
    }
  }

  // Get user profile
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user profile: ${response.body}');
    }
  }

  // Get user posts
  Future<List<dynamic>> getUserPosts(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/posts'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user posts: ${response.body}');
    }
  }

  // Send follow request
  Future<void> sendFollowRequest(String userId, String targetUserId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/follow-request/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'targetUserId': targetUserId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send follow request: ${response.body}');
    }
  }

  // Accept follow request
  Future<void> acceptFollowRequest(
      String userId, String requesterId, String notificationId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accept-follow/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'requesterId': requesterId,
        'notificationId': notificationId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to accept follow request: ${response.body}');
    }
  }

  // Decline follow request
  Future<void> declineFollowRequest(
      String userId, String requesterId, String notificationId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/decline-follow/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'requesterId': requesterId,
        'notificationId': notificationId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to decline follow request: ${response.body}');
    }
  }

  // Get notifications
  Future<List<dynamic>> getNotifications(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifications/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load notifications: ${response.body}');
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/notifications/$notificationId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete notification: ${response.body}');
    }
  }

  // Like post
  Future<Map<String, dynamic>> likePost(String postId, String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts/$postId/like'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to like post: ${response.body}');
    }
  }

  // Add comment
  Future<Map<String, dynamic>> addComment(
      String postId, String userId, String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts/$postId/comment'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'text': text,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add comment: ${response.body}');
    }
  }

  // Unfollow user
  Future<void> unfollowUser(String userId, String targetUserId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/unfollow/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'targetUserId': targetUserId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unfollow user: ${response.body}');
    }
  }
}
