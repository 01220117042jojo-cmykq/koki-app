import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/color_manager.dart';
import 'package:koki/core/widget/custom_loading_indicator.dart';
import 'package:koki/core/widget/custom_text_form_field.dart';
import 'package:koki/features/forget_password/cubit/forget_password_cubit.dart';

import '../../core/network/cubit/network_cubit.dart';
import '../../core/resources/assets_manager.dart';
import '../../core/routes_manager/routes.dart';
import '../../core/widget/custom_elevates_button.dart';
import 'cubit/forget_password_states.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(),
      child: Scaffold(
        backgroundColor: ColorManager.white,
        body: SafeArea(
          child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordStates>(
            listener: (context, state) {
              if (state is ForgetPasswordEmailSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          Icons.mark_email_read_outlined,
                          color: ColorManager.white,
                        ),
                        SizedBox(width: 10.w),
                         Expanded(
                          child: Text(
                              "reset_link_sent".tr(),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.fixed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
              if (state is ForgetPasswordEmailErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.fixed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                );
                Navigator.pushReplacementNamed(context, Routes.signInRoute);
              }
            },
            builder: (context, state) {
              var cubit = ForgetPasswordCubit.get(context);
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: cubit.emailFormKey,
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
                        "forgot_password".tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.sp,
                          color: ColorManager.black,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        "email".tr(),
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
                        onChanged: (value) => cubit.watchEmailField(),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return "please_enter_valid_email".tr();
                          }
                          return null;
                        },
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: state is ForgetPasswordEmailLoadingState
                            ? const Center(
                          child: CustomLoadingIndicator(),
                        )
                            : CustomElevatedButton(
                            label: "continue".tr(),
                          onTap: cubit.isButtonEnabled
                              ? () async {
                            final isConnected = await context
                                .read<NetworkCubit>()
                                .checkConnection();
                            if (!isConnected) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                   SnackBar(
                                    content: Text(
                                        "no_internet_connection".tr(),                                    ),
                                    backgroundColor: Colors.red,
                                    behavior:
                                    SnackBarBehavior.fixed,
                                  ),
                                );
                              }
                              return;
                            }

                            cubit.sendResetEmail();
                          }
                              : null,
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