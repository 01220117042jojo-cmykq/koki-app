import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/color_manager.dart';
import 'package:koki/domain/entities/product_entity.dart';
import 'package:koki/features/home/presentation/widgets/categories_grid_widget.dart';
import 'package:koki/features/home/presentation/widgets/home_header_widget.dart';
import 'package:koki/features/home/presentation/widgets/product_card_widget.dart';
import 'package:koki/features/home/presentation/widgets/select_branch_first_widget.dart';
import 'package:koki/features/location/cubit/location_cubit.dart';
import 'package:koki/features/location/cubit/location_states.dart';
import 'package:koki/features/location/map_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../domain/entities/address_entity.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_states.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final ProductEntity _dummyProduct = ProductEntity(
    id: 0,
    title: 'Loading Product Name Placeholder',
    description: '',
    price: 99.99,
    discountPercentage: 15.0,
    thumbnail: '',
    images: [],
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final locationCubit = context.read<LocationCubit>();
      await locationCubit.loadSelectedAddress();

      if (mounted && locationCubit.selectedAddress == null) {
        _openMapToSelectLocation(context);
      }
    });
  }

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

        return BlocBuilder<HomeCubit, HomeStates>(
          builder: (context, state) {
            final cubit = HomeCubit.get(context);

            final bool isHomeLoading =
                (state is HomeGetTabletsLoadingState && cubit.cachedTablets.isEmpty) ||
                    (state is HomeGetBeautyLoadingState && cubit.cachedBeauty.isEmpty) ||
                    (state is HomeGetSkinCareLoadingState && cubit.cachedSkinCare.isEmpty) ||
                    (state is HomeGetWomensBagsLoadingState && cubit.cachedWomensBags.isEmpty);

            return Scaffold(
              backgroundColor: ColorManager.sectionBackground,
              body: Skeletonizer(
                enabled: isHomeLoading,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeHeaderWidget(),
                      SizedBox(height: 24.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          "explore_koki_categories".tr(),
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.black,
                          ),
                        ),
                      ),
                      const CategoriesGridWidget(),
                      SizedBox(height: 24.h),
                      _buildSectionTitle('tablets'.tr()),
                      SizedBox(height: 12.h),
                      _buildProductList(
                        isHomeLoading && cubit.cachedTablets.isEmpty
                            ? List.generate(4, (_) => _dummyProduct)
                            : cubit.cachedTablets,
                        260.h,
                      ),
                      SizedBox(height: 24.h),
                      _buildSectionTitle('beauty'.tr()),
                      SizedBox(height: 12.h),
                      _buildProductList(
                        isHomeLoading && cubit.cachedBeauty.isEmpty
                            ? List.generate(4, (_) => _dummyProduct)
                            : cubit.cachedBeauty,
                        250.h,
                      ),
                      SizedBox(height: 24.h),
                      _buildSectionTitle('skin_care'.tr()),
                      SizedBox(height: 12.h),
                      _buildProductList(
                        isHomeLoading && cubit.cachedSkinCare.isEmpty
                            ? List.generate(4, (_) => _dummyProduct)
                            : cubit.cachedSkinCare,
                        250.h,
                      ),
                      SizedBox(height: 24.h),
                      _buildSectionTitle('women_bags'.tr()),
                      SizedBox(height: 12.h),
                      _buildProductList(
                        isHomeLoading && cubit.cachedWomensBags.isEmpty
                            ? List.generate(4, (_) => _dummyProduct)
                            : cubit.cachedWomensBags,
                        250.h,
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: ColorManager.black,
        ),
      ),
    );
  }

  Widget _buildProductList(List products, double height) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (_, __) => SizedBox(width: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCardWidget(
            product: products[index],
          );
        },
      ),
    );
  }
}