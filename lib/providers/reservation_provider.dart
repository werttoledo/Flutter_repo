import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Reservation {
  final String id;
  final String item;
  final String type;
  final DateTime date;
  final int hours;
  final String userId;
  final String status; // 'pending', 'confirmed', 'cancelled'
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.item,
    required this.type,
    required this.date,
    required this.hours,
    required this.userId,
    this.status = 'pending',
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'item': item,
    'type': type,
    'date': date.toIso8601String(),
    'hours': hours,
    'userId': userId,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
    id: json['id'],
    item: json['item'],
    type: json['type'],
    date: DateTime.parse(json['date']),
    hours: json['hours'],
    userId: json['userId'],
    status: json['status'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class ReservationProvider with ChangeNotifier {
  List<Reservation> _reservations = [];
  List<Reservation> _cart = [];
  String? _userId;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get userId => _userId;
  List<Reservation> get reservations => _reservations;
  List<Reservation> get cart => _cart;
  List<Reservation> get userReservations => 
      _reservations.where((r) => r.userId == _userId).toList();

  // Simulación de login - En una app real, esto vendría de un sistema de autenticación
  Future<void> login(String userId) async {
    _userId = userId;
    await loadReservations();
    notifyListeners();
  }

  Future<void> loadReservations() async {
    if (_isLoading) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? reservationsJson = prefs.getString('reservations');
      if (reservationsJson != null) {
        final List<dynamic> decoded = json.decode(reservationsJson);
        _reservations = decoded.map((item) => Reservation.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error loading reservations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveReservations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(_reservations.map((r) => r.toJson()).toList());
      await prefs.setString('reservations', encoded);
    } catch (e) {
      print('Error saving reservations: $e');
      throw Exception('Error al guardar las reservas');
    }
  }

  bool isItemAvailable(String item, DateTime date, int hours) {
    if (_userId == null) return false;

    // Verificar si la fecha es válida (no en el pasado)
    if (date.isBefore(DateTime.now())) return false;

    // Verificar si está dentro del horario laboral (8 AM a 6 PM)
    final hour = date.hour;
    if (hour < 8 || hour > 18) return false;

    // Verificar si el item ya está reservado para esa fecha y hora
    return !_reservations.any((r) => 
      r.item == item && 
      r.date.year == date.year && 
      r.date.month == date.month && 
      r.date.day == date.day &&
      r.status != 'cancelled' &&
      // Verificar si hay superposición de horas
      ((r.date.hour <= date.hour && r.date.hour + r.hours > date.hour) ||
       (date.hour <= r.date.hour && date.hour + hours > r.date.hour))
    );
  }

  Future<void> addReservation(String item, String type, DateTime date, int hours) async {
    if (_userId == null) {
      throw Exception('Debe iniciar sesión para hacer una reserva');
    }

    if (!isItemAvailable(item, date, hours)) {
      throw Exception('El item no está disponible en la fecha y hora seleccionada');
    }

    final reservation = Reservation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      item: item,
      type: type,
      date: date,
      hours: hours,
      userId: _userId!,
    );

    _reservations.add(reservation);
    await saveReservations();
    notifyListeners();
  }

  Future<void> cancelReservation(String reservationId) async {
    if (_userId == null) {
      throw Exception('Debe iniciar sesión para cancelar una reserva');
    }

    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      if (_reservations[index].userId != _userId) {
        throw Exception('No tiene permiso para cancelar esta reserva');
      }

      _reservations[index] = Reservation(
        id: _reservations[index].id,
        item: _reservations[index].item,
        type: _reservations[index].type,
        date: _reservations[index].date,
        hours: _reservations[index].hours,
        userId: _reservations[index].userId,
        status: 'cancelled',
        createdAt: _reservations[index].createdAt,
      );
      await saveReservations();
      notifyListeners();
    }
  }

  void addToCart(String item, String type, DateTime date, int hours) {
    if (_userId == null) {
      throw Exception('Debe iniciar sesión para agregar al carrito');
    }

    if (!isItemAvailable(item, date, hours)) {
      throw Exception('El item no está disponible en la fecha y hora seleccionada');
    }

    _cart.add(Reservation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      item: item,
      type: type,
      date: date,
      hours: hours,
      userId: _userId!,
    ));
    notifyListeners();
  }

  void removeFromCart(Reservation reservation) {
    _cart.remove(reservation);
    notifyListeners();
  }

  double getTotal() {
    return _cart.fold(0, (sum, item) => sum + (item.hours * (item.item.contains('Laptop') ? 2500 : 1000)));
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}