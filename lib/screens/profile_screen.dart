import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'follow_list_screen.dart';
import 'post_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String currentUserId;

  const ProfileScreen({
    super.key,
    required this.userId,
    required this.currentUserId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _apiService = ApiService();
  Map<String, dynamic>? _userData;
  List<dynamic> _userPosts = [];
  bool _isLoading = true;
  bool _isFollowing = false;
  bool _hasPendingRequest = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final userData = await _apiService.getUserProfile(widget.userId);
      final userPosts = await _apiService.getUserPosts(widget.userId);

      setState(() {
        _userData = userData;
        _userPosts = userPosts;
        _isFollowing =
            userData['followers'].any((f) => f['_id'] == widget.currentUserId);
        _hasPendingRequest =
            userData['pendingFollowRequests'].contains(widget.currentUserId);
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleFollowAction() async {
    try {
      await _apiService.sendFollowRequest(widget.currentUserId, widget.userId);
      setState(() => _hasPendingRequest = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Follow request sent')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _handleUnfollowAction() async {
    try {
      await _apiService.unfollowUser(widget.currentUserId, widget.userId);
      setState(() => _isFollowing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unfollowed successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showFollowList(String title, List<dynamic> users) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FollowListScreen(
          userId: widget.userId,
          currentUserId: widget.currentUserId,
          users: users,
          title: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB38E07)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _userData?['username'] ?? 'Profile',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (widget.userId != widget.currentUserId)
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      userId: widget.currentUserId,
                      currentUserId: widget.currentUserId,
                    ),
                  ),
                );
              },
              tooltip: 'My Profile',
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFFB38E07),
                  child: Text(
                    _userData?['username'][0].toUpperCase() ?? '',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _userData?['username'] ?? '',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFFD9D9D9),
                      ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () => _showFollowList(
                        'Posts',
                        _userPosts,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${_userPosts.length}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD9D9D9),
                            ),
                          ),
                          Text(
                            'Posts',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: const Color(0xFF292929),
                    ),
                    InkWell(
                      onTap: () => _showFollowList(
                        'Followers',
                        _userData?['followers'] ?? [],
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${_userData?['followers']?.length ?? 0}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD9D9D9),
                            ),
                          ),
                          Text(
                            'Followers',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: const Color(0xFF292929),
                    ),
                    InkWell(
                      onTap: () => _showFollowList(
                        'Following',
                        _userData?['following'] ?? [],
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${_userData?['following']?.length ?? 0}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD9D9D9),
                            ),
                          ),
                          Text(
                            'Following',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (widget.userId != widget.currentUserId) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 200,
                    child: _isFollowing
                        ? OutlinedButton(
                            onPressed: _handleUnfollowAction,
                            child: const Text('Unfollow'),
                          )
                        : ElevatedButton(
                            onPressed:
                                _hasPendingRequest ? null : _handleFollowAction,
                            child: Text(
                              _hasPendingRequest ? 'Request Pending' : 'Follow',
                            ),
                          ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _userPosts.length,
              itemBuilder: (context, index) {
                final post = _userPosts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(
                          post: post,
                          currentUserId: widget.currentUserId,
                        ),
                      ),
                    ).then((_) => _loadUserData());
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      post['imageUrl'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF292929),
                          child: const Center(
                            child: Icon(
                              Icons.error_outline,
                              color: Color(0xFFBDBDBD),
                              size: 24,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
