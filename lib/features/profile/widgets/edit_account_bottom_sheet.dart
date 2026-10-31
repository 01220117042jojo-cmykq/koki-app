import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/widget/custom_loading_indicator.dart';
import '../../../../core/widget/custom_outlined_button.dart';
import '../../../../domain/entities/user_profile_entity.dart';
import '../../../core/widget/custom_elevates_button.dart';
import '../cubit/change_password_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/update_profile_cubit.dart';
import '../cubit/update_profile_states.dart';
import 'change_password_bottom_sheet.dart';

class EditAccountBottomSheet extends StatefulWidget {
  final UserProfileEntity userProfile;

  const EditAccountBottomSheet({
    super.key,
    required this.userProfile,
  });

  @override
  State<EditAccountBottomSheet> createState() =>
      _EditAccountBottomSheetState();
}

class _EditAccountBottomSheetState extends State<EditAccountBottomSheet> {
  late final TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userProfile.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateProfileCubit, UpdateProfileStates>(
      listener: (context, state) {
        if (state is UpdateProfileSuccessState) {
          getIt<ProfileCubit>().getProfileData();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('name_updated_success'.tr()),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is UpdateProfileErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is UpdateProfileLoadingState;

        return Padding(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Center(
                  child: Text(
                    "edit_account_info".tr(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.black,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "name".tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.black,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: nameController,
                  enabled: !isLoading,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.r),
                      borderSide: BorderSide(
                        color: ColorManager.primary,
                        width: 1.5.w,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: isLoading
                        ? null
                        : () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => BlocProvider(
                          create: (context) =>
                              getIt<ChangePasswordCubit>(),
                          child: const ChangePasswordBottomSheet(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          SvgAssets.lastTrySvgLock,
                          width: 18.w,
                          height: 18.h,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "change_password".tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Row(
                  children: [
                    Expanded(
                      child: isLoading
                          ? const Center(child: CustomLoadingIndicator())
                          : CustomElevatedButton(
                        label: "submit".tr(),
                        onTap: () {
                          if (nameController.text.trim().isNotEmpty) {
                            context
                                .read<UpdateProfileCubit>()
                                .updateUserName(
                              nameController.text.trim(),
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
                        text: "go_back".tr(),
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
        );
      },
    );
  }
}