// lib/screens/bag_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_provider.dart';
import '../models/models.dart';
import 'tracking_screen.dart';

class BagDetailScreen extends StatefulWidget {
  final String bagId;
  const BagDetailScreen({super.key, required this.bagId});

  @override
  State<BagDetailScreen> createState() => _BagDetailScreenState();
}

class _BagDetailScreenState extends State<BagDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final bag = provider.getBagById(widget.bagId);
    if (bag == null) return const Scaffold(body: Center(child: Text('Not found')));

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildHero(context, bag),
              SliverToBoxAdapter(child: _buildContent(context, bag, provider)),
            ],
          ),
          Positioned(top: 0, left: 0, right: 0, child: _buildTopBar(context)),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: _buildReserveBar(context, bag, provider),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              ),
            ),
            const Spacer(),
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]),
              child: const Icon(Icons.share_rounded, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, FoodBag bag) {
    return SliverAppBar(
      expandedHeight: 260,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(bag.restaurantImage, fit: BoxFit.cover),
            Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.5)]))),
            Positioned(bottom: 16, left: 20, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(8)), child: Text('-${bag.discountPercent.toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)))),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, FoodBag bag, AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(bag.restaurantName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
          const SizedBox(height: 6),
          Row(children: [const Icon(Icons.location_on_rounded, size: 14, color: AppTheme.textSecondary), const SizedBox(width: 4), Text(bag.address, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary))]),
          const SizedBox(height: 20),
          Row(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('₹${bag.currentOriginalPrice.toInt()}', style: const TextStyle(fontSize: 14, color: AppTheme.textLight, decoration: TextDecoration.lineThrough)),
                Text('₹${bag.currentDiscountedPrice.toInt()}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppTheme.primary)),
              ]),
              const Spacer(),
              _AvailabilityPill(bag: bag),
            ],
          ),
          const SizedBox(height: 24),
          
          _SectionCard(
            title: 'Customize Your Bag', 
            icon: '🍱', 
            child: Column(
              children: bag.items.map((item) {
                return CheckboxListTile(
                  title: Text(item.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text('Original: ₹${item.originalPrice.toInt()}', style: const TextStyle(fontSize: 12)),
                  value: item.isSelected,
                  activeColor: AppTheme.primary,
                  onChanged: (bool? val) {
                    provider.toggleItemSelection(bag.id, item.id);
                  },
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Impact Details', 
            icon: '🌱', 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Effective Weight: ${bag.effectiveWeightKg.toStringAsFixed(2)} kg', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                const SizedBox(height: 4),
                Text('By saving this selection, you prevent ${(bag.effectiveWeightKg * 2.5).toStringAsFixed(2)} kg of CO2 emissions!', 
                  style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReserveBar(BuildContext context, FoodBag bag, AppProvider provider) {
    final isReserved = bag.isReserved;
    final anySelected = bag.items.any((i) => i.isSelected);

    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(color: AppTheme.surface, border: Border(top: BorderSide(color: AppTheme.divider))),
      child: ElevatedButton(
        onPressed: (isReserved || !anySelected) ? null : () => _showPaymentSheet(context, bag, provider),
        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 54), backgroundColor: isReserved ? AppTheme.success : AppTheme.primary),
        child: Text(
          !anySelected ? 'Select at least one item' : isReserved ? 'Successfully Reserved ✓' : 'Reserve for ₹${bag.currentDiscountedPrice.toInt()}', 
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)
        ),
      ),
    );
  }

  void _showPaymentSheet(BuildContext context, FoodBag bag, AppProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose Payment Method', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            _PaymentTile(icon: Icons.payments_rounded, title: 'Cash on Pickup', onTap: () => _confirmOrder(context, bag, provider, 'Cash')),
            const SizedBox(height: 12),
            _PaymentTile(icon: Icons.qr_code_scanner_rounded, title: 'UPI / Google Pay', onTap: () => _confirmOrder(context, bag, provider, 'UPI')),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _confirmOrder(BuildContext context, FoodBag bag, AppProvider provider, String method) {
    provider.reserveBag(bag, method);
    Navigator.pop(context); // Close sheet
    _showSuccessDialog(context, bag, provider);
  }

  void _showSuccessDialog(BuildContext context, FoodBag bag, AppProvider provider) {
    final res = provider.reservations.last;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text('Order Confirmed!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text('Your customized bag from ${bag.restaurantName} is ready.', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TrackingScreen(reservationId: res.id)));
                },
                child: const Text('Track Live Delivery'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  provider.setCurrentIndex(2); // Set tab to "My Bags"
                  Navigator.pop(context); // Go back to Home Shell
                },
                child: const Text('View My Bags', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _PaymentTile({required this.icon, required this.title, required this.onTap});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: AppTheme.primary),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
    trailing: const Icon(Icons.chevron_right_rounded),
    onTap: onTap,
    tileColor: AppTheme.surfaceVariant,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}

class _AvailabilityPill extends StatelessWidget {
  final FoodBag bag;
  const _AvailabilityPill({required this.bag});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(color: AppTheme.success.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
    child: Text('${bag.available} bags left', style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.success)),
  );
}

class _SectionCard extends StatelessWidget {
  final String title; final String icon; final Widget child;
  const _SectionCard({required this.title, required this.icon, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.divider)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text(icon), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.w800))]),
      const SizedBox(height: 8), child,
    ]),
  );
}
