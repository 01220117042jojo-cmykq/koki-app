import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/routes_manager/routes.dart';
import '../../../../core/widget/custom_loading_indicator.dart';
import '../../../../core/widget/custom_outlined_button.dart';
import '../../../../core/widget/custom_text_form_field.dart';
import '../../../core/widget/custom_elevates_button.dart';
import '../cubit/delete_account_cubit.dart';
import '../cubit/delete_account_states.dart';

class DeleteAccountBottomSheet extends StatefulWidget {
  const DeleteAccountBottomSheet({super.key});

  @override
  State<DeleteAccountBottomSheet> createState() =>
      _DeleteAccountBottomSheetState();
}

class _DeleteAccountBottomSheetState extends State<DeleteAccountBottomSheet> {
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteAccountCubit, DeleteAccountStates>(
      listener: (context, state) {
        if (state is DeleteAccountSuccessState) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('account_deleted_success'.tr()),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.signInRoute,
            (route) => false,
          );
        } else if (state is DeleteAccountErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message.tr()),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is DeleteAccountLoadingState;
        final cubit = context.read<DeleteAccountCubit>();

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F5F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.r),
                  topRight: Radius.circular(32.r),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Image.asset(
                      ImageAssets.trash,
                      height: 90.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "delete_account".tr(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "delete_account_confirm_msg".tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorManager.coolGray,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomTextFormField(
                      controller: _passwordController,
                      hintText: "enter_your_password".tr(),
                      obscureText: !cubit.isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "password_is_required".tr();
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          cubit.isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: ColorManager.coolGray,
                        ),
                        onPressed: () => cubit.togglePasswordVisibility(),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: isLoading
                              ? const Center(child: CustomLoadingIndicator())
                              : CustomElevatedButton(
                                  label: "delete".tr(),
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      cubit.deleteAccount(
                                        password: _passwordController.text,
                                      );
                                    }
                                  },
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CustomOutlinedButton(
                            text: "cancel".tr(),
                            onPressed: isLoading
                                ? () {}
                                : () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
