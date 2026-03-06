import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_app/core/enum/status.dart';
import 'package:fitness_app/core/network/common/api_result.dart';
import 'package:fitness_app/feature/auth/domain/entities/forgot_password/change_password_entity.dart';
import 'package:fitness_app/feature/auth/domain/entities/forgot_password/forgot_password_entity.dart';
import 'package:fitness_app/feature/auth/domain/entities/forgot_password/verify_code_entity.dart';
import 'package:fitness_app/feature/auth/domain/use_cases/change_password_use_case.dart';
import 'package:fitness_app/feature/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:fitness_app/feature/auth/domain/use_cases/verify_code_use_case.dart';
import 'package:injectable/injectable.dart';

part 'forget_password_state.dart';

@injectable
class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit(
      this._forgetPasswordUseCase, this._verifyCodeUseCase, this._changePasswordUseCase)
      : super(const ForgetPasswordState());
  final ForgetPasswordUseCase _forgetPasswordUseCase;
  final VerifyCodeUseCase _verifyCodeUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;

  void doIntend(ForgetPasswordIntent intent) async {
    switch (intent.status) {
      case ForgetPasswordStatus.forgotPassword:
        await _forgotPassword(email: intent.email ?? state.email);
      case ForgetPasswordStatus.verifyCode:
        await _verifyCode(code: intent.code!);
      case ForgetPasswordStatus.changePassword:
        await _changePassword(password: intent.password!, email: intent.email!);
    }
  }

  Future<void> _forgotPassword({required String email}) async {
    emit(state.copyWith(statusForgetPassword: Status.loading, email: email));
    final result = await _forgetPasswordUseCase.call(email: email);

    switch (result) {
      case SuccessResult<ForgotPasswordEntity>():
        emit(state.copyWith(statusForgetPassword: Status.success));
        break;
      case FailureResult<ForgotPasswordEntity>():
        emit(state.copyWith(
          statusForgetPassword: Status.failure,
          errorFromForgetPassword: getMessageFromException(result.exception),
        ));
        break;
    }
  }

  Future<void> _verifyCode({required String code}) async {
    emit(state.copyWith(statusVerifyCode: Status.loading));
    final result = await _verifyCodeUseCase.call(code: code);

    switch (result) {
      case SuccessResult<VerifyCodeEntity>():
        emit(state.copyWith(statusVerifyCode: Status.success));
        break;
      case FailureResult<VerifyCodeEntity>():
        emit(state.copyWith(
          statusVerifyCode: Status.failure,
          errorFromVerifyCode: getMessageFromException(result.exception),
        ));
        break;
    }
  }

  Future<void> _changePassword({required String email, required String password}) async {
    emit(state.copyWith(statusChangePassword: Status.loading));
    final result =
        await _changePasswordUseCase.call(email: email, password: password);

    switch (result) {
      case SuccessResult<ChangePasswordEntity>():
        emit(state.copyWith(
          statusChangePassword: Status.success,
          dataChangePassword: result.data,
        ));
        break;
      case FailureResult<ChangePasswordEntity>():
        emit(state.copyWith(
          statusChangePassword: Status.failure,
          errorFromChangePassword: getMessageFromException(result.exception),
        ));
        break;
    }
  }
}

enum ForgetPasswordStatus { forgotPassword, verifyCode, changePassword }

class ForgetPasswordIntent {
  ForgetPasswordIntent({
    required this.status,
    this.email,
    this.code,
    this.password,
  });
  final ForgetPasswordStatus status;
  final String? email;
  final String? code;
  final String? password;
}

String getMessageFromException(Exception e) {
  final error = e.toString();
  final extracted =
      error.contains('-') ? error.split('-').sublist(1).join('-').trim() : error;
  return extracted;
}
