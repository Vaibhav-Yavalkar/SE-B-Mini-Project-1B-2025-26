// lib/screens/tracking_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_provider.dart';
import '../models/models.dart';

class TrackingScreen extends StatefulWidget {
  final String reservationId;
  const TrackingScreen({super.key, required this.reservationId});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _markerCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _markerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _markerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final reservation =
            provider.getReservationById(widget.reservationId);
        if (reservation == null) {
          return const Scaffold(
              body: Center(child: Text('Order not found')));
        }
        final driver = reservation.driver;
        final isArrived =
            driver?.status == DeliveryStatus.arrived ||
                reservation.status == ReservationStatus.completed;

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: Stack(
            children: [
              // ── Simulated Map ────────────────────────────────────
              _buildSimulatedMap(context, reservation, provider),

              // ── Top bar ──────────────────────────────────────────
              _buildTopBar(context, reservation),

              // ── Bottom tracking card ──────────────────────────────
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: isArrived
                    ? _buildArrivedCard(context, reservation)
                    : _buildTrackingCard(context, reservation, driver),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Simulated Map with animated driver marker ──────────────────
  Widget _buildSimulatedMap(BuildContext context, Reservation reservation,
      AppProvider provider) {
    final driver = reservation.driver;
    final screenW = MediaQuery.of(context).size.width;
    final mapH = MediaQuery.of(context).size.height * 0.62;

    // Normalise driver position to screen coords (fake map)
    double driverX = screenW * 0.5;
    double driverY = mapH * 0.4;
    if (driver != null) {
      final latDiff = driver.driverLat - provider.userLat;
      final lngDiff = driver.driverLng - provider.userLng;
      driverX = (screenW / 2) + lngDiff * 8000;
      driverY = (mapH / 2) - latDiff * 8000;
      driverX = driverX.clamp(40.0, screenW - 40.0);
      driverY = driverY.clamp(60.0, mapH - 60.0);
    }

    return SizedBox(
      height: mapH,
      child: Stack(
        children: [
          // Map tiles (simulated)
          Container(color: const Color(0xFFE8F0E9)),
          CustomPaint(size: Size(screenW, mapH),
              painter: _MapPainter()),

          // Route line (driver → user)
          CustomPaint(
            size: Size(screenW, mapH),
            painter: _RoutePainter(
              start: Offset(driverX, driverY),
              end: Offset(screenW / 2, mapH * 0.65),
            ),
          ),

          // Restaurant marker
          Positioned(
            left: screenW * 0.28 - 16,
            top: mapH * 0.28 - 36,
            child: _MapPin(emoji: '🏪', label: reservation.bag.restaurantName,
                color: AppTheme.accent),
          ),

          // Driver marker (animated bounce)
          AnimatedBuilder(
            animation: _markerCtrl,
            builder: (_, __) => Positioned(
              left: driverX - 20,
              top: driverY - 44 + _markerCtrl.value * 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                      boxShadow: [BoxShadow(
                          color: AppTheme.primary.withOpacity(0.4),
                          blurRadius: 10, spreadRadius: 2)],
                    ),
                    child: const Center(
                      child: Text('🛵', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  CustomPaint(
                    size: const Size(10, 6),
                    painter: _ArrowPainter(AppTheme.primary),
                  ),
                ],
              ),
            ),
          ),

          // User location (pulsing)
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (_, __) => Positioned(
              left: screenW / 2 - 20,
              top: mapH * 0.65 - 20,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 40 + _pulseCtrl.value * 16,
                    height: 40 + _pulseCtrl.value * 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A73E8).withOpacity(
                          0.15 * (1 - _pulseCtrl.value)),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A73E8),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // "You" label
          Positioned(
            left: screenW / 2 + 14,
            top: mapH * 0.65 - 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.08), blurRadius: 4)],
              ),
              child: const Text('You',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                      color: Color(0xFF1A73E8))),
            ),
          ),

          // Map gradient overlay at bottom
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent,
                    AppTheme.background.withOpacity(0.9)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, Reservation reservation) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.1), blurRadius: 6)],
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 15, color: AppTheme.textPrimary),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.08), blurRadius: 6)],
                ),
                child: Text(
                  reservation.bag.restaurantName,
                  style: const TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Status Steps ─────────────────────────────────────────────────
  Widget _buildTrackingCard(BuildContext context, Reservation reservation,
      DeliveryDriver? driver) {
    final statusIndex = switch (driver?.status) {
      DeliveryStatus.assigned => 0,
      DeliveryStatus.pickedUp => 1,
      DeliveryStatus.nearYou => 2,
      _ => 0,
    };

    final steps = [
      ('🔍', 'Driver assigned', 'Heading to restaurant'),
      ('📦', 'Order picked up', 'On the way to you'),
      ('📍', 'Almost there!', 'Driver is nearby'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16,
            offset: Offset(0, -2))],
      ),
      padding: EdgeInsets.only(
        top: 16, left: 20, right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(width: 36, height: 4,
              decoration: BoxDecoration(color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),

          // ETA banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [AppTheme.primaryDark, AppTheme.primary]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  driver != null ? '${driver.etaMinutes} min' : '-- min',
                  style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900,
                      color: Colors.white, letterSpacing: -1),
                ),
                const Text('Estimated arrival',
                    style: TextStyle(fontSize: 12, color: Colors.white70,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Status steps
          Row(
            children: List.generate(steps.length, (i) {
              final done = i < statusIndex;
              final active = i == statusIndex;
              final (emoji, title, sub) = steps[i];
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: done
                                  ? AppTheme.success
                                  : active
                                      ? AppTheme.primary
                                      : AppTheme.surfaceVariant,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: active
                                    ? AppTheme.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: done
                                  ? const Icon(Icons.check_rounded,
                                      color: Colors.white, size: 18)
                                  : Text(emoji,
                                      style: const TextStyle(fontSize: 18)),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: active || done
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                                color: active || done
                                    ? AppTheme.textPrimary
                                    : AppTheme.textLight,
                              )),
                          Text(sub,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 8,
                                  color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                    if (i < steps.length - 1)
                      Container(
                        height: 2, width: 16,
                        color: done ? AppTheme.success : AppTheme.divider,
                        margin: const EdgeInsets.only(bottom: 28),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.divider),
          const SizedBox(height: 12),

          // Driver info row
          if (driver != null) _buildDriverRow(context, driver),
        ],
      ),
    );
  }

  Widget _buildDriverRow(BuildContext context, DeliveryDriver driver) {
    return Row(
      children: [
        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.divider),
          ),
          child: Center(
            child: Text(driver.avatarEmoji,
                style: const TextStyle(fontSize: 22)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(driver.name,
                  style: const TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
              Text('${driver.vehicleNumber} · 🛵 Delivery Partner',
                  style: const TextStyle(fontSize: 11,
                      color: AppTheme.textSecondary)),
            ],
          ),
        ),
        // Call button
        GestureDetector(
          onTap: () => _showCallDialog(context, driver),
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppTheme.primary.withOpacity(0.3)),
            ),
            child: const Icon(Icons.call_rounded,
                color: AppTheme.primary, size: 18),
          ),
        ),
        const SizedBox(width: 8),
        // Chat button
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.divider),
          ),
          child: const Icon(Icons.chat_rounded,
              color: AppTheme.textSecondary, size: 18),
        ),
      ],
    );
  }

  Widget _buildArrivedCard(BuildContext context, Reservation reservation) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16,
            offset: Offset(0, -2))],
      ),
      padding: EdgeInsets.only(
        top: 20, left: 24, right: 24,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🎉', style: TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(height: 14),
          const Text('Your order has arrived!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 6),
          Text(
            'Enjoy your surprise bag from\n${reservation.bag.restaurantName}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary,
                height: 1.5),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.eco_rounded,
                    color: AppTheme.primary, size: 16),
                const SizedBox(width: 6),
                Text(
                  'You saved ${reservation.bag.weightKg} kg of food today!',
                  style: const TextStyle(fontSize: 12,
                      fontWeight: FontWeight.w700, color: AppTheme.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.popUntil(
                  context, (route) => route.isFirst),
              child: const Text('Back to Home'),
            ),
          ),
        ],
      ),
    );
  }

  void _showCallDialog(BuildContext context, DeliveryDriver driver) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text('Call ${driver.name}'),
        content: Text(driver.phone,
            style: const TextStyle(fontSize: 18,
                fontWeight: FontWeight.w700, color: AppTheme.primary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.call_rounded, size: 16),
            label: const Text('Call'),
          ),
        ],
      ),
    );
  }
}

