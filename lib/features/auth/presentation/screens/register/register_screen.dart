import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/color_manager.dart';
import 'package:koki/core/widget/custom_text_form_field.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/network/cubit/network_cubit.dart';
import '../../../../../core/network/widget/top_network_banner.dart';
import '../../../../../core/resources/assets_manager.dart';
import '../../../../../core/routes_manager/routes.dart';
import '../../../../../core/widget/custom_elevates_button.dart';
import '../../../../../core/widget/custom_loading_indicator.dart';
import '../../../../../core/widget/validators.dart';
import 'cubit/register_states.dart';
import 'cubit/register_view_model.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RegisterCubit>(),
      child: Scaffold(
        backgroundColor: ColorManager.white,
        body: SafeArea(
          child: BlocConsumer<RegisterCubit, RegisterStates>(
            listener: (context, state) {
              if (state is RegisterLoadingState) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const PopScope(
                    canPop: false,
                    child: Center(
                      child: CustomLoadingIndicator(size: 90.0),
                    ),
                  ),
                );
              }

              if (state is RegisterSuccessState || state is RegisterErrorState) {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              }

              if (state is RegisterSuccessState) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: ColorManager.white,
                        ),
                        SizedBox(width: 10.w),
                         Text(
                          'account_created_success'.tr(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.fixed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.mainRoute,
                      (route) => false,
                );
              }

              if (state is RegisterErrorState) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.fixed,
                  ),
                );
              }
            },
            builder: (context, state) {
              var cubit = RegisterCubit.get(context);
              final isLoading = state is RegisterLoadingState;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  Routes.signInRoute,
                                );
                              },
                              borderRadius: BorderRadius.circular(100.r),
                              child: Container(
                                width: 40.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 1.w,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                          Image.asset(
                            ImageAssets.smallLogoKoki,
                            height: 55.h,
                            width: 60.w,
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        'create_your_account'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.sp,
                          color: ColorManager.black,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        'name'.tr(),
                        style: TextStyle(
                          fontSize: 19.sp,
                          color: ColorManager.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextFormField(
                        controller: cubit.nameController,
                        hintText: 'enter_full_name'.tr(),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => cubit.watchFields(),
                        suffixIcon: cubit.nameController.text.isNotEmpty
                            ? IconButton(
                          onPressed: () {
                            cubit.nameController.clear();
                            cubit.watchFields();
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.black54,
                          ),
                        )
                            : null,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'please_enter_name'.tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'email'.tr(),
                        style: TextStyle(
                          fontSize: 19.sp,
                          color: ColorManager.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextFormField(
                        controller: cubit.emailController,
                        hintText: 'email@example.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => cubit.watchFields(),
                        suffixIcon: cubit.emailController.text.isNotEmpty
                            ? IconButton(
                          onPressed: () {
                            cubit.emailController.clear();
                            cubit.watchFields();
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.black54,
                          ),
                        )
                            : null,
                        validator: AppValidators.validateEmail,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'password'.tr(),
                        style: TextStyle(
                          fontSize: 19.sp,
                          color: ColorManager.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextFormField(
                        controller: cubit.passwordController,
                        hintText: '********',
                        obscureText: cubit.isPasswordHidden,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) => cubit.watchFields(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            cubit.changePassword();
                          },
                          icon: Icon(
                            cubit.isPasswordHidden
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                        validator: AppValidators.validatePassword,
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        'password_requirements'.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorManager.darkGrey.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'req_at_least_8_chars'.tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: ColorManager.darkGrey,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'req_one_uppercase'.tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: ColorManager.darkGrey,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'req_one_lowercase'.tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: ColorManager.darkGrey,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'req_one_number'.tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: ColorManager.darkGrey,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'req_one_special_char'.tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: ColorManager.darkGrey,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'req_no_spaces'.tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: ColorManager.darkGrey,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'req_not_same_as_last'.tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: ColorManager.darkGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: Checkbox(
                              value: cubit.isOffersChecked,
                              activeColor: ColorManager.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              side: BorderSide(
                                color: ColorManager.coolGray,
                                width: 1.5.w,
                              ),
                              onChanged: (value) {
                                cubit.changeOffersCheckbox(value);
                              },
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'receive_offers_discounts'.tr(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: ColorManager.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: CustomElevatedButton(
                          label: 'create_account'.tr(),
                          onTap: (cubit.isButtonEnabled && !isLoading)
                              ? () async {
                            final isConnected = await context
                                .read<NetworkCubit>()
                                .checkConnection();
                            if (!isConnected) {
                              if (context.mounted) {
                                TopNetworkBanner.show(context);
                              }
                              return;
                            }

                            cubit.register();
                          }
                              : null,
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
