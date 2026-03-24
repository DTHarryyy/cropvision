import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/custom_card.dart';
import '../widgets/section_title.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'library_screen.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildScanButton(context),
                const SizedBox(height: 28),
                const SectionTitle(title: 'Quick Actions'),
                const SizedBox(height: 14),
                _buildQuickActions(context),
                const SizedBox(height: 28),
                const SectionTitle(title: 'Crop Health Tips'),
                const SizedBox(height: 14),
                _buildTipsSection(),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 130,
      floating: true,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good Morning! 🌱',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        const SizedBox(height: 2),
                        Text('How are your crops today?',
                            style: Theme.of(context).textTheme.headlineMedium),
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_rounded,
                        color: AppColors.primaryColor, size: 22),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search diseases, crops...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
            onTap: () {},
          ),
        ),
      ),
    );
  }

  Widget _buildScanButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanScreen())),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryColor, Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Scan a Plant',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 6),
                        Text('Detect diseases instantly',
                            style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.85))),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Tap to Scan',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryColor)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.camera_alt_rounded, size: 64, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction(Icons.menu_book_rounded, 'Library', AppColors.primaryColor,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LibraryScreen()))),
      _QuickAction(Icons.history_rounded, 'History', const Color(0xFF00897B),
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()))),
      _QuickAction(Icons.smart_toy_rounded, 'Assistant', const Color(0xFF1565C0),
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()))),
    ];

    return Row(
      children: actions.map((a) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: CustomCard(
              onTap: a.onTap,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: a.color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(a.icon, color: a.color, size: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(a.label,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTipsSection() {
    const tips = [
      _Tip('Water Early', 'Water plants in the morning to reduce fungal risk.', Icons.water_drop_rounded, Color(0xFF1565C0)),
      _Tip('Check Weekly', 'Inspect leaves weekly for early disease signs.', Icons.search_rounded, Color(0xFF00897B)),
      _Tip('Rotate Crops', 'Rotating crops annually prevents soil-borne diseases.', Icons.loop_rounded, AppColors.primaryColor),
    ];

    return Column(
      children: tips.map((tip) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CustomCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: tip.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(tip.icon, color: tip.color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tip.title,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text(tip.body,
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction(this.icon, this.label, this.color, this.onTap);
}

class _Tip {
  final String title;
  final String body;
  final IconData icon;
  final Color color;
  const _Tip(this.title, this.body, this.icon, this.color);
}
