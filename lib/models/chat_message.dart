class ChatMessage {
  final String id;
  final String sender;      // 发送者名称
  final String content;     // 消息内容
  final DateTime timestamp; // 时间戳
  final bool isFromUser;    // 是否是用户发送的
  final String? voiceUrl;   // 语音文件地址（可选）

  ChatMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.isFromUser,
    this.voiceUrl,
  });

  // 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isFromUser': isFromUser,
      'voiceUrl': voiceUrl,
    };
  }

  // 从 JSON 创建
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      sender: json['sender'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      isFromUser: json['isFromUser'],
      voiceUrl: json['voiceUrl'],
    );
  }
}

// 亲人信息
class Persona {
  final String id;
  final String name;          // 称呼，如"奶奶"
  final String relationship;  // 关系
  final String? avatarPath;   // 头像路径
  final List<String> commonPhrases; // 常用语
  final String personality;   // 性格描述
  final String userNickname;  // 对用户的称呼

  Persona({
    required this.id,
    required this.name,
    required this.relationship,
    this.avatarPath,
    this.commonPhrases = const [],
    this.personality = '',
    this.userNickname = '宝贝',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relationship': relationship,
      'avatarPath': avatarPath,
      'commonPhrases': commonPhrases,
      'personality': personality,
      'userNickname': userNickname,
    };
  }

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: json['id'],
      name: json['name'],
      relationship: json['relationship'],
      avatarPath: json['avatarPath'],
      commonPhrases: List<String>.from(json['commonPhrases'] ?? []),
      personality: json['personality'] ?? '',
      userNickname: json['userNickname'] ?? '宝贝',
    );
  }
}