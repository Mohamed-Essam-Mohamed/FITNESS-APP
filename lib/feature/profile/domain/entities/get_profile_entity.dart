import 'package:equatable/equatable.dart';

class GetProfileEntity {
  const GetProfileEntity({
    this.message = '',
    this.user = const DataUserEntity(),
  });

  final String message;
  final DataUserEntity user;
}

class DataUserEntity extends Equatable {
  const DataUserEntity({
    this.id = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.gender = '',
    this.age = 0,
    this.weight = 0,
    this.height = 0,
    this.activityLevel = '',
    this.goal = '',
    this.photo = '',
    this.createdAt = '',
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final int age;
  final int weight;
  final int height;
  final String activityLevel;
  final String goal;
  final String photo;
  final String createdAt;

  DataUserEntity copyWith({
    String? firstName,
    String? lastName,
    String? email,
    int? age,
    int? weight,
    int? height,
    String? goal,
    String? activityLevel,
    String? photo,

  }) {
    return DataUserEntity(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        age: age ?? this.age,
        weight: weight ?? this.weight,
        activityLevel: activityLevel ?? this.activityLevel,
        id: id,
        createdAt: createdAt,
        gender: gender,
        goal: goal??this.goal,
        height: height??this.height,
        photo: photo??this.photo);
  }

  @override
  List<Object?> get props => [
        goal,
        firstName,
        lastName,
        email,
        height,
        weight,
        id,
        photo,
        createdAt,
        age,
        activityLevel,
      ];
}
