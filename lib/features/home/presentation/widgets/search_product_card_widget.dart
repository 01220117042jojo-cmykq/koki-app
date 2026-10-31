import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:koki/core/resources/assets_manager.dart';
import 'package:koki/core/widget/custom_loading_indicator.dart';

import '../../../../core/network/cubit/network_cubit.dart';
import '../../../../core/network/widget/top_network_banner.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/routes_manager/routes.dart';
import '../../../../domain/entities/product_entity.dart';
import '../../../cart/cubit/cart_cubit.dart';
import '../../../favourites/widgets/favorite_button.dart';

class SearchProductCardWidget extends StatelessWidget {
  final ProductEntity product;

  const SearchProductCardWidget({super.key, required this.product});

  int _getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? user.uid.hashCode.abs() : CartCubit.guestUserId;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final isConnected =
        await context.read<NetworkCubit>().checkConnection();
        if (!isConnected) {
          if (context.mounted) {
            TopNetworkBanner.show(context);
          }
          return;
        }

        if (context.mounted) {
          Navigator.pushNamed(
            context,
            Routes.productDetailsScreen,
            arguments: product.id,
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: ColorManager.grey.withOpacity(0.15),
            width: 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 90.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.all(6.w),
                  child: Image.network(
                    product.thumbnail,
                    width: double.infinity,
                    height: 100.h,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CustomLoadingIndicator(size: 30.sp),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: ColorManager.grey,
                        size: 32.sp,
                      ),
                    ),
                  ),
                ),
                if (product.onSale)
                  Positioned(
                    top: 4.h,
                    left: 4.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF008744),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '-${product.discountPercentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: ColorManager.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorManager.darkSlate,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.onSale)
                              Text(
                                '${product.oldPrice.toStringAsFixed(2)} EGP',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  overflow: TextOverflow.ellipsis,
                                  color: ColorManager.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            SizedBox(height: 2.h),
                            Text(
                              '${product.price.toStringAsFixed(2)} EGP',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 14.sp,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w800,
                                color: ColorManager.darkSlate,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          FavoriteButton(product: product),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: () async {
                              final isConnected = await context
                                  .read<NetworkCubit>()
                                  .checkConnection();
                              if (!isConnected) {
                                if (context.mounted) {
                                  TopNetworkBanner.show(context);
                                }
                                return;
                              }

                              final int userId = _getCurrentUserId();

                              if (context.mounted) {
                                final cartCubit = context.read<CartCubit>();

                                await cartCubit.addToCart(
                                  userId: userId,
                                  product: product,
                                  quantity: 1,
                                );

                                cartCubit.getCart(userId);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  // SnackBar(
                                  //   content: Row(
                                  //     children: [
                                  //       Icon(
                                  //         Icons.check_circle_outline_rounded,
                                  //         color: ColorManager.white,
                                  //         size: 24,
                                  //       ),
                                  //       SizedBox(width: 12.w),
                                  //       Expanded(
                                  //         child: Text(
                                  //           "product_added_to_cart_success".tr(),
                                  //           style: TextStyle(
                                  //             fontSize: 15.sp,
                                  //             fontWeight: FontWeight.w500,
                                  //             color: Colors.white,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  //   backgroundColor: ColorManager.primary,
                                  //   elevation: 4,
                                  //   behavior: SnackBarBehavior.fixed,
                                  //   shape: RoundedRectangleBorder(
                                  //     borderRadius:
                                  //     BorderRadius.circular(12.r),
                                  //   ),
                                  //   duration: const Duration(seconds: 2),
                                  // ),
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: ColorManager.white,
                                          size: 24.sp,
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Text(
                                            "product_added_to_cart_success".tr(),
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: ColorManager.primary,
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: ColorManager.primary,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                SvgAssets.basketCart,
                                width: 16.w,
                                height: 16.h,
                                colorFilter: ColorFilter.mode(
                                  ColorManager.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}