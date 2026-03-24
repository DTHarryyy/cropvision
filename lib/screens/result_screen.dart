import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';
import 'treatment_screen.dart';
import 'scan_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Scan Result'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image preview
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 220,
                width: double.infinity,
                color: AppColors.secondaryColor.withValues(alpha: 0.25),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.eco_rounded, size: 72, color: AppColors.primaryColor),
                    SizedBox(height: 8),
                    Text('Scanned Image', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Disease card
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Early Blight',
                                style: Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 4),
                            const Text('Alternaria solani',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      _ConfidenceBadge(confidence: 0.92),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.dividerColor),
                  const SizedBox(height: 16),
                  _InfoRow(Icons.grass_rounded, 'Crop', 'Tomato'),
                  const SizedBox(height: 10),
                  _InfoRow(Icons.warning_amber_rounded, 'Severity', 'Moderate', color: AppColors.warningColor),
                  const SizedBox(height: 10),
                  _InfoRow(Icons.calendar_today_rounded, 'Scanned', 'Mar 24, 2026'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Description
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('About this Disease',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  Text(
                    'Early blight is a common fungal disease caused by Alternaria solani. '
                    'It primarily affects tomatoes and potatoes, producing dark brown spots with concentric rings on older leaves.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            CustomButton(
              label: 'View Treatment Plan',
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const TreatmentScreen())),
              icon: Icons.medical_services_rounded,
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Scan Again',
              onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const ScanScreen())),
              variant: ButtonVariant.outlined,
              icon: Icons.camera_alt_rounded,
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Save Result',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Result saved to history'),
                    backgroundColor: AppColors.primaryColor,
                  ),
                );
              },
              variant: ButtonVariant.ghost,
              icon: Icons.bookmark_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfidenceBadge extends StatelessWidget {
  final double confidence;
  const _ConfidenceBadge({required this.confidence});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text('${(confidence * 100).toInt()}%',
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.errorColor)),
          const Text('confidence',
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _InfoRow(this.icon, this.label, this.value, {this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color ?? AppColors.primaryColor),
        const SizedBox(width: 10),
        Text('$label: ', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        Text(value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color ?? AppColors.textPrimary)),
      ],
    );
  }
}
