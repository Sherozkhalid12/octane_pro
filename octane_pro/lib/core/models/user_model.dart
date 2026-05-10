import 'package:equatable/equatable.dart';
import '../constants/user_roles.dart';

class UserModel extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? fullName;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final String? createdBy;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    required this.role,
    this.isActive = true,
    required this.createdAt,
    this.lastLoginAt,
    this.createdBy,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'fullName': fullName,
        'role': role.name,
        'isActive': isActive ? 1 : 0,
        'createdAt': createdAt.toIso8601String(),
        'lastLoginAt': lastLoginAt?.toIso8601String(),
        'createdBy': createdBy,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        fullName: json['fullName'] as String?,
        role: UserRole.fromString(json['role'] as String),
        isActive: (json['isActive'] as int) == 1,
        createdAt: DateTime.parse(json['createdAt'] as String),
        lastLoginAt: json['lastLoginAt'] != null
            ? DateTime.parse(json['lastLoginAt'] as String)
            : null,
        createdBy: json['createdBy'] as String?,
      );

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? fullName,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? createdBy,
  }) =>
      UserModel(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        fullName: fullName ?? this.fullName,
        role: role ?? this.role,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        lastLoginAt: lastLoginAt ?? this.lastLoginAt,
        createdBy: createdBy ?? this.createdBy,
      );

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        fullName,
        role,
        isActive,
        createdAt,
        lastLoginAt,
        createdBy,
      ];
}
