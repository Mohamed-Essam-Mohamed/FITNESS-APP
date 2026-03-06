import 'package:animate_do/animate_do.dart';
import 'package:fitness_app/feature/auth/presentation/view_model/register/register_cubit.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/animation_text.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/circular_percent_indicator_widget.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/custom_auth_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/extensions/media_query_extensions.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/generated/locale_keys.g.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key, required this.pageController});
  final PageController pageController;
  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

late RegisterCubit cubit;

class _GoalScreenState extends State<GoalScreen> {
  int selectedIndex = 0;

  final List<String> goals = [
    LocaleKeys.Authentication_gainWeight.tr(),
    LocaleKeys.Authentication_loseWeight.tr(),
    LocaleKeys.Authentication_getFitter.tr(),
    LocaleKeys.Authentication_gainMoreFlexible.tr(),
    LocaleKeys.Authentication_learnTheBasic.tr(),
  ];

  @override
  void initState() {
    super.initState();
    cubit = context.read<RegisterCubit>();
    selectedIndex = cubit.indexGoal;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.hp(7)),
          Align(
            alignment: Alignment.center,
            child: BounceInDown(
              from: 50,
              child: const CircularPercentIndicatorWidget(index: 5),
            ),
          ),
          SizedBox(height: context.hp(3)),
          Padding(
            padding: EdgeInsetsDirectional.only(start: screenWidth * 0.05),
            child: AnimationText(
              child: Text(
                LocaleKeys.Authentication_whatIsYourGoal.tr(),
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
                LocaleKeys.Authentication_goalDescription.tr(),
                style: AppTheme.lightTheme.textTheme.titleMedium!
                    .copyWith(fontSize: screenHeight * 0.02),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          SizedBox(height: context.hp(2)),
          CustomAuthContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(goals.length, (index) {
                  return SelectWidget(
                    title: goals[index],
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
                      final selectedGoal = goals[selectedIndex];
                      cubit.indexGoal = selectedIndex;
                      cubit.goal = selectedGoal;
                      widget.pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
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