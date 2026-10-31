import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:koki/core/resources/assets_manager.dart';
import 'package:koki/core/resources/color_manager.dart';
import 'package:koki/core/routes_manager/routes.dart';
import 'package:koki/domain/entities/product_entity.dart';
import 'package:koki/features/favourites/widgets/favorite_button.dart';

import '../../../../core/network/cubit/network_cubit.dart';
import '../../../../core/network/widget/top_network_banner.dart';
import '../../cart/cubit/cart_cubit.dart';

class FavouriteItemCardWidget extends StatelessWidget {
  final ProductEntity product;

  const FavouriteItemCardWidget({
    super.key,
    required this.product,
  });

  int _getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid.hashCode.abs();
    }
    return 1;
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
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 90.w,
              height: 90.h,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      product.thumbnail,
                      width: 90.w,
                      height: 90.h,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: ColorManager.grey,
                          size: 32.sp,
                        ),
                      ),
                    ),
                  ),
                  if (product.onSale && product.discountPercentage > 0)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          "${product.discountPercentage.round()}%",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  if (product.onSale)
                    Text(
                      "${product.oldPrice.toStringAsFixed(2)} EGP",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    "${product.price.toStringAsFixed(2)} EGP",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FavoriteButton(product: product),
                SizedBox(height: 16.h),
                InkWell(
                  onTap: () async {
                    final isConnected =
                    await context.read<NetworkCubit>().checkConnection();
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
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                color: ColorManager.white,
                                size: 24,
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
                          elevation: 4,
                          behavior: SnackBarBehavior.fixed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: ColorManager.primary,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      SvgAssets.basketCart,
                      width: 18.w,
                      height: 18.h,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
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
    );
  }
}