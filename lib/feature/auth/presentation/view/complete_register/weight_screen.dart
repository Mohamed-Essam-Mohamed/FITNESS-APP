import 'package:animate_do/animate_do.dart';
import 'package:fitness_app/feature/auth/presentation/view_model/register/register_cubit.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/animation_text.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/circular_percent_indicator_widget.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/custom_auth_container.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/extensions/media_query_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/generated/locale_keys.g.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

late RegisterCubit cubit;

class _WeightScreenState extends State<WeightScreen> {
  bool get wantKeepAlive => true;

  late int weight;
  late ScrollController _scrollController;
  late double itemWidth;

  final int paddingItems = 3;
  final int numbersCount = 300;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    cubit = context.read<RegisterCubit>();
    weight = cubit.weight;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToWeight(weight);
      _scrollController.addListener(_onScroll);
    });
  }

  void _onScroll() {
    if (!mounted) return;
    final offset =
        _scrollController.offset + MediaQuery.of(context).size.width / 2 - itemWidth / 2;
    final index = (offset / itemWidth).round();
    final newWeight = (index - paddingItems + 1).clamp(1, numbersCount);
    if (newWeight != weight) {
      setState(() => weight = newWeight);
    }
  }

  void _scrollToWeight(int targetWeight) {
    final offset = ((targetWeight - 1 + paddingItems) * itemWidth) -
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    itemWidth = screenWidth * 0.16;
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
              child: const CircularPercentIndicatorWidget(index: 3),
            ),
          ),
          SizedBox(height: context.hp(3)),
          Padding(
            padding: EdgeInsetsDirectional.only(start: screenWidth * 0.05),
            child: AnimationText(
              child: Text(
                LocaleKeys.Authentication_whatIsYourWeight.tr(),
                style: AppTheme.lightTheme.textTheme.labelLarge,
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
                    .copyWith(fontSize: screenHeight * 0.022),
              ),
            ),
          ),
          SizedBox(height: context.hp(2)),
          CustomAuthContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Kg',
                  style: AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                    color: AppColors.orange,
                    fontSize: screenHeight * 0.015,
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
                      final viewportCenter = _scrollController.offset + screenWidth / 2;
                      final itemCenter = index * itemWidth + itemWidth / 2;
                      final distanceFromCenter = (viewportCenter - itemCenter).abs();
                      final scale = (1.0 - (distanceFromCenter / (itemWidth * 4))).clamp(0.5, 1.0);
                      final fontSize = 36.0 * scale;

                      return Container(
                        width: itemWidth,
                        alignment: Alignment.center,
                        child: Text(
                          number.toString(),
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w700,
                            color: number == weight
                                ? AppColors.orange
                                : Colors.white.withAlpha(
                              (((1.1 - (distanceFromCenter / (itemWidth * 4))).clamp(0.2, 1.0)) *
                                  255)
                                  .round(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Icon(
                  Icons.arrow_drop_up,
                  size: screenHeight * 0.07,
                  color: AppColors.orange,
                ),
                SizedBox(height: screenHeight * 0.03),
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
                      cubit.weight = weight;
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