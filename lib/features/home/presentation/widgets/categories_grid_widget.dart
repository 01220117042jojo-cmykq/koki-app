import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/color_manager.dart';
import 'package:koki/domain/entities/category_entity.dart';
import 'package:koki/features/main_layout/cubit/main_layout_cubit.dart';
import '../../../../core/widget/custom_skeletonizer.dart';
import '../../../category/cubit/category_cubit.dart';
import '../../../category/cubit/category_products_cubit.dart';
import '../../../category/cubit/category_products_states.dart';
import '../../../category/cubit/category_states.dart';
import 'category_item_widget.dart';

class CategoriesGridWidget extends StatelessWidget {
  const CategoriesGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryStates>(
      builder: (context, state) {
        final isLoading = state is CategoryLoadingState;

        if (state is CategoryErrorState) {
          return Center(
            child: Text(
              state.errorMessage,
              style: TextStyle(color: ColorManager.red, fontSize: 14.sp),
            ),
          );
        }

        final List<CategoryEntity> categories = isLoading
            ? List.generate(
          6,
              (index) => CategoryEntity(
            name: 'Category $index',
            slug: 'category-$index',
          ),
        )
            : (state is CategorySuccessState ? state.categories : []);

        if (categories.isEmpty && !isLoading) {
          return const SizedBox.shrink();
        }

        return CustomSkeletonizer(
          isLoading: isLoading,
          child: BlocBuilder<CategoryProductsCubit, CategoryProductsStates>(
            builder: (context, productsState) {
              final categoryProducts =
              productsState is CategoryProductsSuccessState
                  ? productsState.categoryProducts
                  : {};

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 14.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: categories.take(9).length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final products = categoryProducts[category.slug] ?? [];
                    final String? categoryImage =
                    products.isNotEmpty ? products.first.thumbnail : null;

                    return CategoryItemWidget(
                      category: category,
                      categoryImage: categoryImage,
                      onTap: () {
                        if (!isLoading) {
                          context
                              .read<MainLayoutCubit>()
                              .navigateToCategory(index);
                        }
                      },
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}