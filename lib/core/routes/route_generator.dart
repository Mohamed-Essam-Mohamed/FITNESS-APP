import 'package:fitness_app/core/routes/routes.dart';
import 'package:fitness_app/core/di/service_locator.dart';
import 'package:fitness_app/core/routes/animation_routes.dart';
import 'package:fitness_app/feature/Exercise/presentation/view/exercise.dart';
import 'package:fitness_app/feature/app_section/view/app_sections.dart';
import 'package:fitness_app/feature/auth/presentation/view/register_view.dart';
import 'package:fitness_app/feature/auth/presentation/view_model/register/register_cubit.dart';
import 'package:fitness_app/feature/chat_ai/presentation/view/smart_coach_screen.dart';
import 'package:fitness_app/feature/chat_ai/presentation/view/onboarding_smart_coach.dart';
import 'package:fitness_app/feature/meals/presentation/entity/meal_details_screen_args.dart';
import 'package:fitness_app/feature/meals/presentation/view/food_details_screen.dart';
import 'package:fitness_app/feature/profile/presentation/view/edit_profile_screen.dart';
import 'package:fitness_app/feature/profile/presentation/view_model/profile/profile_cubit.dart';
import 'package:fitness_app/feature/meals/presentation/view/food_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/feature/auth/presentation/view/change_password_screen.dart';
import 'package:fitness_app/feature/auth/presentation/view/forget_password_screen.dart';
import 'package:fitness_app/feature/auth/presentation/view/verify_code_screen.dart';
import 'package:fitness_app/feature/auth/presentation/view_model/forget_password/forget_password_cubit.dart';
import 'package:fitness_app/feature/auth/presentation/view/login_screen.dart';
import 'package:fitness_app/feature/onboarding/view/onboarding_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic>? getRoute(RouteSettings settings) {
    final arg = settings.arguments;
    switch (settings.name) {
      case Routes.forgotPassword:
        return AnimationRoute(
          page: BlocProvider<ForgetPasswordCubit>(
            create: (context) => serviceLocator<ForgetPasswordCubit>(),
            child: const ForgetPasswordScreen(),
          ),
        );
      case Routes.verifyCode:
        return AnimationRoute(
          page: BlocProvider.value(
            value: arg as ForgetPasswordCubit,
            child: const VerifyCodeScreen(),
          ),
        );
      case Routes.changePassword:
        return AnimationRoute(
          page: BlocProvider<ForgetPasswordCubit>(
            create: (context) => serviceLocator<ForgetPasswordCubit>(),
            child: const ChangePasswordScreen(),
          ),
        );
      case Routes.onboarding:
        return AnimationRoute(page: const OnboardingScreen());
      case Routes.appSection:
        return AnimationRoute(page: const AppSection());
      case Routes.login:
        return AnimationRoute(page: const LoginScreen());

      case Routes.exercise:
        return AnimationRoute(
          page: const ExerciseScreen(
            primeMoverId: '',
          ),
        );
      case Routes.foodScreen:
        return AnimationRoute(page: const FoodRecommendationScreen());
      case Routes.smartCoachScreen:
        return AnimationRoute(page: const SmartCoachScreen());
      case Routes.onboardingSmartCoachScreen:
        return AnimationRoute(page: const OnboardingSmartCoachScreen());

      case Routes.mealDetails:
        final mealDetailsScreenArgs = arg as MealDetailsScreenArgs;
        return AnimationRoute(
          page: MealDetailsScreen(
            mealId: mealDetailsScreenArgs.mealId,
            meals: mealDetailsScreenArgs.meals,
          ),
        );

      case Routes.registerView:
        return AnimationRoute(
          page: BlocProvider.value(
            value: serviceLocator.get<RegisterCubit>(),
            child: const RegisterView(),
          ),
        );
      case Routes.editProfile:
        final editProfileScreenArgs = arg as ProfileCubit;
        return AnimationRoute(
          page: EditProfileScreen(

          ),
        );

      default:
        return null;
    }
  }
}
