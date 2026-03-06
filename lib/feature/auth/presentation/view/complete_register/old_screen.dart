import 'package:animate_do/animate_do.dart';
import 'package:fitness_app/feature/auth/presentation/view_model/register/register_cubit.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/animation_text.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/circular_percent_indicator_widget.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/custom_auth_container.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/extensions/media_query_extensions.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/generated/locale_keys.g.dart';

class OldScreen extends StatefulWidget {
  const OldScreen({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<OldScreen> createState() => _OldScreenState();
}

late RegisterCubit cubit;

class _OldScreenState extends State<OldScreen> {
  late ScrollController _scrollController;
  late double itemWidth;
  late int age;

  final int paddingItems = 3;
  final int numbersCount = 100;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    cubit = context.read<RegisterCubit>();
    age = cubit.age;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToAge(age);
      _scrollController.addListener(_onScroll);
    });
  }

  void _onScroll() {
    final offset =
        _scrollController.offset + MediaQuery.of(context).size.width / 2 - itemWidth / 2;

    final index = (offset / itemWidth).round();

    final newAge = (index - paddingItems + 1).clamp(1, numbersCount);

    if (newAge != age) {
      setState(() {
        age = newAge;
      });
    }
  }

  void _scrollToAge(int age) {
    final offset = ((age - 1 + paddingItems) * itemWidth) -
        MediaQuery.of(context).size.width / 2 +
        itemWidth / 2;

    _scrollController.jumpTo(offset);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    itemWidth = MediaQuery.of(context).size.width * 0.16;
    final totalItems = numbersCount + paddingItems * 2;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.hp(9)),

          Align(
            alignment: Alignment.center,
            child: BounceInDown(
              from: 50,
              child: const CircularPercentIndicatorWidget(index: 2),
            ),
          ),

          SizedBox(height: context.hp(3)),

          Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: AnimationText(
              child: Text(
                LocaleKeys.Authentication_howOldAreYou.tr(),
                style: AppTheme.lightTheme.textTheme.labelLarge,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: AnimationText(
              millDelay: 1200,
              child: Text(
                LocaleKeys.Authentication_goalDescription.tr(),
                style: AppTheme.lightTheme.textTheme.titleMedium!
                    .copyWith(fontSize: 16),
              ),
            ),
          ),

          SizedBox(height: context.hp(2)),

          SizedBox(
            width: double.infinity,
            height: context.hp(41),
            child: CustomAuthContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.Authentication_unitYear.tr(),
                    style: const TextStyle(
                      color: AppColors.orange,
                      fontSize: 10,
                    ),
                  ),

                  SizedBox(
                    height: context.hp(13),
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: totalItems,
                      itemBuilder: (context, index) {
                        final realIndex = index - paddingItems;

                        if (realIndex < 0 || realIndex >= numbersCount) {
                          return SizedBox(width: itemWidth);
                        }

                        final number = realIndex + 1;

                        final viewportCenter = _scrollController.offset +
                            MediaQuery.of(context).size.width / 2;

                        final itemCenter = index * itemWidth + itemWidth / 2;

                        final distanceFromCenter =
                        (viewportCenter - itemCenter).abs();

                        final scale =
                        (1.0 - (distanceFromCenter / (itemWidth * 4)))
                            .clamp(0.5, 1.0);

                        final fontSize = 36.0 * scale;

                        return Container(
                          width: itemWidth,
                          alignment: Alignment.center,
                          child: Text(
                            number.toString(),
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w700,
                              color: number == age
                                  ? AppColors.orange
                                  : Colors.white.withAlpha(
                                (((1.1 -
                                    (distanceFromCenter /
                                        (itemWidth * 4)))
                                    .clamp(0.2, 1.0)) *
                                    255)
                                    .round(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const Icon(
                    Icons.arrow_drop_up,
                    size: 50,
                    color: AppColors.orange,
                  ),

                  const SizedBox(height: 24),

                  BounceInDown(
                    delay: const Duration(milliseconds: 700),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(30),
                      ),
                      onPressed: () {
                        cubit.age = age;

                        widget.pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(LocaleKeys.Authentication_next.tr()),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}