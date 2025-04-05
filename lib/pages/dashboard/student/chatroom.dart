import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../backend/models.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatroomViewPage extends StatefulWidget {
  final Session session;
  final User student;
  final Chatroom chatroom;
  final String backMessage;

  const ChatroomViewPage({
    super.key,
    required this.session,
    required this.student,
    required this.chatroom,
    required this.backMessage,
  });

  @override
  State<ChatroomViewPage> createState() => _ChatroomViewPageState();
}

class _ChatroomViewPageState extends State<ChatroomViewPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
  }

  Future<void> _loadInitialMessages() async {
    final messages = await widget.chatroom.getMessages(widget.session);
    setState(() => _messages.addAll(messages));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(widget.backMessage),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isCurrentUser = message.senderId == widget.student.id;
                return _MessageCard(
                  message: message,
                  isCurrentUser: isCurrentUser,
                  onBookmark: () => _handleBookmark(message),
                  onFavorite: () => _handleFavorite(message),
                  onUpvote: () => _handleVote(message, 1),
                  onDownvote: () => _handleVote(message, -1),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.attach_file,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: _handleAttachment,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) => setState(() {}), // This triggers rebuilds
              onSubmitted: (value) async => await _sendMessage(),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child:
                _messageController.text.trim().isEmpty
                    ? IconButton(
                      key: const ValueKey('mic'), // Important for animation
                      icon: Icon(
                        Icons.mic,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: _handleVoiceMessage,
                    )
                    : IconButton(
                      key: const ValueKey('send'), // Important for animation
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: _sendMessage,
                    ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;
    if (!await widget.chatroom.sendMessage(widget.session, content)) {
      return;
    }

    final newMessage = ChatMessage(
      id: widget.student.id,
      content: content,
      senderId: widget.student.id,
      chatroomId: widget.chatroom.id,
      sent: DateTime.now(),
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _handleAttachment() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('Photo/Video'),
                  onTap: () => _handleMediaSelection('image'),
                ),
                ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: const Text('Document'),
                  onTap: () => _handleFileSelection(),
                ),
              ],
            ),
          ),
    );
  }

  void _handleMediaSelection(String type) {
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Selected media type: $type')));
  }

  void _handleFileSelection() {
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('File selection handler')));
  }

  void _handleVoiceMessage() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Voice Message'),
            content: const Text('You cannot use voice messages yet, sorry'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  void _handleBookmark(ChatMessage message) {
    return;
  }

  void _handleFavorite(ChatMessage message) {
    return;
  }

  void _handleVote(ChatMessage message, int value) {
    return;
  }
}

class _MessageCard extends StatefulWidget {
  final ChatMessage message;
  final bool isCurrentUser;
  final VoidCallback onBookmark;
  final VoidCallback onFavorite;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  const _MessageCard({
    required this.message,
    required this.isCurrentUser,
    required this.onBookmark,
    required this.onFavorite,
    required this.onUpvote,
    required this.onDownvote,
  });

  @override
  State<_MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<_MessageCard> {
  bool _isBookmarked = false;
  bool _isFavorited = false;
  int _votes = 0;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          widget.isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Card(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 8),
                MarkdownBody(
                  data: widget.message.content,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                _buildActionBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        FutureBuilder(
          future: User.fromId(widget.message.senderId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return CircleAvatar(
                radius: 16,
                backgroundColor: Color.alphaBlend(
                  Colors.red.withOpacity(0.5),
                  Colors.grey[300]!,
                ),
                child: Text(
                  widget.message.senderId.substring(0, 2).toUpperCase(),
                  style: const TextStyle(fontSize: 12),
                ),
              );
            }
            if (!snapshot.hasData) {
              return CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[300],
                child: Text(
                  widget.message.senderId.substring(0, 2).toUpperCase(),
                  style: const TextStyle(fontSize: 12),
                ),
              );
            }
            return CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(snapshot.data!.profile.getPath()),
            );
          },
        ),
        const SizedBox(width: 8),
        Text(
          DateFormat('MMM dd, yyyy - HH:mm').format(widget.message.sent),
          style: TextStyle(
            color: widget.isCurrentUser ? Colors.white70 : Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: _isBookmarked ? Colors.amber : null,
              ),
              onPressed: () {
                setState(() => _isBookmarked = !_isBookmarked);
                widget.onBookmark();
              },
            ),
            IconButton(
              icon: Icon(
                _isFavorited ? Icons.favorite : Icons.favorite_border,
                color: _isFavorited ? Colors.red : null,
              ),
              onPressed: () {
                setState(() => _isFavorited = !_isFavorited);
                widget.onFavorite();
              },
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: () {
                setState(() => _votes++);
                widget.onUpvote();
              },
            ),
            Text('$_votes'),
            IconButton(
              icon: const Icon(Icons.arrow_downward),
              onPressed: () {
                setState(() => _votes--);
                widget.onDownvote();
              },
            ),
          ],
        ),
      ],
    );
  }
}
