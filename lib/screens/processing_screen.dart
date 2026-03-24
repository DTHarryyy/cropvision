import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'result_screen.dart';

class ProcessingScreen extends StatefulWidget {
  final String? imagePath;
  const ProcessingScreen({super.key, this.imagePath});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;
  int _step = 0;

  static const _steps = [
    'Loading image...',
    'Detecting leaf region...',
    'Analyzing disease patterns...',
    'Generating diagnosis...',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _runSteps();
  }

  Future<void> _runSteps() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      setState(() => _step = i);
    }
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a, __) => const ResultScreen(),
        transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _pulse,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 110,
                      height: 110,
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor.withValues(alpha: 0.3),
                        strokeWidth: 6,
                      ),
                    ),
                    const Icon(Icons.eco_rounded, size: 52, color: AppColors.primaryColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text('Analyzing Plant',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _steps[_step],
                key: ValueKey(_step),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Column(
                children: List.generate(_steps.length, (i) {
                  final isDone = i < _step;
                  final isCurrent = i == _step;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone
                                ? AppColors.primaryColor
                                : isCurrent
                                    ? AppColors.primaryColor.withValues(alpha: 0.2)
                                    : AppColors.dividerColor,
                          ),
                          child: isDone
                              ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                              : isCurrent
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: Padding(
                                        padding: EdgeInsets.all(4),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    )
                                  : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _steps[i],
                          style: TextStyle(
                            fontSize: 13,
                            color: isDone || isCurrent
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
