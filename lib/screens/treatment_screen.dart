import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/custom_card.dart';

class TreatmentScreen extends StatelessWidget {
  const TreatmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text('Treatment Plan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            CustomCard(
              padding: const EdgeInsets.all(20),
              color: AppColors.primaryColor,
              child: Row(
                children: [
                  const Icon(Icons.medical_services_rounded, color: Colors.white, size: 36),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Early Blight',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text('Alternaria solani',
                            style: TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                color: Colors.white.withValues(alpha: 0.8))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _Section(
              icon: Icons.info_outline_rounded,
              color: const Color(0xFF1565C0),
              title: 'Description',
              content: 'Early blight is caused by the fungus Alternaria solani. '
                  'It affects tomatoes, potatoes, and other solanaceous plants. '
                  'Symptoms include dark brown spots with concentric rings (target-board pattern) that appear on older, lower leaves first.',
            ),
            const SizedBox(height: 14),

            _Section(
              icon: Icons.bug_report_rounded,
              color: AppColors.warningColor,
              title: 'Causes',
              content: '• Warm, humid conditions (24–29°C)\n'
                  '• Prolonged leaf wetness from rain or irrigation\n'
                  '• Poor air circulation around plants\n'
                  '• Infected plant debris left in soil\n'
                  '• Weakened plants due to nutrient stress',
            ),
            const SizedBox(height: 14),

            _Section(
              icon: Icons.healing_rounded,
              color: AppColors.primaryColor,
              title: 'Treatment',
              content: '• Apply copper-based fungicides (copper hydroxide)\n'
                  '• Use chlorothalonil or mancozeb every 7–10 days\n'
                  '• Remove and destroy infected leaves immediately\n'
                  '• Ensure plants are properly spaced for airflow\n'
                  '• Avoid overhead irrigation; water at the base',
            ),
            const SizedBox(height: 14),

            _Section(
              icon: Icons.shield_rounded,
              color: const Color(0xFF00897B),
              title: 'Prevention',
              content: '• Use certified disease-free seeds or transplants\n'
                  '• Rotate crops — avoid planting tomatoes in the same spot yearly\n'
                  '• Apply mulch to reduce soil splashing\n'
                  '• Maintain balanced fertilization (avoid nitrogen excess)\n'
                  '• Plant resistant varieties when available',
            ),
            const SizedBox(height: 14),

            _Section(
              icon: Icons.calendar_month_rounded,
              color: const Color(0xFF6A1B9A),
              title: 'Recovery Timeline',
              content: 'With proper treatment, spread can be controlled within 1–2 weeks. '
                  'Full recovery of affected leaves is not possible, but new growth should '
                  'remain healthy. Monitor weekly for at least 3–4 weeks after treatment.',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String content;

  const _Section({
    required this.icon,
    required this.color,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 14),
          Text(content,
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary, height: 1.7)),
        ],
      ),
    );
  }
}
