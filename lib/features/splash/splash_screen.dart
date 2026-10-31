import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/assets_manager.dart';
import 'package:koki/core/resources/color_manager.dart';
import '../../core/di/service_locator.dart';
import '../../core/routes_manager/routes.dart';
import 'cubit/splash_cubit.dart';
import 'cubit/splash_states.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double targetWidth = size.width * 0.58;
    final double targetHeight = targetWidth * (173.6 / 190.4);

    return BlocProvider(
      create: (context) => getIt<SplashCubit>()..checkNavigationTarget(),
      child: BlocListener<SplashCubit, SplashStates>(
        listener: (context, state) {
          String nextRoute = Routes.langueageRoute;

          if (state is NavigateToMainLayoutState) {
            nextRoute = Routes.mainRoute;
          } else if (state is NavigateToLoginState) {
            nextRoute = Routes.signInRoute;
          } else if (state is NavigateToOnboardingState) {
            nextRoute = Routes.langueageRoute;
          }

          Navigator.pushReplacementNamed(context, nextRoute);
        },
        child: Scaffold(
          backgroundColor: ColorManager.primary,
          body: Stack(
            children: [
              OverflowBox(
                maxWidth: size.width * 1.06,
                maxHeight: size.height * 1.06,
                child: Image.asset(
                  ImageAssets.splashW,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 34.0.w, top: 75.0.h),
                child: Center(
                  child: Hero(
                    tag: "logoTag",
                    child: TweenAnimationBuilder(
                      tween: Tween(end: 1.25, begin: 0.25),
                      duration: const Duration(milliseconds: 3500),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return SizedBox(
                          width: targetWidth * value,
                          height: targetHeight * value,
                          child: child,
                        );
                      },
                      child: Image.asset(ImageAssets.logo, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}