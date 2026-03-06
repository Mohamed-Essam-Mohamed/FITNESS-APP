import 'package:fitness_app/feature/profile/data/models/update_profile_dto.dart';

class UpdateProfileEntity {
  UpdateProfileEntity(
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
  final String activityLevel;
  final String goal;
  final int age;

  UpdateProfileDto toUpdateProfileDto() => UpdateProfileDto(
        email: email,
        activityLevel: activityLevel,
        firstName: firstName,
        lastName: lastName,
        weight: weight,
        height:height,
       age:age,
     goal: goal,



  );
}
