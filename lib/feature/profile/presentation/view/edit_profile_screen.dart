import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/common/animation/loading_shimmer.dart';
import 'package:fitness_app/core/common/widget/custom_snack_bar.dart';
import 'package:fitness_app/core/constants/app_assets.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/enum/status.dart';
import 'package:fitness_app/feature/profile/presentation/view_model/profile/profile_cubit.dart';
import 'package:fitness_app/feature/profile/presentation/widgets/custom_text_form_field_for_name_and_email.dart';
import 'package:fitness_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// ----------------------
/// Widget مستقل للـ Avatar
/// ----------------------
class ProfileAvatarWidget extends StatelessWidget {
  const ProfileAvatarWidget({
    super.key,
    required this.photoUrl,
    this.localPhoto,
    this.radius = 50,
  });

  final String photoUrl;
  final File? localPhoto;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent, // مفيش لون خلفي
      backgroundImage: localPhoto != null
          ? FileImage(localPhoto!) as ImageProvider
          : (photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null),
      child: (localPhoto == null && photoUrl.isEmpty)
          ? const Icon(
        Icons.person,
        size: 50,
        color: Colors.grey,
      )
          : null,
    );
  }
}

/// ----------------------
/// صفحة تعديل البروفايل
/// ----------------------
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late ProfileCubit profileCubit;
  late TextTheme theme;

  File? localPhoto;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context).textTheme;
    profileCubit = context.read<ProfileCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageAsset.editProfileBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            BlocBuilder<ProfileCubit, ProfileState>(
              bloc: profileCubit,
              buildWhen: (pre, cur) =>
              pre.updateProfileStatus != cur.updateProfileStatus,
              builder: (context, state) {
                if (state.updateProfileStatus == Status.loading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.orange,
                    ),
                  );
                }
                return TextButton(
                  onPressed: () {
                    profileCubit.doIntend(UpdateDataProfileAction());
                  },
                  child: const Text('Save'),
                );
              },
            )
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(LocaleKeys.Profile_EditProfile.tr()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: BlocBuilder<ProfileCubit, ProfileState>(
              bloc: profileCubit,
              buildWhen: (pre, cur) =>
              pre.getProfileStatus != cur.getProfileStatus,
              builder: (context, state) {
                if (state.getProfileStatus == Status.failure) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.errorMessage,
                        textAlign: TextAlign.center,
                        style: theme.labelLarge,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          profileCubit.doIntend(GetDataProfileAction());
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: Text('Try again'),
                        ),
                      )
                    ],
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      /// --- Avatar مستقل ---
                      Stack(
                        children: [
                          ProfileAvatarWidget(
                            photoUrl: state.dataUserEntity.photo,
                            localPhoto: localPhoto,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () async {
                                final picker = ImagePicker();
                                final pickedFile =
                                await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  setState(() {
                                    localPhoto = File(pickedFile.path);
                                  });
                                  await profileCubit.doIntend(
                                      UpdateProfilePhotoAction(localPhoto!));
                                }
                              },
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
                      ),
                      const SizedBox(height: 8),

                      /// --- باقي الصفحة مع شيمر للنصوص والحقول ---
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: state.isGetProfileLoading,
                        child: BlocConsumer<ProfileCubit, ProfileState>(
                          bloc: profileCubit,
                          listener: (context, state) {
                            if (state.updateProfileStatus == Status.success) {
                              CustomSnackBar.showSnack(
                                context: context,
                                title: state.successMessage,
                                stateType: true,
                              );
                            } else if (state.updateProfileStatus ==
                                Status.failure) {
                              CustomSnackBar.showSnack(
                                context: context,
                                title: state.errorMessage,
                                stateType: false,
                              );
                            }
                          },
                          listenWhen: (pre, cur) =>
                          pre.updateProfileStatus != cur.updateProfileStatus,
                          buildWhen: (pre, cur) =>
                          cur.updateProfileStatus != Status.success,
                          builder: (context, state) {
                            return Column(
                              children: [
                                state.isGetProfileLoading
                                    ? const CustomShimmerLoading(isBig: false)
                                    : Text(
                                  '${state.dataUserEntity.firstName}  ${state.dataUserEntity.lastName}',
                                  style: theme.labelLarge!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 40),

                                /// First Name
                                state.isGetProfileLoading
                                    ? const CustomShimmerLoading(isBig: true)
                                    : CustomTextFormFieldForNameAndEmail(
                                  icon: SvgAsset.profile,
                                  controller: profileCubit.firstNameController,
                                ),
                                const SizedBox(height: 16),

                                /// Last Name
                                state.isGetProfileLoading
                                    ? const CustomShimmerLoading(isBig: true)
                                    : CustomTextFormFieldForNameAndEmail(
                                  icon: SvgAsset.profile,
                                  controller: profileCubit.lastNameController,
                                ),
                                const SizedBox(height: 16),

                                /// Email
                                state.isGetProfileLoading
                                    ? const CustomShimmerLoading(isBig: true)
                                    : CustomTextFormFieldForNameAndEmail(
                                  icon: SvgAsset.mail,
                                  controller: profileCubit.emailController,
                                  enabled: false,
                                ),
                                const SizedBox(height: 40),

                                /// Weight
                                _buildField(
                                  title: 'Your Weight',
                                  controller: profileCubit.weightController,
                                  isNumber: true,
                                  isLoading: state.isGetProfileLoading,
                                ),

                                /// Height
                                _buildField(
                                  title: 'Your Height',
                                  controller: profileCubit.heightController,
                                  isNumber: true,
                                  isLoading: state.isGetProfileLoading,
                                ),

                                /// Goal
                                _buildField(
                                  title: 'Your Goal',
                                  controller: profileCubit.goalController,
                                  isNumber: false,
                                  isLoading: state.isGetProfileLoading,
                                ),

                                /// Activity Level
                                _buildField(
                                  title: 'Your Activity Level',
                                  controller: profileCubit.activityLevelController,
                                  isNumber: false,
                                  isLoading: state.isGetProfileLoading,
                                ),

                                /// Age
                                _buildField(
                                  title: 'Your Age',
                                  controller: profileCubit.ageController,
                                  isNumber: true,
                                  isLoading: state.isGetProfileLoading,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String title,
    required TextEditingController controller,
    required bool isNumber,
    required bool isLoading,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: isLoading
              ? const CustomShimmerLoading(isBig: false)
              : TitleTextForWeightGoalActivityLevel(title: title),
        ),
        const SizedBox(height: 16),
        isLoading
            ? const CustomShimmerLoading(isBig: true)
            : TextFormField(
          controller: controller,
          keyboardType:
          isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            fillColor: AppColors.lightWhite.withAlpha(40),
            filled: true,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class TitleTextForWeightGoalActivityLevel extends StatelessWidget {
  const TitleTextForWeightGoalActivityLevel(
      {required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Wrap(
        children: [
          Text(
            '$title  (',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Text(
            'tap to edit',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(
            ')',
            style: Theme.of(context).textTheme.displayLarge,
          )
        ],
      ),
    );
  }
}

class CustomShimmerLoading extends StatelessWidget {
  const CustomShimmerLoading({required this.isBig, super.key});
  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer(
      width: isBig ? double.infinity : 100,
      height: isBig ? 45 : 20,
      borderRadius: BorderRadius.circular(40),
    );
  }
}