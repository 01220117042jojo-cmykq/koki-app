import 'package:easy_localization/easy_localization.dart';
import 'package:koki/core/resources/assets_manager.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String subTitle;

  OnboardingModel({
    required this.image,
    required this.subTitle,
    required this.title,
  });

  static List<OnboardingModel> getOnboardingData() {
    return [
      OnboardingModel(
        image: ImageAssets.firstBoarding,
        title: 'onboarding_title_1'.tr(),
        subTitle: 'onboarding_subtitle_1'.tr(),
      ),
      OnboardingModel(
        image: ImageAssets.secondBoarding,
        title: 'onboarding_title_2'.tr(),
        subTitle: 'onboarding_subtitle_2'.tr(),
      ),
      OnboardingModel(
        image: ImageAssets.girl,
        title: 'onboarding_title_3'.tr(),
        subTitle: 'onboarding_subtitle_3'.tr(),
      ),
    ];
  }
}