// ── Custom Painters ───────────────────────────────────────────────
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()..color = Colors.white..strokeWidth = 14
        ..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final grid = Paint()..color = const Color(0xFFD4E0D5)..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 40)
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    for (double y = 0; y < size.height; y += 40)
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    canvas.drawLine(Offset(0, size.height * 0.42),
        Offset(size.width, size.height * 0.42), road);
    canvas.drawLine(Offset(size.width * 0.38, 0),
        Offset(size.width * 0.38, size.height), road);
    canvas.drawLine(Offset(size.width * 0.7, 0),
        Offset(size.width * 0.7, size.height), road);
    canvas.drawLine(Offset(0, size.height * 0.7),
        Offset(size.width, size.height * 0.7), road);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _RoutePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  _RoutePainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primary.withOpacity(0.6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(
          (start.dx + end.dx) / 2, start.dy, end.dx, end.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RoutePainter old) =>
      old.start != start || old.end != end;
}

class _ArrowPainter extends CustomPainter {
  final Color color;
  _ArrowPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width / 2, size.height)
          ..close(),
        Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _MapPin extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  const _MapPin(
      {required this.emoji, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(
                color: color.withOpacity(0.4), blurRadius: 6,
                offset: const Offset(0, 2))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              Text(label,
                  style: const TextStyle(fontSize: 9,
                      fontWeight: FontWeight.w800, color: Colors.white),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        CustomPaint(
          size: const Size(10, 6),
          painter: _ArrowPainter(color),
        ),
      ],
    );
  }
}
