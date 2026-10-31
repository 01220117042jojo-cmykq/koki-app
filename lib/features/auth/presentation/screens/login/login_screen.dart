import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/assets_manager.dart';
import 'package:koki/core/resources/color_manager.dart';
import '../../../../../core/routes_manager/routes.dart';
import 'package:koki/core/widget/custom_elevates_button.dart';
import 'package:koki/core/widget/custom_loading_indicator.dart';
import 'package:koki/core/widget/custom_outlined_button.dart';
import 'package:koki/core/widget/custom_text_form_field.dart';
import 'package:koki/features/auth/presentation/screens/login/cubit/login_view_model.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/network/cubit/network_cubit.dart';
import '../../../../../core/network/widget/top_network_banner.dart';
import 'cubit/login_states.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: Scaffold(
        backgroundColor: ColorManager.white,
        body: SafeArea(
          child: BlocConsumer<LoginCubit, LoginStates>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'welcome_back'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.w500),
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
              if (state is LoginErrorState) {
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
              var cubit = LoginCubit.get(context);

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
                            alignment: Alignment.topCenter,
                            child: Image.asset(
                              ImageAssets.smallLogoKoki,
                              height: 55.h,
                              width: 60.w,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        'continue_with_email'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.sp,
                          color: ColorManager.black,
                        ),
                      ),
                      SizedBox(height: 25.h),
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
                        suffixIcon: cubit.emailController.text.isNotEmpty
                            ? IconButton(
                          onPressed: () {
                            cubit.emailController.clear();
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.black54,
                          ),
                        )
                            : null,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return 'email_invalid_error'.tr();
                          }
                          return null;
                        },
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
                        hintText: '************',
                        obscureText: cubit.isPasswordHidden,
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
                        validator: (value) {
                          if (value == null || value.trim().length < 8) {
                            return 'password_short_error'.tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: Checkbox(
                              value: cubit.isRemeberMeChecked,
                              activeColor: ColorManager.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              side: BorderSide(
                                color: ColorManager.coolGray,
                                width: 1.5.w,
                              ),
                              onChanged: (value) {
                                cubit.changeRememberMe(value);
                              },
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'remember_me'.tr(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: ColorManager.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: state is LoginLoadingState
                            ? const Center(
                          child: CustomLoadingIndicator(),
                        )
                            : CustomElevatedButton(
                          label: 'login'.tr(),
                          onTap: cubit.isButtonEnabled
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

                            cubit.login();
                          }
                              : null,
                        ),
                      ),
                      SizedBox(height: 35.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomOutlinedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  Routes.forgetPassword,
                                );
                              },
                              text: 'forget_password_question'.tr(),
                            ),
                          ),
                          SizedBox(width: 30.w),
                          Expanded(
                            child: CustomOutlinedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  Routes.signUpRoute,
                                );
                              },
                              text: 'create_an_account'.tr(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 35.h),
                      SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: CustomElevatedButton(
                          label: 'back_home'.tr(),
                          backgroundColor: ColorManager.primary,
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              Routes.mainRoute,
                            );
                          },
                          prefixIcon: Icon(
                            Icons.home_filled,
                            color: ColorManager.white,
                            size: 25,
                          ),
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: ColorManager.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h),
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