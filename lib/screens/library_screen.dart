import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/custom_card.dart';
import 'treatment_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  static const _categories = ['All', 'Tomato', 'Corn', 'Potato', 'Wheat', 'Rice'];

  static const _diseases = [
    _DiseaseData('Early Blight', 'Tomato', 'Alternaria solani', 'Moderate', AppColors.warningColor),
    _DiseaseData('Late Blight', 'Potato', 'Phytophthora infestans', 'Severe', AppColors.errorColor),
    _DiseaseData('Leaf Rust', 'Wheat', 'Puccinia triticina', 'Moderate', AppColors.warningColor),
    _DiseaseData('Gray Leaf Spot', 'Corn', 'Cercospora zeae-maydis', 'Moderate', AppColors.warningColor),
    _DiseaseData('Bacterial Spot', 'Tomato', 'Xanthomonas campestris', 'Low', AppColors.successColor),
    _DiseaseData('Northern Leaf Blight', 'Corn', 'Exserohilum turcicum', 'Severe', AppColors.errorColor),
    _DiseaseData('Common Rust', 'Corn', 'Puccinia sorghi', 'Low', AppColors.successColor),
    _DiseaseData('Septoria Leaf Spot', 'Tomato', 'Septoria lycopersici', 'Moderate', AppColors.warningColor),
    _DiseaseData('Brown Spot', 'Rice', 'Cochliobolus miyabeanus', 'Moderate', AppColors.warningColor),
    _DiseaseData('Blast', 'Rice', 'Magnaporthe oryzae', 'Severe', AppColors.errorColor),
  ];

  List<_DiseaseData> get _filtered {
    return _diseases.where((d) {
      final matchesCategory = _selectedCategory == 'All' || d.cropType == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.cropType.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text('Disease Library')),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search diseases or crops...',
                prefixIcon: Icon(Icons.search_rounded),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),

          // Categories
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final isSelected = _selectedCategory == _categories[i];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_categories[i]),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = _categories[i]),
                    selectedColor: AppColors.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Results count
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Row(
              children: [
                Text('${_filtered.length} diseases found',
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
                    itemBuilder: (_, i) => _DiseaseCard(
                      disease: _filtered[i],
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const TreatmentScreen())),
                    ),
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
          Icon(Icons.search_off_rounded, size: 72, color: AppColors.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          const Text('No diseases found', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _DiseaseCard extends StatelessWidget {
  final _DiseaseData disease;
  final VoidCallback onTap;
  const _DiseaseCard({required this.disease, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: disease.severityColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.local_florist_rounded, color: disease.severityColor, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(disease.name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(disease.pathogen,
                    style: const TextStyle(
                        fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _Tag(disease.cropType, AppColors.primaryColor),
                    const SizedBox(width: 6),
                    _Tag(disease.severity, disease.severityColor),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _DiseaseData {
  final String name;
  final String cropType;
  final String pathogen;
  final String severity;
  final Color severityColor;
  const _DiseaseData(this.name, this.cropType, this.pathogen, this.severity, this.severityColor);
}
