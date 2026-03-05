import 'package:fitness_app/core/network/common/api_result.dart';
import 'package:fitness_app/feature/auth/presentation/view_model/register/register_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:fitness_app/feature/auth/data/model/request/register_request._model.dart';
import 'package:fitness_app/feature/auth/domain/use_cases/register_use_case.dart';
import 'package:fitness_app/feature/auth/presentation/view_model/models/collecting_data_model.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.registerUseCase) : super(const RegisterState());
  final RegisterUseCase registerUseCase;
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String gender = 'male';
  int age = 25;
  int weight = 80;
  int height = 85;
  int indexGoal = 2;
  int indexActivityLevel = 1;
  String goal = 'Gain weight';
  String activityLevel = 'level1';

  CollectingDataModel data = const CollectingDataModel();

  Future<void> register() async {
    emit(state.copyWith(status: RegisterStatus.loading));

    final model = RegisterRequestModel(
      firstName: firstName.text,
      lastName: lastName.text,
      email: email.text,
      password: password.text,
      rePassword: password.text,
      gender: gender,
      age: age,
      weight: weight,
      height: height,
      goal: goal,
      activityLevel: activityLevel,
    );

    final result = await registerUseCase(model);

    if (result is SuccessResult<String>) {
      emit(state.copyWith(
        status: RegisterStatus.success,
        errorMessage: null,
      ));
    } else if (result is FailureResult<String>) {
      final error = result.exception.toString();
      final cleanMessage = error.toLowerCase().contains('unexpected error')
          ? error.contains('-')
          ? error.split('-').sublist(1).join('-').trim()
          : error
          : error;

      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: cleanMessage,
      ));
    }
  }
}
