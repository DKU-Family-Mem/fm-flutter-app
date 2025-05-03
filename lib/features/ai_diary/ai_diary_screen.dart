import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import 'ai_diary_provider.dart';
import '../diary/diary_provider.dart';
import 'widgets/ai_result_box.dart';

class AIDiaryScreen extends StatefulWidget {
  final List<String> chatMessages;
  final String userId;

  const AIDiaryScreen({
    Key? key,
    required this.chatMessages,
    required this.userId,
  }) : super(key: key);

  @override
  State<AIDiaryScreen> createState() => _AIDiaryScreenState();
}

class _AIDiaryScreenState extends State<AIDiaryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final List<String> _tags = [];
  final TextEditingController _tagController = TextEditingController();
  late final AIDiaryProvider _aiDiaryProvider;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _aiDiaryProvider = Provider.of<AIDiaryProvider>(context, listen: false);
    _generateDiary();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _generateDiary() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      await _aiDiaryProvider.generateDiaryFromChat(widget.chatMessages, widget.userId);
      
      // 제목 자동 생성 (채팅 내용에서 키워드 추출)
      _titleController.text = '오늘의 추억';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('다이어리 생성 중 오류가 발생했습니다: $e')),
      );
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future<void> _saveDiary() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목을 입력해주세요')),
      );
      return;
    }

    try {
      await _aiDiaryProvider.saveAIDiary(
        userId: widget.userId,
        title: _titleController.text,
        content: _aiDiaryProvider.generatedContent,
        tags: _tags.isEmpty ? null : _tags,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AI 다이어리가 저장되었습니다')),
        );
        Navigator.pop(context, true); // 저장 완료 후 이전 화면으로 이동
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('다이어리 저장 중 오류가 발생했습니다: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 다이어리 생성'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Consumer<AIDiaryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading || _isGenerating) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('AI가 당신의 대화에서 의미있는 순간을 찾고 있어요...'),
                ],
              ),
            );
          }

          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(provider.errorMessage),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _generateDiary,
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: '다이어리 제목',
                    hintText: '이 추억을 대표하는 제목을 입력하세요',
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'AI가 생성한 다이어리',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                AIResultBox(content: provider.generatedContent),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tagController,
                        decoration: const InputDecoration(
                          labelText: '태그 추가',
                          hintText: '태그를 입력하고 추가 버튼을 누르세요',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addTag(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle),
                      color: AppColors.accentColor,
                      onPressed: _addTag,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      deleteIcon: const Icon(Icons.cancel, size: 16),
                      onDeleted: () => _removeTag(tag),
                      backgroundColor: AppColors.primaryLightColor,
                      labelStyle: const TextStyle(color: AppColors.primaryDarkColor),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveDiary,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      '다이어리 저장하기',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 