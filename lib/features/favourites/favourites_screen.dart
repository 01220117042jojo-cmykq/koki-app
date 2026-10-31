import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/color_manager.dart';
import 'package:koki/core/widget/custom_loading_indicator.dart';

import '../../../core/network/cubit/network_cubit.dart';
import '../../../core/network/cubit/network_state.dart';
import '../../../core/network/widget/offline_empty_state.dart';
import 'cubit/favourites_cubit.dart';
import 'cubit/favourites_states.dart';
import 'widgets/favourite_item_card_widget.dart';
import 'widgets/favourites_empty_state_widget.dart';
import 'widgets/favourites_header_widget.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: BlocBuilder<NetworkCubit, NetworkState>(
        builder: (context, networkState) {
          if (networkState is NetworkDisconnected) {
            return OfflineEmptyStateWidget(
              viewType: OfflineViewType.dog,
              onRetrySuccess: () {
                context.read<FavouritesCubit>().loadFavorites();
              },
            );
          }

          return Column(
            children: [
              const FavouritesHeaderWidget(),
              Expanded(
                child: BlocBuilder<FavouritesCubit, FavouritesStates>(
                  builder: (context, state) {
                    final cubit = context.read<FavouritesCubit>();

                    if (state is FavouritesLoadingState &&
                        cubit.favoriteProducts.isEmpty) {
                      return const Center(
                        child: CustomLoadingIndicator(),
                      );
                    }

                    if (state is FavouritesErrorState &&
                        cubit.favoriteProducts.isEmpty) {
                      return Center(
                        child: Text(
                          state.message,
                          style: TextStyle(
                            color: ColorManager.red,
                            fontSize: 16.sp,
                          ),
                        ),
                      );
                    }

                    final products = cubit.favoriteProducts;

                    if (products.isEmpty) {
                      return const FavouritesEmptyStateWidget();
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      itemCount: products.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        return FavouriteItemCardWidget(
                          product: products[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}