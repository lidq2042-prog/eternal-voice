import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'import_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 模拟的亲人列表（实际应用中从本地存储读取）
  List<PersonaCard> personas = [
    PersonaCard(
      name: '奶奶',
      emoji: '👵',
      lastMessage: '宝贝，吃饭了吗？',
      messageCount: 128,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F8), 
      appBar: AppBar(
        title: const Text(
          '念',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFD4528A),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: 设置页面
            },
          ),
        ],
      ),
      body: personas.isEmpty
          ? _buildEmptyState()
          : _buildPersonaList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ImportScreen()),
          );
        },
        backgroundColor: const Color(0xFFFFB6C1),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          '添加亲人',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // 空状态提示
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '💝',
            style: TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 24),
          const Text(
            '开始你的念',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD4528A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '添加亲人的聊天记录和语音\n念',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ImportScreen()),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('添加一位亲人'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB6C1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 亲人列表
  Widget _buildPersonaList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: personas.length,
      itemBuilder: (context, index) {
        final persona = personas[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(personaName: persona.name),
                ),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // 头像
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4E9),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Center(
                      child: Text(
                        persona.emoji,
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          persona.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          persona.lastMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // 消息数
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB6C1).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${persona.messageCount}条语音',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFD4528A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// 亲人卡片数据模型
class PersonaCard {
  final String name;
  final String emoji;
  final String lastMessage;
  final int messageCount;

  PersonaCard({
    required this.name,
    required this.emoji,
    required this.lastMessage,
    required this.messageCount,
  });
}