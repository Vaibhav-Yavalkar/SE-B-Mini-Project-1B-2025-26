import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'models/models.dart';

class AppProvider extends ChangeNotifier {
  List<Retailer> _retailers = [];
  List<SurpriseBag> _bags = [];
  List<Reservation> _reservations = [];
  
  bool _isLoading = true;
  bool _isLoggedIn = false;
  
  double userLat = 19.2403;
  double userLng = 73.1305;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  List<Retailer> get retailers => _retailers;
  List<SurpriseBag> get bags => _bags;
  List<Reservation> get reservations => _reservations;

  AppProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadInitialData();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadInitialData() async {
    // Simulate loading data
    await Future.delayed(const Duration(seconds: 1));
    
    _retailers = [
      Retailer(
        id: '1',
        name: 'Fresh Bakery',
        description: 'Freshly baked breads and pastries.',
        imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff',
        location: const LatLng(19.2403, 73.1305),
        rating: 4.8,
        address: '123 Baker Street',
      ),
      Retailer(
        id: '2',
        name: 'Green Grocery',
        description: 'Organic fruits and vegetables.',
        imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e',
        location: const LatLng(19.2503, 73.1405),
        rating: 4.5,
        address: '456 Garden Lane',
      ),
    ];

    _bags = [
      SurpriseBag(
        id: 'b1',
        retailerId: '1',
        title: 'Assorted Pastries',
        category: BagCategory.bakery,
        originalPrice: 15.0,
        discountedPrice: 4.99,
        count: 3,
        pickupStart: DateTime.now().add(const Duration(hours: 1)),
        pickupEnd: DateTime.now().add(const Duration(hours: 3)),
        items: ['Croissant', 'Muffin', 'Cookie'],
      ),
    ];
  }

  Future<void> login() async {
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    notifyListeners();
  }
}
