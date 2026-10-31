import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koki/features/cart/cart_screen.dart';
import '../category/category_screen.dart';
import '../offers/offers_screen.dart';
import '../profile/cubit/profile_cubit.dart';
import 'package:koki/features/profile/profile_screen.dart';

import '../../core/di/service_locator.dart';
import '../../core/network/cubit/network_cubit.dart';
import '../../core/network/cubit/network_state.dart';
import '../../core/network/widget/offline_bottom_sheet.dart';
import '../../core/widget/custom_bottom_nav_bar.dart';
import '../cart/cubit/cart_cubit.dart';
import '../category/cubit/category_cubit.dart';
import '../category/cubit/category_products_cubit.dart';
import '../favourites/cubit/favourites_cubit.dart';
import '../home/presentation/cubit/home_cubit.dart';
import '../home/presentation/home_screen.dart';
import '../location/cubit/location_cubit.dart';
import '../offers/cubit/offers_cubit.dart';
import 'cubit/main_layout_cubit.dart';
import 'cubit/main_layout_states.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  int _getUserIdHash() {
    final String? uId = FirebaseAuth.instance.currentUser?.uid;
    return uId != null ? uId.hashCode.abs() : 1;
  }

  @override
  Widget build(BuildContext context) {
    final int userId = _getUserIdHash();

    final List<Widget> screens = const [
      HomeScreen(),
      CategoryScreen(),
      CartScreen(),
      OffersScreen(),
      ProfileScreen(),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MainLayoutCubit()),
        BlocProvider.value(
          value: getIt<HomeCubit>()
            ..getTabletsProducts()
            ..getBeautyProducts()
            ..getSkinCareProducts()
            ..getWomenBagsProducts(),
        ),
        BlocProvider.value(value: getIt<CategoryCubit>()..getCategories()),
        BlocProvider.value(value: getIt<CategoryProductsCubit>()),
        BlocProvider.value(value: getIt<OffersCubit>()..loadOffers()),
        BlocProvider.value(value: getIt<FavouritesCubit>()..loadFavorites()),
        // BlocProvider.value(value: getIt<LocationCubit>()..getSavedAddresses()),
        BlocProvider.value(value: getIt<LocationCubit>()..getSavedAddresses()),
        BlocProvider.value(value: getIt<CartCubit>()..getCart(userId)),
        BlocProvider.value(value: getIt<ProfileCubit>()..getProfileData()),
      ],
      child: BlocListener<NetworkCubit, NetworkState>(
        listener: (context, networkState) {
          if (networkState is NetworkDisconnected) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => OfflineBottomSheet(
                onContinue: () {},
              ),
            );
          }
        },
        child: BlocBuilder<MainLayoutCubit, MainLayoutStates>(
          buildWhen: (previous, current) =>
          current is MainLayoutChangeBottomNavState ||
              current is MainLayoutNavigateToCategoryState,
          builder: (context, state) {
            final cubit = context.watch<MainLayoutCubit>();

            return Scaffold(
              body: IndexedStack(
                index: cubit.currentIndex,
                children: screens,
              ),
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeBottomNav(index);

                  if (index == 2) {
                    context.read<CartCubit>().getCart(userId);
                  } else if (index == 4) {
                    context.read<ProfileCubit>().getProfileData();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}