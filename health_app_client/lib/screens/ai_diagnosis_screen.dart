// lib/screens/ai_diagnosis_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/photo_upload_widget.dart';
import '../widgets/questionnaire_widget.dart';
import '../services/ai_diagnosis_service.dart';
import '../providers/diagnosis_provider.dart';
import '../constants/colors.dart';

class AIDiagnosisScreen extends StatefulWidget {
  const AIDiagnosisScreen({super.key});

  @override
  State<AIDiagnosisScreen> createState() => _AIDiagnosisScreenState();
}

class _AIDiagnosisScreenState extends State<AIDiagnosisScreen> {
  Map<String, dynamic> _answers = {}; // 改为dynamic类型支持多类型答案
  bool _isDiagnosing = false;

  Future<void> _performDiagnosis() async {
    final diagnosisProvider = Provider.of<DiagnosisProvider>(context, listen: false);
    final imageFile = diagnosisProvider.pickedImage;

    if (imageFile == null || _answers.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请选择图片并完成问卷'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isDiagnosing = true);

    try {
      final result = await AIDiagnosisService.diagnose(
        imageFile,
        _answers.cast<String, String>(), // 确保参数类型匹配
      );

      if (!mounted) return;
      _showDiagnosisResult(result);
    } catch (e) {
      _handleDiagnosisError(e);
    } finally {
      if (mounted) {
        setState(() => _isDiagnosing = false);
      }
    }
  }

  void _showDiagnosisResult(Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('诊断结果'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('诊断结论: ${result['diagnosis']}'),
            const SizedBox(height: 10),
            Text('可信度: ${result['confidence']}%'),
            const SizedBox(height: 15),
            Text('建议措施: ${result['recommendation']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _handleDiagnosisError(dynamic error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('诊断失败: ${error.toString().split(':').last.trim()}'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI智能诊断'),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Consumer<DiagnosisProvider>(
                builder: (context, provider, child) => PhotoUploadWidget(
                  currentImage: provider.pickedImage,
                  onImagePicked: (image) => provider.setImage(image),
                ),
              ),
              const SizedBox(height: 24),
              QuestionnaireWidget(
                questions: const [], // 添加必需参数
                onAnswersUpdated: (answers) => setState(() => _answers = answers),
              ),
              const SizedBox(height: 32),
              _buildDiagnosisButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiagnosisButton() {
    return ElevatedButton.icon(
      icon: _isDiagnosing
          ? const SizedBox.shrink()
          : const Icon(Icons.medical_services, size: 24),
      label: _isDiagnosing
          ? const CircularProgressIndicator()
          : const Text('开始智能诊断', style: TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: _isDiagnosing ? null : _performDiagnosis,
    );
  }
}