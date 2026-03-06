import 'dart:io';
import 'package:fitness_app/core/common/widget/custom_snack_bar.dart';
import 'package:fitness_app/core/constants/app_assets.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/enum/status.dart';
import 'package:fitness_app/feature/profile/presentation/view_model/profile/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfilePhoto extends StatefulWidget {
  const ChangeProfilePhoto({required this.profileCubit, super.key});
  final ProfileCubit profileCubit;

  @override
  State<ChangeProfilePhoto> createState() => _ChangeProfilePhotoState();
}

class _ChangeProfilePhotoState extends State<ChangeProfilePhoto> {
  File? _pickedImage; // الصورة المختارة محليًا في الـ widget

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path); // عرض الصورة فورًا
      });

      // رفع الصورة للسيرفر عبر Cubit
      await widget.profileCubit.doIntend(UpdateProfilePhotoAction(_pickedImage!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.darkBackground,
          child: BlocConsumer<ProfileCubit, ProfileState>(
            bloc: widget.profileCubit,
            listener: (context, state) {
              if (state.profilePhotoStatus == Status.success) {
                CustomSnackBar.showSnack(
                  context: context,
                  title: state.successMessage,
                  stateType: true,
                );
                // **لا تمسح الصورة المؤقتة**، تظل معروضة
              } else if (state.profilePhotoStatus == Status.failure) {
                CustomSnackBar.showSnack(
                  context: context,
                  title: state.errorMessage,
                  stateType: false,
                );
              }
            },
            builder: (context, state) {
              if (state.profilePhotoStatus == Status.loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.lightOrange,
                  ),
                );
              }

              // لو في صورة محلية مختارة، عرضها دائمًا
              final imageProvider = _pickedImage != null
                  ? FileImage(_pickedImage!)
                  : NetworkImage(state.dataUserEntity.photo) as ImageProvider;

              return ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: _pickAndUploadImage,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bgCategory,
                border: Border.all(color: AppColors.orange),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: SvgPicture.asset(SvgAsset.editProfile),
              ),
            ),
          ),
        ),
      ],
    );
  }
}