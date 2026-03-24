import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/history_item.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = 'All';

  static const _filters = ['All', 'Tomato', 'Corn', 'Potato', 'Wheat'];

  static const _items = [
    _HistoryData('Early Blight', 'Tomato', 'Mar 24, 2026', 0.92),
    _HistoryData('Leaf Rust', 'Wheat', 'Mar 22, 2026', 0.87),
    _HistoryData('Gray Leaf Spot', 'Corn', 'Mar 20, 2026', 0.76),
    _HistoryData('Late Blight', 'Potato', 'Mar 18, 2026', 0.94),
    _HistoryData('Bacterial Spot', 'Tomato', 'Mar 15, 2026', 0.68),
    _HistoryData('Northern Leaf Blight', 'Corn', 'Mar 12, 2026', 0.83),
    _HistoryData('Common Rust', 'Corn', 'Mar 10, 2026', 0.79),
    _HistoryData('Septoria Leaf Spot', 'Tomato', 'Mar 8, 2026', 0.91),
  ];

  List<_HistoryData> get _filtered => _filter == 'All'
      ? _items
      : _items.where((i) => i.cropType == _filter).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Scan History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded),
            onPressed: () {},
            tooltip: 'Clear history',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filters.length,
              itemBuilder: (_, i) {
                final isSelected = _filter == _filters[i];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_filters[i]),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _filter = _filters[i]),
                    selectedColor: AppColors.primaryColor,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          // Count
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Row(
              children: [
                Text('${_filtered.length} results',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),

          // List
          Expanded(
            child: _filtered.isEmpty
                ? _buildEmpty()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final item = _filtered[i];
                      return HistoryItem(
                        diseaseName: item.diseaseName,
                        cropType: item.cropType,
                        date: item.date,
                        confidence: item.confidence,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const ResultScreen())),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 72, color: AppColors.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          const Text('No scans found', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          const Text('Try selecting a different filter',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _HistoryData {
  final String diseaseName;
  final String cropType;
  final String date;
  final double confidence;
  const _HistoryData(this.diseaseName, this.cropType, this.date, this.confidence);
}
