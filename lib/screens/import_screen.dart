import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _chatController = TextEditingController();
  int _currentStep = 0;
  String _selectedRelationship = '奶奶/外婆';
  
  final List<String> _relationships = [
    '奶奶/外婆',
    '爷爷/外公',
    '爸爸',
    '妈妈',
    '其他',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F8),
      appBar: AppBar(
        title: const Text('添加亲人'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            _saveAndReturn();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB6C1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentStep < 2 ? '下一步' : '完成',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('上一步'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          // 步骤1：基本信息
          Step(
            title: const Text('基本信息'),
            subtitle: const Text('设置亲人的称呼'),
            content: _buildBasicInfoStep(),
            isActive: _currentStep >= 0,
          ),
          
          // 步骤2：导入聊天记录
          Step(
            title: const Text('导入聊天记录'),
            subtitle: const Text('从微信复制聊天内容'),
            content: _buildImportChatStep(),
            isActive: _currentStep >= 1,
          ),
          
          // 步骤3：导入语音
          Step(
            title: const Text('导入语音'),
            subtitle: const Text('让思念有声'),
            content: _buildImportVoiceStep(),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }

  // 步骤1：基本信息
  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 称呼输入
        const Text(
          '亲人的称呼',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: '例如：奶奶、外婆、爷爷...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 20),
        
        // 关系选择
        const Text(
          '与你的关系',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _relationships.map((rel) {
            final isSelected = _selectedRelationship == rel;
            return ChoiceChip(
              label: Text(rel),
              selected: isSelected,
              selectedColor: const Color(0xFFFFB6C1),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
              ),
              onSelected: (selected) {
                setState(() => _selectedRelationship = rel);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        
        // 提示信息
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: Color(0xFFD4528A),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '提示：称呼会用于AI回复的开头，建议使用亲人在世时的称呼',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 步骤2：导入聊天记录
  Widget _buildImportChatStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 方式1：截图识别
        _buildImportOption(
          icon: Icons.camera_alt_outlined,
          title: '截图识别',
          subtitle: '从微信截图自动识别聊天记录',
          onTap: () {
            // TODO: 实现截图OCR功能
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('截图识别功能开发中...')),
            );
          },
        ),
        const SizedBox(height: 12),
        
        // 方式2：手动粘贴
        _buildImportOption(
          icon: Icons.content_paste,
          title: '手动粘贴',
          subtitle: '从微信复制聊天文本，粘贴到这里',
          onTap: () {
            _showPasteDialog();
          },
        ),
        const SizedBox(height: 12),
        
        // 方式3：通知监听
        _buildImportOption(
          icon: Icons.notifications_outlined,
          title: '通知监听',
          subtitle: '自动记录新收到的微信消息',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('需要在设置中开启通知权限')),
            );
          },
        ),
        const SizedBox(height: 20),
        
        // 操作指南
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📋 如何从微信复制聊天记录？',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '1. 打开微信，进入与亲人的聊天\n'
                '2. 长按任意一条消息\n'
                '3. 选择"多选"\n'
                '4. 勾选想要保存的消息\n'
                '5. 点击左下角"转发" → "合并转发"\n'
                '6. 发送到"文件传输助手"\n'
                '7. 复制内容，粘贴到下面的输入框',
                style: TextStyle(
                  color: Colors.blue[700],
                  height: 1.8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // 输入框
        TextField(
          controller: _chatController,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: '在这里粘贴聊天记录...\n\n例如：\n奶奶：宝贝吃饭了吗\n我：吃了\n奶奶：吃的什么呀',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  // 步骤3：导入语音
  Widget _buildImportVoiceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 说明
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.mic,
                size: 48,
                color: Color(0xFFD4528A),
              ),
              const SizedBox(height: 12),
              const Text(
                '让思念有声',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '导入亲人的语音消息，AI将学习并模仿亲人的声音',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        // 导入语音按钮
        ElevatedButton.icon(
          onPressed: () {
            // TODO: 选择语音文件
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('请将语音文件保存到手机后选择')),
            );
          },
          icon: const Icon(Icons.upload_file),
          label: const Text('选择语音文件'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFB6C1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        // 语音导入指南
        ExpansionTile(
          title: const Text('如何获取亲人的语音？'),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '方法一：从微信保存\n'
                '1. 打开微信聊天\n'
                '2. 长按语音消息\n'
                '3. 选择"收藏"或"保存"\n\n'
                '方法二：手机录音\n'
                '1. 如果有通话录音\n'
                '2. 找到录音文件\n'
                '3. 导入到这里\n\n'
                '建议：\n'
                '• 语音越清晰越好\n'
                '• 总时长建议3-10分钟\n'
                '• 包含不同情绪的语音',
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // 已导入数量
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('已导入语音数量'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '0 条',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // 提示
        Text(
          '💡 提示：语音导入是可选的，即使没有语音，也可以使用文字聊天功能',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // 导入选项组件
  Widget _buildImportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE4E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFD4528A),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // 显示粘贴对话框
  void _showPasteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('粘贴聊天记录'),
        content: const Text('请从微信复制聊天内容后，在输入框中粘贴'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }

  // 保存并返回
  void _saveAndReturn() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入亲人的称呼')),
      );
      return;
    }

    // TODO: 保存到本地存储
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('添加成功！'),
        backgroundColor: Colors.green,
      ),
    );
    
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _chatController.dispose();
    super.dispose();
  }
}