import 'package:google_maps_flutter/google_maps_flutter.dart';

enum BagCategory { surprise, bakery, grocery, meals }
enum ReservationStatus { active, completed, cancelled }

class Retailer {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final LatLng location;
  final double rating;
  final String address;

  Retailer({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.rating,
    required this.address,
  });
}

class SurpriseBag {
  final String id;
  final String retailerId;
  final String title;
  final BagCategory category;
  final double originalPrice;
  final double discountedPrice;
  final int count;
  final DateTime pickupStart;
  final DateTime pickupEnd;
  final List<String> items;

  SurpriseBag({
    required this.id,
    required this.retailerId,
    required this.title,
    required this.category,
    required this.originalPrice,
    required this.discountedPrice,
    required this.count,
    required this.pickupStart,
    required this.pickupEnd,
    required this.items,
  });
}

class Reservation {
  final String id;
  final String bagId;
  final String userId;
  final DateTime timestamp;
  final ReservationStatus status;

  Reservation({
    required this.id,
    required this.bagId,
    required this.userId,
    required this.timestamp,
    required this.status,
  });
}
