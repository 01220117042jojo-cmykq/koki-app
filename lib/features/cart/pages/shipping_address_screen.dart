import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/di/service_locator.dart';
import 'package:koki/core/resources/color_manager.dart';
import 'package:koki/core/widget/custom_loading_indicator.dart';
import 'package:koki/domain/entities/cart_entity.dart';

import '../../../../core/widget/custom_text_form_field.dart';

import '../../../core/widget/validators.dart';
import '../../location/cubit/location_cubit.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_states.dart';
import '../widgets/delivery_address_card.dart';
import '../widgets/guest_order_success_dialog.dart';
import '../widgets/order_success_dialog.dart';
import '../widgets/payment_method_card.dart';
import '../widgets/shipping_address_header.dart';

class ShippingAddressScreen extends StatefulWidget {
  final int userId;
  final CartEntity cart;

  const ShippingAddressScreen({
    super.key,
    required this.userId,
    required this.cart,
  });

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final ValueNotifier<String> _selectedPaymentMethod =
  ValueNotifier<String>('Cash On Delivery');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _selectedPaymentMethod.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationCubit = getIt<LocationCubit>();
    final bool isGuest = FirebaseAuth.instance.currentUser == null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
        body: BlocListener<CartCubit, CartStates>(
          listener: (context, state) async {
            if (state is CartErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: ColorManager.red,
                ),
              );
            } else if (state is CheckoutSuccessState) {
              final cartCubit = context.read<CartCubit>();

              await cartCubit.clearLocalAndStateCart();

              cartCubit.getCart(widget.userId);

              if (context.mounted) {
                if (isGuest) {
                  GuestOrderSuccessDialog.show(
                    context,
                    orderId: state.orderId,
                  );
                } else {
                  OrderSuccessDialog.show(
                    context,
                    orderId: state.orderId,
                  );
                }
              }
            }
          },
          child: Column(
            children: [
              const ShippingAddressHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DeliveryAddressCard(locationCubit: locationCubit),

                        if (isGuest) ...[
                          SizedBox(height: 20.h),
                          Text(
                            'delivery_details'.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          CustomTextFormField(
                            controller: _phoneController,
                            hintText: 'enter_phone_number'.tr(),
                            keyboardType: TextInputType.phone,
                            validator: AppValidators.validatePhoneNumber,
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  controller: _buildingController,
                                  hintText: 'building_no'.tr(),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'required_field'.tr();
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: CustomTextFormField(
                                  controller: _floorController,
                                  hintText: 'floor_no'.tr(),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'required_field'.tr();
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],

                        SizedBox(height: 24.h),
                        Text(
                          'payment_method'.tr(),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'select_payment_method_subtitle'.tr(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ValueListenableBuilder<String>(
                          valueListenable: _selectedPaymentMethod,
                          builder: (context, selectedMethod, child) {
                            return Row(
                              children: [
                                Expanded(
                                  child: PaymentMethodCard(
                                    title: 'cash_on_delivery'.tr(),
                                    iconWidget: const Icon(
                                      Icons.payments_outlined,
                                      color: Colors.green,
                                      size: 40,
                                    ),
                                    isSelected: selectedMethod == 'Cash On Delivery',
                                    onTap: () {
                                      _selectedPaymentMethod.value =
                                      'Cash On Delivery';
                                    },
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: PaymentMethodCard(
                                    title: 'payment_card'.tr(),
                                    iconWidget: const Icon(
                                      Icons.credit_card_rounded,
                                      color: Colors.indigo,
                                      size: 40,
                                    ),
                                    isSelected: selectedMethod == 'Payment Card',
                                    onTap: () {
                                      _selectedPaymentMethod.value = 'Payment Card';
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'card_payment_coming_soon'.tr()),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 30.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 16.w,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8EEF5),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: const Color(0xFFC3D4E8)),
                          ),
                          child: Text(
                            'delivery_timing_notice'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: ColorManager.primaryDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        BlocConsumer<CartCubit, CartStates>(
                          listenWhen: (previous, current) =>
                          current is CheckoutSuccessState ||
                              current is CheckoutErrorState,
                          listener: (context, state) {
                            if (state is CheckoutErrorState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            final isLoading = state is CartActionLoadingState ||
                                state is CheckoutLoadingState;

                            return SizedBox(
                              width: double.infinity,
                              height: 52.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorManager.primaryDark,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: isLoading
                                    ? null
                                    : () {
                                  String addressText;

                                  if (isGuest) {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    addressText = "Building: ${_buildingController.text.trim()}, Floor: ${_floorController.text.trim()}, Phone: ${_phoneController.text.trim()}";
                                  } else {
                                    final selectedAddr = locationCubit.selectedAddress;
                                    addressText = selectedAddr?.addressDetails ?? 'Cairo, Egypt';
                                  }

                                  context.read<CartCubit>().checkout(
                                    userId: widget.userId,
                                    paymentMethod:
                                    _selectedPaymentMethod.value,
                                    address: addressText,
                                  );
                                },
                                child: isLoading
                                    ? CustomLoadingIndicator(size: 32.sp)
                                    : Text(
                                  'place_order'.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}