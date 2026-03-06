import 'package:json_annotation/json_annotation.dart';
part 'update_profile_dto.g.dart';

@JsonSerializable()
class UpdateProfileDto {
  UpdateProfileDto(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.weight,
      required this.activityLevel,
      required this.goal, required this.height, required this.age});

  final String firstName;
  final String lastName;
  final String email;

  final int weight;
  final int height;
  final int age;


  final String activityLevel;
  final String goal;

  factory UpdateProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateProfileDtoToJson(this);
}
