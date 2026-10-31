import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/assets_manager.dart';
import 'package:koki/core/resources/color_manager.dart';
import 'package:koki/core/widget/custom_loading_indicator.dart';
import 'package:koki/domain/entities/product_entity.dart';
import 'package:koki/features/product_details/widgets/product_description.dart';
import 'package:koki/features/product_details/widgets/product_details_bottom_bar.dart';

import '../../core/network/cubit/network_cubit.dart';
import '../../core/network/widget/custom_network_image.dart';
import '../../core/network/widget/top_network_banner.dart';
import '../cart/cubit/cart_cubit.dart';
import '../favourites/widgets/favorite_button.dart';
import 'cubit/product_details_cubit.dart';
import 'cubit/product_details_states.dart';
import 'widgets/product_discount_badge.dart';
import 'widgets/product_info_header.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  int? _getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid.hashCode.abs();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ProductEntity? cachedProduct;

    return Scaffold(
      backgroundColor: ColorManager.white,
      body: BlocConsumer<ProductDetailsCubit, ProductDetailsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = context.read<ProductDetailsCubit>();

          if (state is ProductDetailsSuccessState) {
            cachedProduct = state.product;
          }

          if (state is ProductDetailsLoadingState && cachedProduct == null) {
            return const Center(
              child: CustomLoadingIndicator(),
            );
          }

          if (state is ProductDetailsErrorState && cachedProduct == null) {
            return Center(
              child: Text(
                state.errorMessage.tr(),
                style: TextStyle(color: ColorManager.red, fontSize: 14.sp),
              ),
            );
          }

          if (cachedProduct != null) {
            final product = cachedProduct!;

            return Scaffold(
              backgroundColor: ColorManager.white,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 340.h,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(ImageAssets.blurBackground),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 340.h,
                          alignment: Alignment.bottomCenter,
                          child: Image.asset(
                            ImageAssets.test,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 340.h,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 90.h, bottom: 10.h),
                          child: CustomNetworkImage(
                            imageUrl: product.images.isNotEmpty
                                ? product.images[cubit.selectedImageIndex]
                                : product.thumbnail,
                            height: 325.h,
                            width: 301.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 40.h,
                          left: 20.w,
                          right: 20.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                borderRadius: BorderRadius.circular(22.r),
                                child: Container(
                                  width: 44.w,
                                  height: 44.h,
                                  decoration: BoxDecoration(
                                    color: ColorManager.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: ColorManager.primary,
                                    size: 22.sp,
                                  ),
                                ),
                              ),

                              if (FirebaseAuth.instance.currentUser != null)
                                Container(
                                  width: 44.w,
                                  height: 44.h,
                                  decoration: BoxDecoration(
                                    color: ColorManager.white,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: FavoriteButton(product: product),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ProductDiscountBadge(
                      discountPercentage: product.discountPercentage,
                      onSale: product.onSale,
                    ),

                    SizedBox(
                      height: 70.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        itemCount: product.images.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => cubit.changeSelectedImage(index),
                            child: Container(
                              width: 60.w,
                              height: 60.h,
                              margin: EdgeInsets.symmetric(horizontal: 6.w),
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: ColorManager.white,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: cubit.selectedImageIndex == index
                                      ? ColorManager.primary
                                      : Colors.transparent,
                                  width: 2.w,
                                ),
                              ),
                              child: CustomNetworkImage(
                                imageUrl: product.images[index],
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      height: 8.h,
                      color: const Color(0xFFF5F5F5),
                    ),
                    ProductInfoHeader(
                      title: product.title,
                      price: product.price,
                      oldPrice: product.oldPrice,
                      onSale: product.onSale,
                    ),
                    Container(
                      width: double.infinity,
                      height: 8.h,
                      color: const Color(0xFFF5F5F5),
                    ),
                    ProductDescription(description: product.description),
                  ],
                ),
              ),
              bottomNavigationBar: ProductDetailsBottomBar(
                price: product.price,
                quantity: cubit.quantity,
                onIncrement: () => cubit.incrementQuantity(),
                onDecrement: () => cubit.decrementQuantity(),
                onAddToCart: () async {
                  final isConnected = await context.read<NetworkCubit>().checkConnection();
                  if (!isConnected) {
                    if (context.mounted) {
                      TopNetworkBanner.show(context);
                    }
                    return;
                  }

                  if (!context.mounted) return;

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext dialogContext) {
                      return const PopScope(
                        canPop: false,
                        child: Center(
                          child: CustomLoadingIndicator(),
                        ),
                      );
                    },
                  );

                  final int userId = _getCurrentUserId() ?? CartCubit.guestUserId;
                  final cartCubit = context.read<CartCubit>();

                  try {
                    await cartCubit.addToCart(
                      userId: userId,
                      product: product,
                      quantity: cubit.quantity,
                    );

                    cartCubit.getCart(userId);

                    await Future.delayed(const Duration(milliseconds: 500));

                  } finally {
                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
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

                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}