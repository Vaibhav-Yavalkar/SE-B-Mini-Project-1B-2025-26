// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_provider.dart';
import '../widgets/bag_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/filter_sheet.dart';
import 'bag_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final hasActiveFilter = provider.filter.vegFilter != null ||
        provider.filter.maxPrice < 500 ||
        provider.filter.maxDistanceKm < 5.0 ||
        provider.filter.sortBy != 'distance';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context, provider),
          _buildSearchBar(context, provider, hasActiveFilter),
          if (hasActiveFilter) _buildActiveFilterBar(context, provider),
          _buildPromoBanner(context),
          _buildCategoryRow(context, provider),
          _buildBagList(context, provider),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildAppBar(
      BuildContext context, AppProvider provider) {
    return SliverToBoxAdapter(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good evening 👋',
                      style: TextStyle(fontSize: 13,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  const Text('Discover Surprise Bags',
                      style: TextStyle(fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.5)),
                ],
              ),
              const Spacer(),
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.primaryLight],
                      begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                    child: Text('👤', style: TextStyle(fontSize: 18))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSearchBar(BuildContext context,
      AppProvider provider, bool hasActiveFilter) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: provider.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Near me restaurants, bakerys...',
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: AppTheme.textLight, size: 20),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Filter button with badge
            GestureDetector(
              onTap: () => showFilterSheet(context),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(
                      color: hasActiveFilter
                          ? AppTheme.primary
                          : AppTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: hasActiveFilter
                          ? AppTheme.primary
                          : AppTheme.divider),
                    ),
                    child: Icon(Icons.tune_rounded,
                        color: hasActiveFilter
                            ? Colors.white
                            : AppTheme.textSecondary,
                        size: 20),
                  ),
                  if (hasActiveFilter)
                    Positioned(
                      top: -4, right: -4,
                      child: Container(
                        width: 12, height: 12,
                        decoration: const BoxDecoration(
                            color: AppTheme.accent, shape: BoxShape.circle),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Active filter pills row
  SliverToBoxAdapter _buildActiveFilterBar(
      BuildContext context, AppProvider provider) {
    final f = provider.filter;
    final pills = <String>[];
    if (f.vegFilter == 'veg') pills.add('🟢 Veg');
    if (f.vegFilter == 'nonveg') pills.add('🔴 Non-Veg');
    if (f.maxPrice < 500) pills.add('≤ ₹${f.maxPrice.toInt()}');
    if (f.maxDistanceKm < 5.0)
      pills.add('≤ ${f.maxDistanceKm.toStringAsFixed(1)} km');
    if (f.sortBy != 'distance')
      pills.add(f.sortBy == 'price' ? 'Sort: Price' : 'Sort: Discount');

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Row(
          children: [
            ...pills.map((p) => Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              ),
              child: Text(p,
                  style: const TextStyle(fontSize: 11,
                      fontWeight: FontWeight.w700, color: AppTheme.primary)),
            )),
            const Spacer(),
            GestureDetector(
              onTap: provider.resetFilter,
              child: const Text('Clear all',
                  style: TextStyle(fontSize: 11,
                      fontWeight: FontWeight.w700, color: AppTheme.accent)),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildPromoBanner(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppTheme.primaryDark, AppTheme.primary],
                begin: Alignment.centerLeft, end: Alignment.centerRight),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Stack(
            children: [
              Positioned(right: -10, top: -10,
                  child: Container(width: 130, height: 130,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          shape: BoxShape.circle))),
              Positioned(right: 30, bottom: -30,
                  child: Container(width: 80, height: 80,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          shape: BoxShape.circle))),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppTheme.accent,
                          borderRadius: BorderRadius.circular(6)),
                      child: const Text('TODAY ONLY',
                          style: TextStyle(color: Colors.white, fontSize: 10,
                              fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                    ),
                    const SizedBox(height: 6),
                    const Text('Save up to 70% on\nsurprise food bags 🎉',
                        style: TextStyle(color: Colors.white, fontSize: 16,
                            fontWeight: FontWeight.w800, height: 1.2)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildCategoryRow(
      BuildContext context, AppProvider provider) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text('Categories',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary, letterSpacing: -0.2)),
          ),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: provider.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = provider.categories[i];
                return CategoryChip(
                  label: cat,
                  isSelected: provider.selectedCategory == cat,
                  onTap: () => provider.setCategory(cat),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  SliverList _buildBagList(
      BuildContext context, AppProvider provider) {
    final bags = provider.bags;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text('${bags.length} bags available',
                      style: const TextStyle(fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary, letterSpacing: -0.2)),
                  const Spacer(),
                  Text(
                    _sortLabel(provider.filter.sortBy),
                    style: const TextStyle(fontSize: 12,
                        color: AppTheme.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }
          if (bags.isEmpty && index == 1) {
            return _buildEmpty();
          }
          if (index > bags.length) return null;
          final bag = bags[index - 1];
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: BagCard(
              bag: bag,
              userLat: provider.userLat,
              userLng: provider.userLng,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(
                      builder: (_) => BagDetailScreen(bagId: bag.id))),
            ),
          );
        },
        childCount: bags.isEmpty ? 2 : bags.length + 1,
      ),
    );
  }

  String _sortLabel(String sortBy) {
    switch (sortBy) {
      case 'price': return 'Sorted by price ↑';
      case 'discount': return 'Sorted by discount ↑';
      default: return 'Sorted by distance ↑';
    }
  }

  Widget _buildEmpty() {
    return const Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Text('😕', style: TextStyle(fontSize: 48)),
          SizedBox(height: 12),
          Text('No bags match your filters',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          SizedBox(height: 6),
          Text('Try adjusting your filters or expand the distance',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
