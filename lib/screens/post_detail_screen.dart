import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'profile_screen.dart';

class PostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;
  final String currentUserId;

  const PostDetailScreen({
    super.key,
    required this.post,
    required this.currentUserId,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _apiService = ApiService();
  Map<String, dynamic> _post = {};

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  Future<void> _handleLike() async {
    try {
      final updatedPost = await _apiService.likePost(
        _post['_id'],
        widget.currentUserId,
      );
      setState(() => _post = updatedPost);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasLiked = _post['likes'].contains(widget.currentUserId);

    return Scaffold(
      appBar: AppBar(
        title: Text(_post['user']['username']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(_post['user']['username']),
              subtitle: Text(
                _formatDate(DateTime.parse(_post['createdAt'])),
              ),
              onTap: () {
                if (_post['user']['_id'] != widget.currentUserId) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        userId: _post['user']['_id'],
                        currentUserId: widget.currentUserId,
                      ),
                    ),
                  );
                }
              },
            ),
            Image.network(
              _post['imageUrl'],
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 300,
                  child: Center(child: Icon(Icons.error)),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _post['text'],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          hasLiked ? Icons.favorite : Icons.favorite_border,
                          color: hasLiked ? Colors.red : Colors.black54,
                        ),
                        onPressed: _handleLike,
                      ),
                      Text(
                        '${_post['likes'].length}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
