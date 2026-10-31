import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/domain/entities/category_entity.dart';
import 'package:koki/domain/entities/product_entity.dart';
import 'package:koki/features/home/presentation/widgets/select_branch_first_widget.dart';
import 'package:koki/features/location/cubit/location_cubit.dart';
import 'package:koki/features/location/cubit/location_states.dart';
import 'package:koki/features/location/map_screen.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/resources/assets_manager.dart';
import '../../core/resources/color_manager.dart';
import '../../domain/entities/address_entity.dart';
import '../category/widgets/category_horizontal_product_card.dart';
import '../category/widgets/category_tab_item.dart';
import '../main_layout/cubit/main_layout_cubit.dart';
import 'cubit/category_cubit.dart';
import 'cubit/category_products_cubit.dart';
import 'cubit/category_products_states.dart';
import 'cubit/category_states.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  int _lastIndex = -1;
  @override
  void initState() {
    super.initState();
    final categoryCubit = context.read<CategoryCubit>();
    categoryCubit.getCategories();
  }

  static final List<CategoryEntity> _dummyCategories = List.generate(
    5,
        (index) => CategoryEntity(
      name: 'Category $index',
      slug: 'category-$index',
    ),
  );

  static final ProductEntity _dummyProduct = ProductEntity(
    id: 0,
    title: 'Loading Category Product Placeholder Title',
    description: '',
    price: 150.0,
    discountPercentage: 10.0,
    thumbnail: '',
    images: [],
  );

  Future<void> _openMapToSelectLocation(BuildContext context) async {
    final result = await Navigator.push<SelectedLocationModel>(
      context,
      MaterialPageRoute(
        builder: (_) => const MapScreen(showCloseButton: true),
      ),
    );

    if (result != null && mounted) {
      final locationCubit = context.read<LocationCubit>();
      final newAddress = AddressEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        label: 'Selected Location',
        addressDetails: result.address,
        phone: '',
        buildingNo: '',
        floorNo: '',
        lat: result.latitude,
        lon: result.longitude,
      );
      await locationCubit.selectAddress(newAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationStates>(
      builder: (context, locationState) {
        final locationCubit = context.read<LocationCubit>();
        final bool hasSelectedAddress = locationCubit.selectedAddress != null;

        if (!hasSelectedAddress) {
          return Scaffold(
            backgroundColor: ColorManager.sectionBackground,
            body: SelectBranchFirstWidget(
              onSelectBranchPressed: () => _openMapToSelectLocation(context),
            ),
          );
        }

        final targetIndex = context.watch<MainLayoutCubit>().selectedCategoryIndex;

        if (_lastIndex != targetIndex) {
          _lastIndex = targetIndex;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_itemScrollController.isAttached) {
              _itemScrollController.scrollTo(
                index: targetIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          });
        }

        return Scaffold(
          backgroundColor: ColorManager.white,
          body: BlocConsumer<CategoryCubit, CategoryStates>(
            listener: (context, categoryState) {
              if (categoryState is CategorySuccessState) {
                context
                    .read<CategoryProductsCubit>()
                    .loadAllCategoryProducts(categoryState.categories);
              }
            },
            builder: (context, categoryState) {
              final isCategoryLoading = categoryState is CategoryLoadingState;

              if (categoryState is CategorySuccessState) {
                final productsCubit = context.read<CategoryProductsCubit>();
                if (productsCubit.state is CategoryProductsInitialState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    productsCubit.loadAllCategoryProducts(categoryState.categories);
                  });
                }
              }

              return BlocBuilder<CategoryProductsCubit, CategoryProductsStates>(
                builder: (context, productsState) {
                  final isProductsLoading =
                  productsState is CategoryProductsLoadingState;

                  final bool isLoading = isCategoryLoading || isProductsLoading;

                  final categories = (categoryState is CategorySuccessState)
                      ? categoryState.categories
                      : _dummyCategories;

                  final Map<String, List<ProductEntity>> categoryProducts =
                  (productsState is CategoryProductsSuccessState)
                      ? productsState.categoryProducts
                      : {};

                  return Skeletonizer(
                    enabled: isLoading,
                    child: _buildCategoryContent(
                      context,
                      categories,
                      categoryProducts,
                      targetIndex,
                      isLoading,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryContent(
      BuildContext context,
      List<CategoryEntity> categories,
      Map<String, List<ProductEntity>> categoryProducts,
      int targetIndex,
      bool isLoading,
      ) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 70.h,
          color: ColorManager.primary,
          child: SafeArea(
            bottom: false,
            child: Center(
              child: Text(
                "category".tr(),
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ScrollableListTabScroller(
            initialScrollIndex: targetIndex,
            itemScrollController: _itemScrollController,
            itemCount: categories.length,
            headerContainerBuilder: (context, child) {
              return Container(
                height: 100.h,
                color: ColorManager.primary,
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: child,
              );
            },
            tabBuilder: (context, index, active) {
              final category = categories[index];
              final products = categoryProducts[category.slug] ?? [];
              final String? categoryImage =
              products.isNotEmpty ? products.first.thumbnail : null;

              return CategoryTabItem(
                categoryName: category.name,
                categoryImage: categoryImage,
                isActive: active,
              );
            },
            itemBuilder: (context, index) {
              final category = categories[index];
              final products = isLoading
                  ? List.generate(3, (_) => _dummyProduct)
                  : (categoryProducts[category.slug] ?? []);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 0)
                    Image.asset(
                      ImageAssets.frame_home,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.black,
                      ),
                    ),
                  ),
                  products.isEmpty
                      ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text('no_products_available'.tr()),
                    ),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, pIndex) {
                      return CategoryHorizontalProductCard(
                        product: products[pIndex],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}