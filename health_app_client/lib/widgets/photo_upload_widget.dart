// lib/widgets/photo_upload_widget.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploadWidget extends StatelessWidget {
  final XFile? currentImage;
  final Function(XFile?) onImagePicked;

  const PhotoUploadWidget({
    super.key,
    required this.currentImage,
    required this.onImagePicked,
  });

  Future<void> _handleImagePick(BuildContext context) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
      );
      onImagePicked(image);
    } catch (e) {
      onImagePicked(null);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('图片选择失败: ${e.toString().split(':').last.trim()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (currentImage != null) _buildPreviewSection(),
          _buildUploadButton(context),
        ],
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              currentImage!.path,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (ctx, error, _) => Container(
                color: Colors.grey.shade100,
                alignment: Alignment.center,
                child: const Text('图片加载失败'),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => onImagePicked(null),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        foregroundColor: Colors.blue,
      ),
      icon: const Icon(Icons.photo_camera_back, size: 24),
      label: Text(currentImage != null ? '更换图片' : '点击添加诊断图片'),
      onPressed: () => _handleImagePick(context),
    );
  }
}