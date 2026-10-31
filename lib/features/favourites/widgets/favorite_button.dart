import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/color_manager.dart';

import '../../../core/network/cubit/network_cubit.dart';
import '../../../core/network/widget/top_network_banner.dart';
import '../../../domain/entities/product_entity.dart';
import '../cubit/favourites_cubit.dart';
import '../cubit/favourites_states.dart';

class FavoriteButton extends StatelessWidget {
  final ProductEntity product;

  const FavoriteButton({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<FavouritesCubit, FavouritesStates>(
      builder: (context, state) {
        final cubit = context.read<FavouritesCubit>();
        final isFav = cubit.isFavorite(product.id.toString());

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

            cubit.toggleFavoriteProduct(product);
          },
          child: Icon(
            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: isFav ? ColorManager.primary : Colors.grey,
            size: 20.sp,
          ),
        );
      },
    );
  }
}