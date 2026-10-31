import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/features/home/presentation/widgets/select_branch_first_widget.dart';
import 'package:koki/features/location/cubit/location_cubit.dart';
import 'package:koki/features/location/cubit/location_states.dart';
import 'package:koki/features/location/map_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/network/widget/custom_network_image.dart';
import '../../core/resources/assets_manager.dart';
import '../../core/resources/color_manager.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/offer_entity.dart';
import 'cubit/offers_cubit.dart';
import 'cubit/offers_states.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  static final OfferEntity _dummyOffer = OfferEntity(
    id: 0,
    imageUrl: '',
    title: 'Loading Special Offer Title Placeholder',
  );

  Future<void> _openMapToSelectLocation(BuildContext context) async {
    final result = await Navigator.push<SelectedLocationModel>(
      context,
      MaterialPageRoute(
        builder: (_) => const MapScreen(showCloseButton: true),
      ),
    );

    if (result != null && context.mounted) {
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

        return Scaffold(
          backgroundColor: ColorManager.white,
          body: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 30.h),
              Expanded(
                child: BlocBuilder<OffersCubit, OffersStates>(
                  builder: (context, state) {
                    if (state is OffersLoadingState) {
                      return Skeletonizer(
                        enabled: true,
                        child: _buildOffersSkeleton(),
                      );
                    }
                    if (state is OffersSuccessState) {
                      if (state.offers.isEmpty) {
                        return Center(child: Text('no_offers_available'.tr()));
                      }
                      return Skeletonizer(
                        enabled: false,
                        child: _buildOffersSwiper(context, state),
                      );
                    }
                    if (state is OffersErrorState) {
                      return Center(
                        child: Text(
                          state.errorMessage.tr(),
                          style: TextStyle(
                            color: ColorManager.red,
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 130.h,
          color: ColorManager.primary,
          child: Center(
            child: Text(
              "offers".tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Image.asset(
          ImageAssets.frame_home,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
      ],
    );
  }

  Widget _buildOffersSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 300.w,
            height: 300.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
        ),
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            _dummyOffer.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOffersSwiper(BuildContext context, OffersSuccessState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: 300.h,
            width: 300.w,
            child: CardSwiper(
              cardsCount: state.offers.length,
              numberOfCardsDisplayed: state.offers.length > 1 ? 2 : 1,
              isDisabled: false,
              onSwipe: (previousIndex, currentIndexReturned, direction) {
                context.read<OffersCubit>().changeIndex(
                  currentIndexReturned ?? 0,
                );
                return true;
              },
              cardBuilder: (context, index, percenX, percenY) {
                final offer = state.offers[index];
                return Container(
                  width: 300.w,
                  height: 300.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: CustomNetworkImage(
                      imageUrl: offer.imageUrl,
                      width: 300.w,
                      height: 300.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            state.offers[state.currentIndex].title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.black,
            ),
          ),
        ),
      ],
    );
  }
}