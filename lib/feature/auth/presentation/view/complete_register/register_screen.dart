import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:fitness_app/core/constants/app_assets.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/extensions/media_query_extensions.dart';
import 'package:fitness_app/core/utils/validator.dart';
import 'package:fitness_app/feature/auth/presentation/view_model/register/register_cubit.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/animation_text.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/bottom_section.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/custom_auth_container.dart';

import 'package:fitness_app/feature/auth/presentation/widgets/text_form_widget.dart';
import 'package:fitness_app/generated/locale_keys.g.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>  with AutomaticKeepAliveClientMixin<RegisterScreen> {
  bool get wantKeepAlive => true;

  late RegisterCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<RegisterCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimationText(
                  child: Text(
                    LocaleKeys.Authentication_heyThere.tr(),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                AnimationText(
                  millDelay: 1200,
                  child: Text(
                    LocaleKeys.Authentication_createAnAccount.tr(),
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CustomAuthContainer(
            child: Form(
              key: cubit.formKey,
              child: Column(
                children: [
                  AnimationText(
                    millDelay: 1250,
                    child: Text(
                      LocaleKeys.Authentication_Register.tr(),
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // First Name
                  TextFormField(
                    controller: cubit.firstName,
                    validator: Validator.validateName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(SvgAsset.profile),
                      ),
                      hintText: LocaleKeys.Authentication_FirstName.tr(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Last Name
                  TextFormField(
                    controller: cubit.lastName,
                    validator: Validator.validateName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(SvgAsset.profile),
                      ),
                      hintText: LocaleKeys.Authentication_LastName.tr(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: cubit.email,
                    validator: Validator.validateEmail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(SvgAsset.mail),
                      ),
                      hintText: LocaleKeys.Authentication_Email.tr(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Password
                  TextFormWidget(
                    controller: cubit.password,
                    validator: Validator.validatePassword,
                    prefixIcon: SvgAsset.lock,
                    suffixIcon: SvgAsset.eye,
                    obscureText: true,
                    hintText: LocaleKeys.Authentication_Password.tr(),
                  ),

                  const SizedBox(height: 24),
                  const BottomSection(),
                  const SizedBox(height: 24),

                  // Register Button
                  BounceInDown(
                    delay: const Duration(milliseconds: 700),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () {
                        if (cubit.formKey.currentState!.validate()) {
                          widget.pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(LocaleKeys.Authentication_Register.tr()),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Already have account
                  Text.rich(
                    TextSpan(
                      text: LocaleKeys.Authentication_AlreadyHaveAnAccount.tr(),
                      style: Theme.of(context).textTheme.labelSmall,
                      children: [
                        TextSpan(
                          text: LocaleKeys.Authentication_Login.tr(),
                          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                color: AppColors.lightOrange,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.lightOrange,
                              ),
                          recognizer: TapGestureRecognizer()..onTap = () => context.pop(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
