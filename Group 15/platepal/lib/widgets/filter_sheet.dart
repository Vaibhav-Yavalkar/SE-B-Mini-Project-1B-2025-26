// lib/widgets/filter_sheet.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_provider.dart';
import '../models/models.dart';

/// Call this to show the filter bottom sheet
Future<void> showFilterSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _FilterSheet(),
  );
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet();

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late BagFilter _local;

  @override
  void initState() {
    super.initState();
    _local = context.read<AppProvider>().filter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: AppTheme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Title row
          Row(
            children: [
              const Text('Filters',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary)),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() => _local = const BagFilter());
                },
                child: const Text('Reset all',
                    style: TextStyle(color: AppTheme.accent,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Veg / Non-Veg ────────────────────────────────────────
          _SectionLabel('Diet Preference'),
          const SizedBox(height: 8),
          Row(
            children: [
              _ToggleChip(
                label: '🟢  Veg Only',
                selected: _local.vegFilter == 'veg',
                selectedColor: AppTheme.success,
                onTap: () => setState(() => _local = _local.vegFilter == 'veg'
                    ? _local.copyWith(clearVeg: true)
                    : _local.copyWith(vegFilter: 'veg')),
              ),
              const SizedBox(width: 10),
              _ToggleChip(
                label: '🔴  Non-Veg',
                selected: _local.vegFilter == 'nonveg',
                selectedColor: AppTheme.error,
                onTap: () => setState(() =>
                    _local = _local.vegFilter == 'nonveg'
                        ? _local.copyWith(clearVeg: true)
                        : _local.copyWith(vegFilter: 'nonveg')),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Max Price ────────────────────────────────────────────
          _SectionLabel('Max Price  ·  ₹${_local.maxPrice.toInt()}'),
          Slider(
            value: _local.maxPrice,
            min: 50,
            max: 500,
            divisions: 9,
            activeColor: AppTheme.primary,
            inactiveColor: AppTheme.divider,
            label: '₹${_local.maxPrice.toInt()}',
            onChanged: (v) => setState(() =>
                _local = _local.copyWith(maxPrice: v)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('₹50', style: TextStyle(fontSize: 11,
                  color: AppTheme.textLight)),
              Text('₹500', style: TextStyle(fontSize: 11,
                  color: AppTheme.textLight)),
            ],
          ),
          const SizedBox(height: 16),

          // ── Max Distance ─────────────────────────────────────────
          _SectionLabel(
              'Max Distance  ·  ${_local.maxDistanceKm.toStringAsFixed(1)} km'),
          Slider(
            value: _local.maxDistanceKm,
            min: 0.5,
            max: 5.0,
            divisions: 9,
            activeColor: AppTheme.primary,
            inactiveColor: AppTheme.divider,
            label: '${_local.maxDistanceKm.toStringAsFixed(1)} km',
            onChanged: (v) => setState(() =>
                _local = _local.copyWith(maxDistanceKm: v)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('0.5 km', style: TextStyle(fontSize: 11,
                  color: AppTheme.textLight)),
              Text('5 km', style: TextStyle(fontSize: 11,
                  color: AppTheme.textLight)),
            ],
          ),
          const SizedBox(height: 20),

          // ── Sort By ──────────────────────────────────────────────
          _SectionLabel('Sort By'),
          const SizedBox(height: 8),
          Row(
            children: [
              _ToggleChip(
                label: '📍 Distance',
                selected: _local.sortBy == 'distance',
                selectedColor: AppTheme.primary,
                onTap: () => setState(() =>
                    _local = _local.copyWith(sortBy: 'distance')),
              ),
              const SizedBox(width: 8),
              _ToggleChip(
                label: '💰 Price',
                selected: _local.sortBy == 'price',
                selectedColor: AppTheme.primary,
                onTap: () => setState(() =>
                    _local = _local.copyWith(sortBy: 'price')),
              ),
              const SizedBox(width: 8),
              _ToggleChip(
                label: '🔥 Discount',
                selected: _local.sortBy == 'discount',
                selectedColor: AppTheme.primary,
                onTap: () => setState(() =>
                    _local = _local.copyWith(sortBy: 'discount')),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Apply ────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                context.read<AppProvider>().updateFilter(_local);
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
          color: AppTheme.textPrimary));
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;
  const _ToggleChip({required this.label, required this.selected,
      required this.selectedColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? selectedColor.withOpacity(0.12) : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? selectedColor : AppTheme.divider,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected ? selectedColor : AppTheme.textSecondary,
            )),
      ),
    );
  }
}
