import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/common/widget/background_app.dart';
import 'package:fitness_app/core/common/widget/custom_cache_network_image.dart';
import 'package:fitness_app/core/constants/app_assets.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/di/service_locator.dart';
import 'package:fitness_app/core/dummy/dummy_constant.dart';
import 'package:fitness_app/core/routes/routes.dart';
import 'package:fitness_app/feature/profile/presentation/view/edit_profile_screen.dart';
import 'package:fitness_app/feature/profile/presentation/view_model/profile/profile_cubit.dart';
import 'package:fitness_app/feature/profile/presentation/widgets/list_tile_profile_widget.dart';
import 'package:fitness_app/feature/profile/presentation/widgets/select_language_widget.dart';
import 'package:fitness_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    log('ProfileScreen');

    return BackgroundApp(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding:
          const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 60),
          child: Column(
            children: [
              Text(
                LocaleKeys.Profile_ProfileTitle.tr(),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w600, height: 1.20),
              ),
              const SizedBox(height: 40),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  // نعرض الصورة لو موجودة، وإلا أيقونة person
                  Widget profileImage;
                  if (state.isGetProfileLoading) {
                    // شيمر مؤقت على الشكل
                    profileImage = CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                    );
                  } else if (state.dataUserEntity.photo.isNotEmpty) {
                    profileImage = CustomCacheNetworkImage(
                      imageUrl: state.dataUserEntity.photo,
                      isCircular: true,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  } else {
                    profileImage = CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.orange,
                      child: const Icon(Icons.person, size: 50, color: Colors.white),
                    );
                  }

                  return Column(
                    children: [
                      profileImage,
                      const SizedBox(height: 8),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: state.isGetProfileLoading,
                        child: Text(
                         '${state.dataUserEntity.firstName} ${state.dataUserEntity.lastName}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                              fontWeight: FontWeight.w600, height: 1.20),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),
              Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: ShapeDecoration(
                    color: const Color(0xCC242424),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTileProfileWidget(
                          image: SvgAsset.profile,
                          title: LocaleKeys.Profile_EditProfile.tr(),
                          trailing: _iconWidget(),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<ProfileCubit>(),
                                child: const EditProfileScreen(),
                              ),
                            ),
                          )),
                      _dividerWidget(),
                      ListTileProfileWidget(
                        image: SvgAsset.change,
                        title: LocaleKeys.Profile_ChangePassword.tr(),
                        trailing: _iconWidget(),
                        onTap: () =>  Navigator.pushNamed(context, Routes.changePassword)
                      ),
                      _dividerWidget(),
                      const SelectLanguageWidget(),
                      _dividerWidget(),
                      ListTileProfileWidget(
                        image: SvgAsset.lockSetting,
                        title: LocaleKeys.Profile_Security.tr(),
                        trailing: _iconWidget(),
                      ),
                      _dividerWidget(),
                      ListTileProfileWidget(
                        image: SvgAsset.securityWarning,
                        title: LocaleKeys.Profile_PrivacyPolicy.tr(),
                        trailing: _iconWidget(),
                      ),
                      _dividerWidget(),
                      ListTileProfileWidget(
                        image: SvgAsset.help,
                        title: LocaleKeys.Profile_Help.tr(),
                        trailing: _iconWidget(),
                      ),
                      _dividerWidget(),
                      ListTileProfileWidget(
                        image: SvgAsset.logout,
                        title: LocaleKeys.Profile_Logout.tr(),
                        trailing: _iconWidget(),
                        textColor: AppColors.redOrange,
                        onTap:  ()=> Navigator.of(context).pushReplacementNamed(Routes.login),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Divider _dividerWidget() {
    return const Divider(
      color: AppColors.bgBottomNav,
      endIndent: 16,
      indent: 16,
      thickness: 1.5,
    );
  }

  Icon _iconWidget() {
    return const Icon(
      Icons.arrow_forward_ios,
      size: 20,
    );
  }
}