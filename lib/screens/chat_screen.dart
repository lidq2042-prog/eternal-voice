import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String personaName;

  const ChatScreen({super.key, required this.personaName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatBubble> _messages = [];
  bool _isTyping = false;

  // 预设的回复（实际应用中由AI生成）
  final Map<String, List<String>> _autoReplies = {
    'default': [
      '宝贝，妈妈想你了~',
      '有没有好好吃饭呀？',
      '天冷了要多穿点衣服哦',
      '最近工作忙不忙？要注意休息',
      '周末回来看看妈妈吧',
    ],
    '想你': [
      '妈妈也想你呀，宝贝~',
      '有空就回来看看，妈妈给你做好吃的',
    ],
    '吃饭': [
      '按时吃饭最重要，别饿着自己',
      '想吃什么？妈妈给你做',
    ],
    '累': [
      '别太累了，身体最重要',
      '休息一下吧，别硬撑着',
    ],
  };

  @override
  void initState() {
    super.initState();
    // 添加欢迎消息
    _messages.add(ChatBubble(
      message: '宝贝，妈妈在呢~想跟妈妈说什么？',
      isMe: false,
      time: _formatTime(DateTime.now()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F8),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE4E9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text('👵', style: TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.personaName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '在线',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          // 提示信息
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFFFF3F6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  '正在模拟 ${widget.personaName} 回复',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // 聊天消息列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          
          // 输入框
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                // 语音按钮
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB6C1).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.mic,
                      color: Color(0xFFD4528A),
                    ),
                    onPressed: () {
                      // TODO: 语音输入
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('语音功能开发中...')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                
                // 文字输入框
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: '输入消息...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onSubmitted: (text) {
                        if (text.isNotEmpty) {
                          _sendMessage(text);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // 发送按钮
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB6C1),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        _sendMessage(_messageController.text);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // 快捷回复
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickReply('想你了'),
                  _buildQuickReply('吃了'),
                  _buildQuickReply('好的'),
                  _buildQuickReply('知道了'),
                  _buildQuickReply('你也注意身体'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 快捷回复按钮
  Widget _buildQuickReply(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text),
        backgroundColor: const Color(0xFFFFE4E9),
        labelStyle: const TextStyle(
          color: Color(0xFFD4528A),
          fontSize: 13,
        ),
        onPressed: () {
          _sendMessage(text);
        },
      ),
    );
  }

  // 发送消息
  void _sendMessage(String text) {
    setState(() {
      _messages.add(ChatBubble(
        message: text,
        isMe: true,
        time: _formatTime(DateTime.now()),
      ));
      _messageController.clear();
      _isTyping = true;
    });

    // 模拟对方回复（延迟1-2秒）
    Future.delayed(Duration(seconds: 1 + (DateTime.now().second % 2)), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatBubble(
            message: _getAutoReply(text),
            isMe: false,
            time: _formatTime(DateTime.now()),
          ));
        });
      }
    });
  }

  // 获取自动回复
  String _getAutoReply(String userMessage) {
    // 检查关键词
    for (var entry in _autoReplies.entries) {
      if (entry.key != 'default' && userMessage.contains(entry.key)) {
        final replies = entry.value;
        return replies[DateTime.now().millisecond % replies.length];
      }
    }
    
    // 默认回复
    final defaultReplies = _autoReplies['default']!;
    return defaultReplies[DateTime.now().millisecond % defaultReplies.length];
  }

  // 格式化时间
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

// 聊天气泡组件
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE4E9),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Center(
                child: Text('👵', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFFFFB6C1) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isMe ? 20 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      color: isMe ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 11,
                      color: isMe ? Colors.white70 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (isMe) ...[
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Center(
                child: Text('😊', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}