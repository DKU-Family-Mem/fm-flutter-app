import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../diary_provider.dart';
import '../widgets/diary_card.dart';
import 'diary_detail_screen.dart';

class DiaryListScreen extends StatefulWidget {
  const DiaryListScreen({Key? key}) : super(key: key);

  @override
  State<DiaryListScreen> createState() => _DiaryListScreenState();
}

class _DiaryListScreenState extends State<DiaryListScreen> {
  late final DiaryProvider _diaryProvider;
  final String _userId = 'current_user_id'; // 실제 구현 시 인증에서 가져오기

  @override
  void initState() {
    super.initState();
    _diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    _loadDiaries();
  }

  Future<void> _loadDiaries() async {
    await _diaryProvider.loadDiaries(_userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 일기장'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: _loadDiaries,
        child: Consumer<DiaryProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.diaries.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.book,
                      size: 80,
                      color: AppColors.primaryLightColor,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '아직 작성된 일기가 없습니다',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // 새 일기 작성 화면으로 이동
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateDiaryScreen(userId: _userId)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('첫 일기 작성하기'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.diaries.length,
              itemBuilder: (context, index) {
                final diary = provider.diaries[index];
                return GestureDetector(
                  onTap: () {
                    // 다이어리 상세 화면으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiaryDetailScreen(diaryId: diary.id),
                      ),
                    );
                  },
                  child: DiaryCard(diary: diary),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 다이어리 생성 화면으로 이동
          // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateDiaryScreen(userId: _userId)));
        },
        backgroundColor: AppColors.accentColor,
        child: const Icon(Icons.add),
      ),
    );
  }
} 