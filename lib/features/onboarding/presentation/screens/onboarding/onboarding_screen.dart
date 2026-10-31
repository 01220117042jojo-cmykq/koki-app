import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:koki/core/resources/assets_manager.dart';
import 'package:koki/core/resources/color_manager.dart';
import 'package:koki/core/widget/custom_elevates_button.dart';
import 'package:koki/features/onboarding/presentation/screens/onboarding/cubit/onboarding_cubit.dart';
import 'package:koki/features/onboarding/presentation/screens/onboarding/widgets/animated_onboarding_indicator.dart';
import 'package:koki/features/onboarding/presentation/screens/onboarding/widgets/onboarding_model.dart';
import 'package:koki/features/onboarding/presentation/screens/onboarding/widgets/onboarding_page_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/routes_manager/routes.dart';
import 'cubit/onboarding_states.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Timer? timer;

  void setupAutoPlay(OnboardingCubit cubit, int totalPages) {
    timer?.cancel();

    if (cubit.currentIndex >= totalPages - 1) return;
    timer = Timer(const Duration(seconds: 3), () {
      int nextIndex = cubit.currentIndex + 1;
      cubit.changePage(nextIndex);
      cubit.pageController.animateToPage(
        nextIndex,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<OnboardingModel> onboardingData =
        OnboardingModel.getOnboardingData();
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Scaffold(
        backgroundColor: ColorManager.white,
        body: SafeArea(
          child: BlocBuilder<OnboardingCubit, OnboardingStates>(
            builder: (context, state) {
              var cubit = BlocProvider.of<OnboardingCubit>(context);

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.h, bottom: 15.h),
                    child: Image.asset(ImageAssets.smallLogoKoki, height: 40.h),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: AnimatedOnboardingIndicator(
                      itemCount: onboardingData.length,
                      currentIndex: cubit.currentIndex,
                      onPageComplete: () {
                        if (cubit.currentIndex < onboardingData.length - 1) {
                          int nextIndex = cubit.currentIndex + 1;
                          cubit.changePage(nextIndex);
                          cubit.pageController.animateToPage(
                            nextIndex,
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: PageView.builder(
                      controller: cubit.pageController,
                      itemCount: onboardingData.length,
                      onPageChanged: (index) {
                        cubit.changePage(index);
                      },

                      itemBuilder: (context, index) => OnboardingPageItem(
                        model: onboardingData[index],
                        index: index,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 35.h,
                      left: 24.w,
                      right: 24.w,
                    ),
                    child: cubit.currentIndex < onboardingData.length - 1
                        ? Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  height: 54.h,
                                  child: CustomElevatedButton(
                                    label: 'continue_button'.tr(),                                    onTap: () =>
                                        cubit.nextLength(onboardingData.length),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: 54.h,
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      final prefs =
                                          GetIt.instance<SharedPreferences>();
                                      await prefs.setBool('isFirstTime', false);
                                      cubit.changePage(
                                        onboardingData.length - 1,
                                      );
                                      cubit.pageController.jumpToPage(
                                        onboardingData.length - 1,
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: ColorManager.coolGray
                                            .withOpacity(0.5),
                                        width: 1.w,
                                      ),
                                      shape: const StadiumBorder(),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Text(
                                      'skip'.tr(),
                                      style: TextStyle(
                                        color: ColorManager.primary,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 54.h,
                                  child: CustomElevatedButton(
                                    label: 'explore_app'.tr(),
                                    isStadiumBorder: true,
                                    onTap: () async {
                                      final prefs =
                                          GetIt.instance<SharedPreferences>();
                                      await prefs.setBool('isFirstTime', false);
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        Routes.mainRoute,
                                        (route) => false,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: 54.h,
                                  child: CustomElevatedButton(
                                    label: 'login'.tr(),
                                    isStadiumBorder: true,
                                    onTap: () async {
                                      final prefs =
                                          GetIt.instance<SharedPreferences>();
                                      await prefs.setBool('isFirstTime', false);
                                      Navigator.pushReplacementNamed(
                                        context,
                                        Routes.signInRoute,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
