import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class HistoryItem extends StatelessWidget {
  final String diseaseName;
  final String cropType;
  final String date;
  final double confidence;
  final VoidCallback? onTap;

  const HistoryItem({
    super.key,
    required this.diseaseName,
    required this.cropType,
    required this.date,
    required this.confidence,
    this.onTap,
  });

  Color get _confidenceColor {
    if (confidence >= 0.85) return AppColors.errorColor;
    if (confidence >= 0.60) return AppColors.warningColor;
    return AppColors.successColor;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardColor,
      borderRadius: BorderRadius.circular(14),
      elevation: 1,
      shadowColor: AppColors.primaryColor.withValues(alpha: 0.06),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image placeholder
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.eco_rounded, color: AppColors.primaryColor, size: 30),
              ),
              const SizedBox(width: 14),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      diseaseName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cropType,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              // Confidence badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _confidenceColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(confidence * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _confidenceColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
