import 'package:animate_do/animate_do.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/dialogs/app_dialogs.dart';
import 'package:fitness_app/core/routes/routes.dart';
import 'package:fitness_app/feature/auth/presentation/view/complete_register/goal_screen.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/animation_text.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/circular_percent_indicator_widget.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/custom_auth_container.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/core/extensions/media_query_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:toastification/toastification.dart';
import 'package:fitness_app/core/dialogs/app_toasts.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/generated/locale_keys.g.dart';
import 'package:fitness_app/feature/auth/presentation/view_model/register/register_cubit.dart';
import 'package:fitness_app/feature/auth/presentation/view_model/register/register_state.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int selectedIndex = 0;
  late RegisterCubit cubit;

  final List<String> activity = [
    LocaleKeys.Authentication_Rookie.tr(),
    LocaleKeys.Authentication_Beginner.tr(),
    LocaleKeys.Authentication_Intermediate.tr(),
    LocaleKeys.Authentication_Advance.tr(),
    LocaleKeys.Authentication_TrueBeast.tr(),
  ];

  @override
  void initState() {
    super.initState();
    cubit = context.read<RegisterCubit>();
    selectedIndex = cubit.indexActivityLevel;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<RegisterCubit, RegisterState>(
      bloc: cubit,
      listener: (context, state) {
        if (state.status == RegisterStatus.failure) {
          context.pop();
          widget.pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              AppToast.showToast(
                context: context,
                title: 'Error',
                description: state.errorMessage.toString(),
                type: ToastificationType.error,
              );
            }
          });
        } else if (state.status == RegisterStatus.success) {
          AppToast.showToast(
            context: context,
            title: 'Successfully created account',
            type: ToastificationType.success,
            description: '',
          );
          context.pop();
          context.pushNamedAndRemoveUntil(Routes.login);
        } else if (state.status == RegisterStatus.loading) {
          AppDialogs.showLoadingDialog(context);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.hp(7)),
            Align(
              alignment: Alignment.center,
              child: BounceInDown(
                from: 50,
                child: const CircularPercentIndicatorWidget(index: 6),
              ),
            ),
            SizedBox(height: context.hp(3)),
            Padding(
              padding: EdgeInsetsDirectional.only(start: screenWidth * 0.05),
              child: AnimationText(
                child: Text(
                  LocaleKeys.Authentication_yourRegularPhysical.tr(),
                  style: AppTheme.lightTheme.textTheme.labelLarge,
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: screenWidth * 0.05),
              child: AnimationText(
                millDelay: 1200,
                child: Text(
                  LocaleKeys.Authentication_activityLevel.tr(),
                  style: AppTheme.lightTheme.textTheme.labelLarge!
                      .copyWith(fontSize: screenHeight * 0.022),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            SizedBox(height: context.hp(2)),
            CustomAuthContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  ...List.generate(activity.length, (index) {
                    return SelectWidget(
                      title: activity[index],
                      selected: index == selectedIndex,
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    );
                  }),
                  SizedBox(height: screenHeight * 0.02),
                  BounceInDown(
                    delay: const Duration(milliseconds: 700),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, screenHeight * 0.06),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenHeight * 0.03),
                        ),
                      ),
                      onPressed: () {
                        final level = 'level${selectedIndex + 1}';
                        cubit.indexActivityLevel = selectedIndex;
                        cubit.activityLevel = level;
                        cubit.register();
                      },
                      child: Text(
                        LocaleKeys.Authentication_next.tr(),
                        style: AppTheme.lightTheme.textTheme.labelLarge,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectWidget extends StatelessWidget {
  const SelectWidget({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.02),
        child: Container(
          width: double.infinity,
          height: screenHeight * 0.06,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.8,
              color: Colors.white.withAlpha((0.5 * 255).toInt()),
            ),
            color: AppColors.lightGray.withAlpha((0.2 * 255).toInt()),
            borderRadius: BorderRadius.circular(screenHeight * 0.03),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: screenWidth * 0.05),
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyMedium!
                      .copyWith(fontSize: screenHeight * 0.02),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(end: screenWidth * 0.05),
                child: Container(
                  height: screenHeight * 0.023,
                  width: screenHeight * 0.023,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white70, width: 1.5),
                  ),
                  child: selected
                      ? Container(
                    margin: EdgeInsets.all(screenHeight * 0.003),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gray,
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}