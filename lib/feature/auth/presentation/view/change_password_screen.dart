import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/common/widget/background_app.dart';
import 'package:fitness_app/core/constants/app_assets.dart';

import 'package:fitness_app/core/dialogs/app_dialogs.dart';
import 'package:fitness_app/core/dialogs/app_toasts.dart';
import 'package:fitness_app/core/extensions/media_query_extensions.dart';
import 'package:fitness_app/core/routes/routes.dart';
import 'package:fitness_app/core/utils/validator.dart';
import 'package:fitness_app/feature/auth/presentation/view_model/forget_password/forget_password_cubit.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/animation_text.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/custom_auth_container.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/logo_app_widget.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/text_form_widget.dart';
import 'package:fitness_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:toastification/toastification.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late TextEditingController _emailController; // جديد
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController(); // جديد
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose(); // جديد
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ForgetPasswordCubit>(context);

    return BackgroundApp(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
              listener: (context, state) {
                if (state.isChangeLoading) {
                  AppDialogs.showLoadingDialog(context);
                }
                if (state.isChangeSuccess) {
                  Navigator.of(context).pushNamed(Routes.login);
                  AppToast.showToast(
                    context: context,
                    title: '',
                    description: 'password changed successfully',
                    type: ToastificationType.success,
                  );
                }
                if (state.isChangeFailure) {
                  context.pop();
                  AppToast.showToast(
                    context: context,
                    title: '',
                    description: state.errorFromChangePassword,
                    type: ToastificationType.error,
                  );
                }
              },
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const LogoAppWidget(),
                    const SizedBox(height: 88),
                    AnimationText(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          LocaleKeys.Authentication_MakeSureIts8CharactersOrMore.tr(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    AnimationText(
                      millDelay: 1200,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          LocaleKeys.Authentication_CreateNewPassword.tr(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomAuthContainer(
                      child: Column(
                        spacing: 24,
                        children: [
                          /// --- حقل الإيميل الجديد ---
                          TextFormWidget(
                            controller: _emailController,
                            validator: Validator.validateEmail,
                            prefixIcon: SvgAsset.mail,
                            hintText: LocaleKeys.Authentication_Email.tr(), suffixIcon: '',
                            obscureText: false,
                          ),

                          TextFormWidget(
                            controller: _newPasswordController,
                            validator: Validator.validatePassword,
                            prefixIcon: SvgAsset.lock,
                            suffixIcon: SvgAsset.eye,
                            obscureText: true,
                            hintText: LocaleKeys.Authentication_Password.tr(),
                          ),
                          TextFormWidget(
                            controller: _confirmPasswordController,
                            validator: (val) => Validator.validateConfirmPassword(
                                val, _newPasswordController.text),
                            prefixIcon: SvgAsset.lock,
                            suffixIcon: SvgAsset.eye,
                            obscureText: true,
                            hintText: LocaleKeys.Authentication_ConfirmPassword.tr(),
                          ),
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
                                if (formKey.currentState!.validate()) {
                                  cubit.doIntend(ForgetPasswordIntent(
                                    status: ForgetPasswordStatus.changePassword,
                                    email: _emailController.text, // مرسل الإيميل
                                    password: _newPasswordController.text,
                                  ));
                                }
                              },
                              child: Text(LocaleKeys.Authentication_Done.tr()),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}