import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/meal_item_card.dart';

class RecommendationDetailScreen extends StatefulWidget {
  const RecommendationDetailScreen({super.key});

  @override
  State<RecommendationDetailScreen> createState() => _RecommendationDetailScreenState();
}

class _RecommendationDetailScreenState extends State<RecommendationDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Rekomendasi Makanan'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Sarapan'),
            Tab(text: 'Makan Siang'),
            Tab(text: 'Snack'),
            Tab(text: 'Makan Malam'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMealList(AppConstants.breakfastMenu, 'Rekomendasi Sarapan Sehat'),
          _buildMealList(AppConstants.lunchMenu, 'Rekomendasi Makan Siang Berserat'),
          _buildMealList(AppConstants.snackMenu, 'Rekomendasi Snack Ringan'),
          _buildMealList(AppConstants.dinnerMenu, 'Rekomendasi Malam Bernutrisi'),
        ],
      ),
    );
  }

  Widget _buildMealList(List<Map<String, dynamic>> menu, String title) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...menu.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: MealItemCard(
              emoji: item['icon'] ?? '🍽️',
              name: item['name'] ?? 'Makanan',
              calories: (item['calories'] as num).toDouble(),
            ),
          );
        }),
      ],
    );
  }
}
