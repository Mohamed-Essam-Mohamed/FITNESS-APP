import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_app/core/enum/status.dart';
import 'package:fitness_app/core/network/common/api_result.dart';
import 'package:fitness_app/core/network/common/helper.dart';
import 'package:fitness_app/feature/profile/domain/entities/get_profile_entity.dart';
import 'package:fitness_app/feature/profile/domain/entities/update_profile_entity.dart';
import 'package:fitness_app/feature/profile/domain/use_cases/get_data_profile_use_case.dart';
import 'package:fitness_app/feature/profile/domain/use_cases/update_data_profile_use_case.dart';
import 'package:fitness_app/feature/profile/domain/use_cases/update_profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
      this._getDataProfileUseCase,
      this._updateDataProfileUseCase,
      this._updateProfilePhoto,
      ) : super(const ProfileState());

  final GetDataProfileUseCase _getDataProfileUseCase;
  final UpdateDataProfileUseCase _updateDataProfileUseCase;
  final UpdateProfilePhoto _updateProfilePhoto;

  /// TextEditingControllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController goalController = TextEditingController();
  final TextEditingController activityLevelController = TextEditingController();

  File? photo;

  Future<void> doIntend(ProfileAction action) async {
    switch (action) {
      case GetDataProfileAction():
        await _getProfile();
      case UpdateDataProfileAction():
        await _updateProfile();
      case UpdateProfilePhotoAction():
        await _updatePhoto(action.photo);
    }
  }

  Future<void> _getProfile() async {
    emit(state.copyWith(getProfileStatus: Status.loading, errorMessage: null));
    final result = await _getDataProfileUseCase.call();

    switch (result) {
      case SuccessResult<GetProfileEntity>():
        firstNameController.text = result.data.user.firstName;
        lastNameController.text = result.data.user.lastName;
        emailController.text = result.data.user.email;
        weightController.text = result.data.user.weight.toString();
        heightController.text = result.data.user.height.toString();
        ageController.text = result.data.user.age.toString();
        goalController.text = result.data.user.goal;
        activityLevelController.text = result.data.user.activityLevel;

        emit(state.copyWith(
          getProfileStatus: Status.success,
          dataUserEntity: result.data.user,
          errorMessage: null,
        ));

      case FailureResult<GetProfileEntity>():
        emit(state.copyWith(
          getProfileStatus: Status.failure,
          errorMessage: Helper.getMessageFromException(result.exception),
        ));
    }
  }

  Future<void> _updateProfile() async {
    final newDataUserUpdate = state.dataUserEntity.copyWith(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      weight: int.tryParse(weightController.text.trim()) ?? state.dataUserEntity.weight,
      height: int.tryParse(heightController.text.trim()) ?? state.dataUserEntity.height,
      age: int.tryParse(ageController.text.trim()) ?? state.dataUserEntity.age,
      goal: goalController.text.trim(),
      activityLevel: activityLevelController.text.trim(),
    );

    final oldDataUserUpdate = state.dataUserEntity;

    emit(state.copyWith(
      updateProfileStatus: Status.loading,
      dataUserEntity: newDataUserUpdate,
      errorMessage: null,
      successMessage: null,
    ));

    final updateData = UpdateProfileEntity(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      weight: int.tryParse(weightController.text.trim()) ?? state.dataUserEntity.weight,
      height: int.tryParse(heightController.text.trim()) ?? state.dataUserEntity.height,
      age: int.tryParse(ageController.text.trim()) ?? state.dataUserEntity.age,
      goal: goalController.text.trim(),
      activityLevel: activityLevelController.text.trim(),
    );

    final result = await _updateDataProfileUseCase(updateData);

    switch (result) {
      case SuccessResult():
        emit(state.copyWith(
          updateProfileStatus: Status.success,
          successMessage: result.data.message,
        ));

        await _getProfile();

      case FailureResult():
        firstNameController.text = oldDataUserUpdate.firstName;
        lastNameController.text = oldDataUserUpdate.lastName;
        emailController.text = oldDataUserUpdate.email;
        weightController.text = oldDataUserUpdate.weight.toString();
        heightController.text = oldDataUserUpdate.height.toString();
        ageController.text = oldDataUserUpdate.age.toString();
        goalController.text = oldDataUserUpdate.goal;
        activityLevelController.text = oldDataUserUpdate.activityLevel;

        emit(state.copyWith(
          updateProfileStatus: Status.failure,
          dataUserEntity: oldDataUserUpdate,
          errorMessage: Helper.getMessageFromException(result.exception),
        ));
    }
  }

  Future<void> _updatePhoto(File photo) async {
    // أولاً عرض الصورة اللي اختارها المستخدم
    emit(state.copyWith(
      localPhoto: photo,
      profilePhotoStatus: Status.loading,
      errorMessage: null,
      successMessage: null,
    ));

    final result = await _updateProfilePhoto(photo);

    switch (result) {
      case SuccessResult():
        _getProfileOptimistic(result.data);
      case FailureResult():
        emit(state.copyWith(
          profilePhotoStatus: Status.failure,
          errorMessage: Helper.getMessageFromException(result.exception),
        ));
    }
  }
  Future<void> _getProfileOptimistic(String message) async {
    final result = await _getDataProfileUseCase.call();
    switch (result) {
      case SuccessResult():
        emit(state.copyWith(
          dataUserEntity: result.data.user,
          successMessage: message,
          profilePhotoStatus: Status.success,
        ));
      case FailureResult():
        emit(state.copyWith(
          errorMessage: Helper.getMessageFromException(result.exception),
          profilePhotoStatus: Status.failure,
        ));
    }
  }
}