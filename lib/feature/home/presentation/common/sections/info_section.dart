import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/common/widget/custom_cache_network_image.dart';
import 'package:fitness_app/core/dummy/dummy_constant.dart';
import 'package:fitness_app/feature/home/presentation/view_model/home_cubit.dart';
import 'package:fitness_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
/// this the static data waiting for api response to be future
/// can be get from shared preference but not in this case
class InfoSection extends StatefulWidget {
  const InfoSection({
    super.key,
  });

  @override
  State<InfoSection> createState() => _InfoSectionState();
}

class _InfoSectionState extends State<InfoSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: state.isDataInfoLoading,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: state.isDataInfoLoading
                            ? dummyText
                            : '${LocaleKeys.Home_hi.tr()} ${state.dataUser.firstName},\n',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(height: 1.40, fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: LocaleKeys.Home_LetsStartYourDay.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(height: 1.40, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                CustomCacheNetworkImage(
                  imageUrl: state.isDataInfoLoading
                      ? dummyImageProfileUrl
                      : state.dataUser.photo,
                  isCircular: true,
                  width: 40,
                  height: 40,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
