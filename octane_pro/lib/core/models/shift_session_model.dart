import 'package:equatable/equatable.dart';
import '../constants/enums.dart';

class ShiftSessionModel extends Equatable {
  final String id;
  final String shiftId;
  final String userId;
  final DateTime date;
  final double openingCash;
  final double? closingCash;
  final Map<String, double>? openingMeterReadings;
  final Map<String, double>? closingMeterReadings;
  final double? totalLiters;
  final double? totalAmount;
  final double cashSales;
  final double creditSales;
  final double expenses;
  final double shortExcess;
  final String? remarks;
  final String status; // 'active', 'closed'
  final DateTime startedAt;
  final DateTime? endedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ShiftSessionModel({
    required this.id,
    required this.shiftId,
    required this.userId,
    required this.date,
    this.openingCash = 0,
    this.closingCash,
    this.openingMeterReadings,
    this.closingMeterReadings,
    this.totalLiters,
    this.totalAmount,
    this.cashSales = 0,
    this.creditSales = 0,
    this.expenses = 0,
    this.shortExcess = 0,
    this.remarks,
    required this.status,
    required this.startedAt,
    this.endedAt,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'shiftId': shiftId,
        'userId': userId,
        'date': date.toIso8601String(),
        'openingCash': openingCash,
        'closingCash': closingCash,
        'openingMeterReadings': openingMeterReadings != null
            ? openingMeterReadings!.map((k, v) => MapEntry(k, v))
            : null,
        'closingMeterReadings': closingMeterReadings != null
            ? closingMeterReadings!.map((k, v) => MapEntry(k, v))
            : null,
        'totalLiters': totalLiters,
        'totalAmount': totalAmount,
        'cashSales': cashSales,
        'creditSales': creditSales,
        'expenses': expenses,
        'shortExcess': shortExcess,
        'remarks': remarks,
        'status': status,
        'startedAt': startedAt.toIso8601String(),
        'endedAt': endedAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  factory ShiftSessionModel.fromJson(Map<String, dynamic> json) {
    Map<String, double>? parseMeterReadings(dynamic data) {
      if (data == null) return null;
      if (data is Map) {
        return data
            .map((k, v) => MapEntry(k.toString(), (v as num).toDouble()));
      }
      if (data is String) {
        // Parse JSON string
        return null; // Handle JSON parsing if needed
      }
      return null;
    }

    return ShiftSessionModel(
      id: json['id'] as String,
      shiftId: json['shiftId'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      openingCash: (json['openingCash'] as num?)?.toDouble() ?? 0,
      closingCash: (json['closingCash'] as num?)?.toDouble(),
      openingMeterReadings: parseMeterReadings(json['openingMeterReadings']),
      closingMeterReadings: parseMeterReadings(json['closingMeterReadings']),
      totalLiters: (json['totalLiters'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      cashSales: (json['cashSales'] as num?)?.toDouble() ?? 0,
      creditSales: (json['creditSales'] as num?)?.toDouble() ?? 0,
      expenses: (json['expenses'] as num?)?.toDouble() ?? 0,
      shortExcess: (json['shortExcess'] as num?)?.toDouble() ?? 0,
      remarks: json['remarks'] as String?,
      status: json['status'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] != null
          ? DateTime.parse(json['endedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  bool get isActive => status == 'active';

  @override
  List<Object?> get props => [
        id,
        shiftId,
        userId,
        date,
        openingCash,
        closingCash,
        openingMeterReadings,
        closingMeterReadings,
        totalLiters,
        totalAmount,
        cashSales,
        creditSales,
        expenses,
        shortExcess,
        remarks,
        status,
        startedAt,
        endedAt,
        createdAt,
        updatedAt,
      ];
}
