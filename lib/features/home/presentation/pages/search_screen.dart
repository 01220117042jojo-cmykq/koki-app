import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/widget/custom_loading_indicator.dart';
import 'package:koki/features/home/presentation/cubit/home_cubit.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';
import '../cubit/home_states.dart';
import '../widgets/search_empty_state.dart';
import '../widgets/search_product_card_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  Timer? debounce;

  void onSearchChanged(String value) {
    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        HomeCubit.get(context).searchHomeProducts(value.trim());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    HomeCubit.get(context).resetSearch();
  }

  @override
  void dispose() {
    debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: statusBarHeight + 16.h,
              left: 16.w,
              right: 16.w,
              bottom: 4.h,
            ),
            color: ColorManager.primaryDark,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: ColorManager.red,
                      size: 22.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    height: 46.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            autofocus: true,
                            onChanged: onSearchChanged,
                            decoration: InputDecoration(
                              hintText: "search_here".tr(),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.search,
                          color: ColorManager.navy,
                          size: 22.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            ImageAssets.frame_home,
            width: double.infinity,
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),

          Expanded(
            child: BlocBuilder<HomeCubit, HomeStates>(
              builder: (context, state) {
                if (state is HomeSearchProductsLoadingState) {
                  return const Center(
                    child: CustomLoadingIndicator(size: 70.0),
                  );
                }

                if (state is HomeSearchProductsErrorState) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: TextStyle(
                        color: ColorManager.red,
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }

                final products = HomeCubit.get(context).searchProductsList ?? [];

                if (products.isNotEmpty) {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: products.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
                          child: Text(
                            "search_results".tr(),
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.black,
                            ),
                          ),
                        );
                      }
                      return SearchProductCardWidget(
                        product: products[index - 1],
                      );
                    },
                  );
                }

                return const SearchEmptyState();
              },
            ),
          ),
        ],
      ),
    );
  }
}