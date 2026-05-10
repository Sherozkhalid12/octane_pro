import 'package:equatable/equatable.dart';
import '../constants/enums.dart';

class FuelTypeModel extends Equatable {
  final String id;
  final String name;
  final String code;
  final double pricePerLiter;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? createdBy;

  const FuelTypeModel({
    required this.id,
    required this.name,
    required this.code,
    required this.pricePerLiter,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'pricePerLiter': pricePerLiter,
        'isActive': isActive ? 1 : 0,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'createdBy': createdBy,
      };

  factory FuelTypeModel.fromJson(Map<String, dynamic> json) => FuelTypeModel(
        id: json['id'] as String,
        name: json['name'] as String,
        code: json['code'] as String,
        pricePerLiter: (json['pricePerLiter'] as num).toDouble(),
        isActive: (json['isActive'] as int) == 1,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
        createdBy: json['createdBy'] as String?,
      );

  FuelTypeModel copyWith({
    String? id,
    String? name,
    String? code,
    double? pricePerLiter,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) =>
      FuelTypeModel(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code ?? this.code,
        pricePerLiter: pricePerLiter ?? this.pricePerLiter,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        createdBy: createdBy ?? this.createdBy,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        pricePerLiter,
        isActive,
        createdAt,
        updatedAt,
        createdBy,
      ];
}
