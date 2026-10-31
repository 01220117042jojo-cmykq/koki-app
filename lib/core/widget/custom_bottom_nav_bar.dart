
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:koki/core/resources/color_manager.dart';
import '../resources/assets_manager.dart';

import '../../features/cart/cubit/cart_cubit.dart';
import '../../features/cart/cubit/cart_states.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context);

    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        color: ColorManager.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildNavItem(
              index: 0,
              selectedSvgPath: SvgAssets.home_selected,
              unselectedSvgPath: SvgAssets.home,
              label: 'home'.tr(),
              isSelected: currentIndex == 0,
            ),
            buildNavItem(
              index: 1,
              selectedSvgPath: SvgAssets.category_selected,
              unselectedSvgPath: SvgAssets.category,
              label: 'category'.tr(),
              isSelected: currentIndex == 1,
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () => onTap(2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 54.w,
                    height: 54.h,
                    transform: Matrix4.translationValues(0, -6.h, 0),
                    decoration: BoxDecoration(
                      color: ColorManager.navy,
                      shape: BoxShape.circle,
                      border: currentIndex == 2
                          ? Border.all(color: ColorManager.red, width: 3.w)
                          : null,
                    ),
                    child: Center(
                      child: BlocBuilder<CartCubit, CartStates>(
                        builder: (context, state) {
                          int itemCount = 0;

                          if (state is CartSuccessState) {
                            itemCount = state.cart.products.length;
                          } else if (state is CartActionLoadingState) {
                            itemCount = state.previousCart.products.length;
                          }

                          return Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                SvgAssets.basketCart,
                                colorFilter: ColorFilter.mode(
                                  ColorManager.white,
                                  BlendMode.srcIn,
                                ),
                                width: 22.w,
                                height: 22.h,
                              ),

                              if (itemCount > 0)
                                Positioned(
                                  top: -6.h,
                                  right: -10.w,
                                  child: Container(
                                    padding: EdgeInsets.all(4.w),
                                    decoration: BoxDecoration(
                                      color: ColorManager.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: ColorManager.red,
                                        width: 1.5.w,
                                      ),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 18.w,
                                      minHeight: 18.w,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$itemCount',
                                      style: TextStyle(
                                        color: ColorManager.black,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            buildNavItem(
              index: 3,
              selectedSvgPath: SvgAssets.offers_selected,
              unselectedSvgPath: SvgAssets.percent,
              label: 'offers'.tr(),
              isSelected: currentIndex == 3,
            ),
            buildNavItem(
              index: 4,
              selectedSvgPath: SvgAssets.profile_selected,
              unselectedSvgPath: SvgAssets.profile,
              label: 'account_info'.tr(),
              isSelected: currentIndex == 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem({
    required int index,
    required String selectedSvgPath,
    required String unselectedSvgPath,
    required String label,
    required bool isSelected,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorManager.red.withOpacity(0.15),
                ColorManager.red.withOpacity(0.00),
              ],
            )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: double.infinity,
                height: 3.h,
                color: isSelected ? ColorManager.red : Colors.transparent,
              ),
              const Spacer(),
              SvgPicture.asset(
                isSelected ? selectedSvgPath : unselectedSvgPath,
                width: 24.w,
                height: 24.h,
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? ColorManager.red : ColorManager.black,
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
