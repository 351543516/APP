// lib/utils/color_utils.dart
import 'package:flutter/material.dart'; // ✅ 必须添加的导入

/// 自定义透明度工具（解决withOpacity警告）
Color withCustomOpacity(int baseColor, double opacity) {
  final alpha = (opacity.clamp(0.0, 1.0) * 255).round(); // 计算透明度值
  return Color(baseColor).withAlpha(alpha); // 生成新颜色
}