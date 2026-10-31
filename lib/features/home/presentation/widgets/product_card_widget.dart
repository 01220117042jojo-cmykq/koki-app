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

class ProductCardWidget extends StatelessWidget {
  final ProductEntity product;

  const ProductCardWidget({super.key, required this.product});

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
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        width: 165.w,
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: ColorManager.grey.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: Padding(
                      padding:
                      EdgeInsets.only(top: 8.h, left: 12.w, right: 12.w),
                      child: Image.network(
                        product.thumbnail,
                        width: double.infinity,
                        height: 100.h,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: 100.h,
                            child: CustomLoadingIndicator(size: 35.sp),
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
                  ),
                  if (product.onSale)
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF008744),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Text(
                          '-${product.discountPercentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: FavoriteButton(product: product),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 12.w,
                    right: 12.w,
                    bottom: 12.h,
                    top: 4.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const Spacer(),
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
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: ColorManager.primary,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                SvgAssets.basketCart,
                                width: 18.w,
                                height: 18.h,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}