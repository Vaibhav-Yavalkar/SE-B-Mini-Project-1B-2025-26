// lib/widgets/bag_card.dart

import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/models.dart';

class BagCard extends StatelessWidget {
  final FoodBag bag;
  final double userLat;
  final double userLng;
  final VoidCallback onTap;

  const BagCard({
    super.key,
    required this.bag,
    required this.userLat,
    required this.userLng,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSoldOut = bag.available == 0;
    final distance = bag.distanceFrom(userLat, userLng);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: bag.isReserved
                ? AppTheme.primary.withOpacity(0.4)
                : AppTheme.divider,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──────────────────────────────────────────────
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    bag.restaurantImage,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 150, color: AppTheme.surfaceVariant,
                      child: const Center(child: Icon(Icons.restaurant,
                          size: 40, color: AppTheme.textLight)),
                    ),
                  ),
                  if (isSoldOut)
                    Container(
                      height: 150, color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: Text('SOLD OUT',
                            style: TextStyle(color: Colors.white,
                                fontSize: 18, fontWeight: FontWeight.w900,
                                letterSpacing: 2)),
                      ),
                    ),
                  // Discount badge
                  Positioned(top: 10, left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppTheme.accent,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('-${bag.discountPercent.toInt()}%',
                          style: const TextStyle(color: Colors.white,
                              fontSize: 12, fontWeight: FontWeight.w900)),
                    ),
                  ),
                  // Veg / Non-Veg dot (top right)
                  Positioned(top: 10, right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: bag.isVeg
                              ? AppTheme.success
                              : AppTheme.error,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(
                              color: bag.isVeg
                                  ? AppTheme.success
                                  : AppTheme.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(bag.isVeg ? 'Veg' : 'Non-Veg',
                              style: TextStyle(
                                fontSize: 9, fontWeight: FontWeight.w800,
                                color: bag.isVeg
                                    ? AppTheme.success
                                    : AppTheme.error,
                              )),
                        ],
                      ),
                    ),
                  ),
                  // Reserved badge
                  if (bag.isReserved)
                    Positioned(bottom: 10, left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.success,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded,
                                size: 11, color: Colors.white),
                            SizedBox(width: 3),
                            Text('Reserved',
                                style: TextStyle(color: Colors.white,
                                    fontSize: 11, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    ),
                  // Pickup time
                  Positioned(bottom: 10, right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(7)),
                      child: Text('⏰ ${bag.pickupStart}',
                          style: const TextStyle(color: Colors.white,
                              fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(bag.restaurantName,
                            style: const TextStyle(fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary)),
                      ),
                      // Rating
                      Row(children: [
                        const Icon(Icons.star_rounded,
                            size: 13, color: AppTheme.warning),
                        const SizedBox(width: 2),
                        Text('${bag.rating}',
                            style: const TextStyle(fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary)),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Address
                  Row(children: [
                    const Icon(Icons.location_on_rounded,
                        size: 11, color: AppTheme.textLight),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(bag.address,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10,
                              color: AppTheme.textSecondary)),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(bag.description,
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12,
                          color: AppTheme.textSecondary, height: 1.4)),
                  const SizedBox(height: 10),

                  // Price row
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('₹${bag.originalPrice.toInt()}',
                              style: const TextStyle(fontSize: 11,
                                  color: AppTheme.textLight,
                                  decoration: TextDecoration.lineThrough)),
                          Text('₹${bag.discountedPrice.toInt()}',
                              style: const TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.primary,
                                  letterSpacing: -0.3)),
                        ],
                      ),
                      const Spacer(),
                      // Tags
                      ...bag.tags.take(2).map((t) => Container(
                        margin: const EdgeInsets.only(left: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                            color: AppTheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(t,
                            style: const TextStyle(fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary)),
                      )),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Meta row: distance, bags left, delivery time
                  Row(
                    children: [
                      _MetaChip(
                          icon: Icons.location_on_rounded,
                          label: '${distance} km'),
                      const SizedBox(width: 8),
                      _MetaChip(
                          icon: Icons.shopping_bag_outlined,
                          label: '${bag.available} left',
                          urgent: bag.available <= 2),
                      const SizedBox(width: 8),
                      _MetaChip(
                          icon: Icons.delivery_dining_rounded,
                          label: '${bag.deliveryMins} min',
                          color: AppTheme.accent),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSoldOut
                              ? AppTheme.surfaceVariant
                              : AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.arrow_forward_rounded, size: 16,
                            color: isSoldOut
                                ? AppTheme.textLight
                                : AppTheme.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool urgent;
  final Color? color;
  const _MetaChip(
      {required this.icon, required this.label,
        this.urgent = false, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? (urgent ? AppTheme.warning : AppTheme.textSecondary);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 11, color: c),
      const SizedBox(width: 3),
      Text(label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
              color: c)),
    ]);
  }
}
