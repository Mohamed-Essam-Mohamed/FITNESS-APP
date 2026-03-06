// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileDto _$UpdateProfileDtoFromJson(Map<String, dynamic> json) =>
    UpdateProfileDto(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      weight: (json['weight'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      age: (json['age'] as num).toInt(),
      activityLevel: json['activityLevel'] as String,
      goal: json['goal'] as String,
    );

Map<String, dynamic> _$UpdateProfileDtoToJson(UpdateProfileDto instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'weight': instance.weight,
      'height': instance.height,
      'age': instance.age,
      'activityLevel': instance.activityLevel,
      'goal': instance.goal,

    };
