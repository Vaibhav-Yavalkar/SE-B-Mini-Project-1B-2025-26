// lib/screens/map_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_provider.dart';
import '../models/models.dart';
import 'bag_detail_screen.dart';

// Note: This is a simulated map using Flutter widgets (no Google Maps API key needed for the prototype)
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  FoodBag? _selectedBag;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final bags = provider.bags;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Map Placeholder (simulated with a styled container + markers)
          _buildSimulatedMap(bags),
          // Top App Bar
          _buildTopBar(context),
          // Bottom Sheet with selected bag info or bag list
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _selectedBag != null
                ? _buildSelectedBagSheet(context, _selectedBag!)
                : _buildBagListSheet(context, bags),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatedMap(List<FoodBag> bags) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFE8F0E9),
      ),
      child: Stack(
        children: [
          // Grid lines simulating map
          CustomPaint(
            size: Size.infinite,
            painter: _MapGridPainter(),
          ),
          // Simulated road lines
          CustomPaint(
            size: Size.infinite,
            painter: _RoadPainter(),
          ),
          // User location dot
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A73E8),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1A73E8).withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'You',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A73E8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Place bag markers
          ..._buildBagMarkers(bags),
          // Radius circle
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primary.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBagMarkers(List<FoodBag> bags) {
    // Static positions for markers (simulated)
    final positions = [
      const Offset(0.3, 0.28),
      const Offset(0.65, 0.32),
      const Offset(0.45, 0.55),
      const Offset(0.25, 0.62),
      const Offset(0.70, 0.58),
      const Offset(0.55, 0.22),
    ];

    return bags.asMap().entries.map((entry) {
      final i = entry.key;
      final bag = entry.value;
      final pos = i < positions.length ? positions[i] : const Offset(0.5, 0.5);
      final isSoldOut = bag.available == 0;
      final isSelected = _selectedBag?.id == bag.id;

      return LayoutBuilder(
        builder: (context, constraints) {
          final w = MediaQuery.of(context).size.width;
          final h = MediaQuery.of(context).size.height * 0.7;
          return Positioned(
            left: w * pos.dx - 28,
            top: h * pos.dy - 28,
            child: GestureDetector(
              onTap: () => setState(() =>
                  _selectedBag = (_selectedBag?.id == bag.id) ? null : bag),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSoldOut
                            ? AppTheme.textLight
                            : isSelected
                                ? AppTheme.accent
                                : AppTheme.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: (isSelected ? AppTheme.accent : AppTheme.primary)
                                .withOpacity(0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        '₹${bag.discountedPrice.toInt()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    CustomPaint(
                      size: const Size(10, 6),
                      painter: _MarkerArrowPainter(
                          isSoldOut
                              ? AppTheme.textLight
                              : isSelected
                                  ? AppTheme.accent
                                  : AppTheme.primary),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search_rounded,
                        size: 18, color: AppTheme.textLight),
                    SizedBox(width: 8),
                    Text(
                      'Search on map...',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.my_location_rounded,
                  size: 20, color: AppTheme.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedBagSheet(BuildContext context, FoodBag bag) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  bag.restaurantImage,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 64,
                    height: 64,
                    color: AppTheme.surfaceVariant,
                    child: const Icon(Icons.restaurant),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bag.restaurantName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '₹${bag.discountedPrice.toInt()}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '₹${bag.originalPrice.toInt()}',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textLight,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${bag.available} available · ${bag.pickupStart} – ${bag.pickupEnd}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _selectedBag = null),
                child: const Icon(Icons.close_rounded,
                    color: AppTheme.textLight),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BagDetailScreen(bagId: bag.id),
                ),
              ),
              child: const Text('View Bag Details'),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildBagListSheet(BuildContext context, List<FoodBag> bags) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              children: [
                const Text(
                  'Nearby Bags',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Within 5 km',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              itemCount: bags.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final bag = bags[i];
                return GestureDetector(
                  onTap: () => setState(() => _selectedBag = bag),
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            bag.restaurantImage,
                            width: 48,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 48,
                              height: 64,
                              color: AppTheme.divider,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                bag.restaurantName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₹${bag.discountedPrice.toInt()}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4E0D5)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height * 0.45),
        Offset(size.width, size.height * 0.45), roadPaint);
    canvas.drawLine(Offset(size.width * 0.4, 0),
        Offset(size.width * 0.4, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.7, 0),
        Offset(size.width * 0.7, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.25),
        Offset(size.width, size.height * 0.25), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.7),
        Offset(size.width, size.height * 0.7), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MarkerArrowPainter extends CustomPainter {
  final Color color;
  _MarkerArrowPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
