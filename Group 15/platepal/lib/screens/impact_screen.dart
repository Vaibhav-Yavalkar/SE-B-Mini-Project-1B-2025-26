// lib/screens/impact_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../app_theme.dart';
import '../app_provider.dart';
import '../models/models.dart';

class ImpactScreen extends StatelessWidget {
  const ImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final impact = provider.impact;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Environmental Impact 🌱',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Your personal contribution to the planet',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildHeroBanner(context, impact)),
          SliverToBoxAdapter(child: _buildCalculationInfo(context, impact)),
          SliverToBoxAdapter(child: _buildWeeklyChart(context, impact)),
          SliverToBoxAdapter(child: _buildAchievements(context)),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context, ImpactStats impact) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primaryDark, AppTheme.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Text(
              'CO₂ PREVENTED',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${impact.co2Prevented.toStringAsFixed(2)} kg',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _HeroStat(
                  value: '${impact.totalKgSaved.toStringAsFixed(1)}',
                  unit: 'kg',
                  label: 'Food Rescued',
                ),
                Container(
                  width: 1, height: 30,
                  color: Colors.white24,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                _HeroStat(
                  value: '${impact.bagsSaved}',
                  unit: '',
                  label: 'Bags Saved',
                ),
                Container(
                  width: 1, height: 30,
                  color: Colors.white24,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                _HeroStat(
                  value: '₹${impact.moneySaved.toInt()}',
                  unit: '',
                  label: 'Money Saved',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationInfo(BuildContext context, ImpactStats impact) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 16, color: AppTheme.primary),
                SizedBox(width: 8),
                Text(
                  'How we calculate CO₂',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'For every 1 kg of food saved from being wasted, we prevent approximately 2.5 kg of CO₂ emissions from entering the atmosphere during production and decomposition.',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Formula', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                Text(
                  '${impact.totalKgSaved.toStringAsFixed(1)} kg × 2.5 = ${impact.co2Prevented.toStringAsFixed(2)} kg CO₂',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context, ImpactStats impact) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Food Saved (kg)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 7,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final days = impact.weeklyData;
                          if (value.toInt() < days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                days[value.toInt()].day,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: impact.weeklyData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.kg,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                          color: AppTheme.primary,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements(BuildContext context) {
    final achievements = [
      ('🌱', 'First Save', 'Reserved first bag', true),
      ('🔥', 'On Fire', '5 bags in a row', true),
      ('🌍', 'Eco Hero', '10kg food saved', true),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Milestones',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: achievements.map((a) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: Column(
                    children: [
                      Text(a.$1, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 8),
                      Text(a.$2, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String unit;
  final String label;
  const _HeroStat({required this.value, required this.unit, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value $unit',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white60,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
