import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/common/animation/loading_shimmer.dart';
import 'package:fitness_app/core/common/widget/custom_snack_bar.dart';
import 'package:fitness_app/core/constants/app_assets.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/enum/status.dart';
import 'package:fitness_app/feature/profile/presentation/view_model/profile/profile_cubit.dart';
import 'package:fitness_app/feature/profile/presentation/widgets/change_profile_photo.dart';
import 'package:fitness_app/feature/profile/presentation/widgets/custom_text_form_field_for_name_and_email.dart';
import 'package:fitness_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({required this.profileCubit, super.key});
  final ProfileCubit profileCubit;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextTheme theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context).textTheme;
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
              bloc: widget.profileCubit,
              buildWhen: (pre, cur) {
                if (pre.updateProfileStatus != cur.updateProfileStatus) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state.updateProfileStatus == Status.loading) {
                  return const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.orange,
                  );
                }
                return TextButton(
                  onPressed: () {
                    widget.profileCubit.doIntend(UpdateDataProfileAction());
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
              buildWhen: (pre, cur) {
                if (pre.getProfileStatus != cur.getProfileStatus) {
                  return true;
                }
                return false;
              },
              bloc: widget.profileCubit,
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
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          widget.profileCubit.doIntend(GetDataProfileAction());
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          child: Text('Try again'),
                        ),
                      )
                    ],
                  );
                }
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: state.isGetProfileLoading,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        state.isGetProfileLoading
                            ? const LoadingShimmer(
                                isCircular: true,
                                width: 100,
                                height: 100,
                              )
                            : ChangeProfilePhoto(
                                profileCubit: widget.profileCubit,
                                url: state.dataUserEntity.photo,
                              ),
                        const SizedBox(height: 8),

                        ///rebuild all Ui
                        BlocConsumer<ProfileCubit, ProfileState>(
                          bloc: widget.profileCubit,
                          listener: (context, state) {
                            if (state.updateProfileStatus == Status.success) {
                              CustomSnackBar.showSnack(
                                context: context,
                                title: state.successMessage,
                                stateType: true,
                              );
                            } else if (state.updateProfileStatus == Status.failure) {
                              CustomSnackBar.showSnack(
                                context: context,
                                title: state.errorMessage,
                                stateType: false,
                              );
                            }
                          },
                          listenWhen: (pre, cur) {
                            if (cur.updateProfileStatus != pre.updateProfileStatus) {
                              return true;
                            }
                            return false;
                          },
                          buildWhen: (pre, cur) {
                            if (cur.updateProfileStatus != Status.success) {
                              return true;
                            }
                            return false;
                          },
                          builder: (context, state) {
                            return Column(
                              children: [
                                state.isGetProfileLoading
                                    ? const CustomShimmerLoading(
                                        isBig: false,
                                      )
                                    : Text(
                                        '${state.dataUserEntity.firstName}  ${state.dataUserEntity.lastName}',
                                        style: theme.labelLarge!
                                            .copyWith(fontWeight: FontWeight.w600),
                                      ),
                                const SizedBox(height: 40),
                                state.isGetProfileLoading
                                    ? const CustomShimmerLoading(
                                        isBig: true,
                                      )
                                    : CustomTextFormFieldForNameAndEmail(
                                        icon: SvgAsset.profile,
                                        controller:
                                            widget.profileCubit.firstNameController,
                                      ),
                                const SizedBox(height: 16),
                                state.isGetProfileLoading
                                    ? const CustomShimmerLoading(
                                        isBig: true,
                                      )
                                    : CustomTextFormFieldForNameAndEmail(
                                        icon: SvgAsset.profile,
                                        controller:
                                            widget.profileCubit.lastNameController,
                                      ),
                                const SizedBox(height: 16),
                                state.isGetProfileLoading
                                    ? const CustomShimmerLoading(
                                        isBig: true,
                                      )
                                    : CustomTextFormFieldForNameAndEmail(
                                        icon: SvgAsset.mail,
                                        controller: widget.profileCubit.emailController,
                                        enabled: false,
                                      ),
                                const SizedBox(height: 40),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: state.isGetProfileLoading
                                      ? const CustomShimmerLoading(
                                          isBig: false,
                                        )
                                      : const TitleTextForWeightGoalActivityLevel(
                                          title: 'Your Weight',
                                        ),
                                ),
                                const SizedBox(height: 16),
                                state.isGetProfileLoading
                                    ? const CustomShimmerLoading(
                                        isBig: true,
                                      )
                                    : TextFormField(
                                        controller: TextEditingController(
                                            text: state.dataUserEntity.weight.toString()),
                                        decoration: InputDecoration(
                                          fillColor: AppColors.lightWhite.withAlpha(40),
                                          filled: true,
                                        ),
                                      ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: state.isGetProfileLoading
                                      ? const CustomShimmerLoading(
                                          isBig: false,
                                        )
                                      : const TitleTextForWeightGoalActivityLevel(
                                          title: 'Your Goal',
                                        ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                state.isGetProfileLoading
                                    ? const CustomShimmerLoading(
                                        isBig: true,
                                      )
                                    : TextFormField(
                                        controller: TextEditingController(
                                            text: state.dataUserEntity.goal),
                                        decoration: InputDecoration(
                                          fillColor: AppColors.lightWhite.withAlpha(40),
                                          filled: true,
                                        ),
                                      ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: state.isGetProfileLoading
                                      ? const CustomShimmerLoading(
                                          isBig: false,
                                        )
                                      : const TitleTextForWeightGoalActivityLevel(
                                          title: 'Your Activity Level',
                                        ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                state.isGetProfileLoading
                                    ? const CustomShimmerLoading(
                                        isBig: true,
                                      )
                                    : TextFormField(
                                        controller: TextEditingController(
                                            text: state.dataUserEntity.activityLevel),
                                        decoration: InputDecoration(
                                          fillColor: AppColors.lightWhite.withAlpha(40),
                                          filled: true,
                                        ),
                                      ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TitleTextForWeightGoalActivityLevel extends StatelessWidget {
  const TitleTextForWeightGoalActivityLevel({required this.title, super.key});
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
