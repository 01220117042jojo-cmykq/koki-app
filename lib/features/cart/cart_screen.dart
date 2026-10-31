import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/features/home/presentation/widgets/select_branch_first_widget.dart';
import 'package:koki/features/location/cubit/location_cubit.dart';
import 'package:koki/features/location/cubit/location_states.dart';
import 'package:koki/features/location/map_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/network/cubit/network_cubit.dart';
import '../../core/network/widget/top_network_banner.dart';
import '../../core/resources/assets_manager.dart';
import '../../core/resources/color_manager.dart';
import '../../core/widget/custom_loading_indicator.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../cart/pages/shipping_address_screen.dart';
import 'cubit/cart_cubit.dart';
import 'cubit/cart_states.dart';
import 'widgets/cart_checkout_bottom_bar.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/cart_payment_summary.dart';
import 'widgets/empty_cart_view.dart';
import 'widgets/remove_item_bottom_sheet.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const double _vatAmount = 20.00;
  static const double _deliveryFeeAmount = 26.00;

  static final CartEntity _dummyCart = CartEntity(
    id: 0,
    total: 350.0,
    discountedTotal: 350.0,
    totalProducts: 2,
    totalQuantity: 2,
    products: List.generate(
      2,
          (index) => const CartItemEntity(
        id: 0,
        title: 'Loading Item Name',
        price: 150.0,
        quantity: 1,
        thumbnail:
        'https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/1.webp',
      ),
    ),
  );

  int get _currentUserId {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? user.uid.hashCode.abs() : 0;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final int userId = _currentUserId;
      context.read<CartCubit>().getCart(userId);
    });
  }

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

      if (context.mounted) {
        context.read<CartCubit>().getCart(_currentUserId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int userId = _currentUserId;

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
          backgroundColor: const Color(0xFFF5F5F5),
          body: BlocConsumer<CartCubit, CartStates>(
            listener: (context, state) {
              if (state is CartErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: ColorManager.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is CartLoadingState) {
                return Skeletonizer(
                  enabled: true,
                  child: _buildCartBody(
                    context: context,
                    cart: _dummyCart,
                    userId: userId,
                    isActionLoading: false,
                  ),
                );
              }

              if (state is CartSuccessState || state is CartActionLoadingState) {
                final cart = state is CartSuccessState
                    ? state.cart
                    : (state as CartActionLoadingState).previousCart;

                if (cart.products.isEmpty) {
                  return const _EmptyCartLayout();
                }

                return Skeletonizer(
                  enabled: false,
                  child: _buildCartBody(
                    context: context,
                    cart: cart,
                    userId: userId,
                    isActionLoading: state is CartActionLoadingState,
                  ),
                );
              }

              return const _EmptyCartLayout();
            },
          ),
        );
      },
    );
  }

  Widget _buildCartBody({
    required BuildContext context,
    required CartEntity cart,
    required int userId,
    required bool isActionLoading,
  }) {
    return Stack(
      children: [
        Column(
          children: [
            const _CartHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CartItemList(cart: cart, userId: userId),
                    SizedBox(height: 16.h),
                    CartPaymentSummary(
                      totalPrice: cart.total,
                      vat: _vatAmount,
                      deliveryFee: _deliveryFeeAmount,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: CartCheckoutBottomBar(
            totalPrice: cart.total + _vatAmount + _deliveryFeeAmount,
            onCheckout: () => _navigateToCheckout(context, userId, cart),
          ),
        ),
        if (isActionLoading)
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.4),
              child: const Center(
                child: CustomLoadingIndicator(size: 70.0),
              ),
            ),
          ),
      ],
    );
  }

  void _navigateToCheckout(BuildContext context, int userId, CartEntity cart) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CartCubit>(),
          child: ShippingAddressScreen(
            userId: userId,
            cart: cart,
          ),
        ),
      ),
    );
  }
}

class _CartHeader extends StatelessWidget {
  const _CartHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 120.h,
          color: ColorManager.primary,
          child: SafeArea(
            bottom: false,
            child: Center(
              child: Text(
                "my_cart".tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
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
}

class _EmptyCartLayout extends StatelessWidget {
  const _EmptyCartLayout();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _CartHeader(),
        Expanded(child: EmptyCartView()),
      ],
    );
  }
}

class _CartItemList extends StatelessWidget {
  final CartEntity cart;
  final int userId;

  const _CartItemList({
    required this.cart,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cart.products.length,
      itemBuilder: (context, index) {
        final item = cart.products[index];
        return CartItemCard(
          title: item.title,
          imageUrl: item.thumbnail,
          price: item.price,
          quantity: item.quantity,
          onIncrement: () {
            context.read<CartCubit>().updateCartQuantity(
              userId: userId,
              productId: item.id,
              newQuantity: item.quantity + 1,
            );
          },
          onDecrement: () {
            if (item.quantity > 1) {
              context.read<CartCubit>().updateCartQuantity(
                userId: userId,
                productId: item.id,
                newQuantity: item.quantity - 1,
              );
            } else {
              _showRemoveConfirmation(context, userId, item.id);
            }
          },
          onRemove: () => _showRemoveConfirmation(context, userId, item.id),
        );
      },
    );
  }

  void _showRemoveConfirmation(
      BuildContext context, int userId, dynamic productId) {
    showRemoveItemBottomSheet(
      context: context,
      onConfirm: () async {
        final isConnected =
        await context.read<NetworkCubit>().checkConnection();
        if (!isConnected) {
          if (context.mounted) {
            TopNetworkBanner.show(context);
          }
          return;
        }

        if (context.mounted) {
          context.read<CartCubit>().updateCartQuantity(
            userId: userId,
            productId: productId,
            newQuantity: 0,
          );
        }
      },
    );
  }
}