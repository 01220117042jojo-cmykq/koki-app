import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/widget/custom_outlined_button.dart';
import '../../../../domain/entities/user_profile_entity.dart';
import '../../../core/network/cubit/network_cubit.dart';
import '../../../core/network/cubit/network_state.dart';
import '../../../core/network/widget/offline_empty_state.dart';
import '../cubit/delete_account_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_states.dart';
import '../cubit/update_profile_cubit.dart';
import '../widgets/delete_account_bottom_sheet.dart';
import '../widgets/edit_account_bottom_sheet.dart';

class AccountInfoScreen extends StatelessWidget {
  final UserProfileEntity initialProfile;

  const AccountInfoScreen({super.key, required this.initialProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: BlocBuilder<NetworkCubit, NetworkState>(
        builder: (context, networkState) {
          if (networkState is NetworkDisconnected) {
            return OfflineEmptyStateWidget(
              viewType: OfflineViewType.dog,
              onRetrySuccess: () {
                getIt<ProfileCubit>().getProfileData();
              },
            );
          }

          return BlocBuilder<ProfileCubit, ProfileStates>(
            bloc: getIt<ProfileCubit>(),
            builder: (context, state) {
              final userProfile = state is ProfileAuthenticatedState
                  ? state.userProfile
                  : initialProfile;

              return Column(
                children: [
                  _buildHeader(context, userProfile),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('name_label'.tr()),
                          SizedBox(height: 8.h),
                          _buildReadOnlyField(userProfile.name),

                          SizedBox(height: 18.h),

                          _buildLabel('email_label'.tr()),
                          SizedBox(height: 8.h),
                          _buildReadOnlyField(userProfile.email),

                          SizedBox(height: 16.h),

                          Center(
                            child: Text(
                              "email_cannot_be_edited".tr(),
                              style: TextStyle(
                                color: const Color(0xFFB71C1C),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const Spacer(),

                          SizedBox(
                            width: double.infinity,
                            child: CustomOutlinedButton(
                              text: "delete_account_question".tr(),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (_) => BlocProvider(
                                    create: (context) =>
                                        getIt<DeleteAccountCubit>(),
                                    child: const DeleteAccountBottomSheet(),
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserProfileEntity userProfile) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 130.h,
          color: ColorManager.primary,
          padding: EdgeInsets.only(top: 40.h, left: 16.w, right: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  width: 38.w,
                  height: 38.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: ColorManager.primary,
                    size: 20.sp,
                  ),
                ),
              ),

              Text(
                "account_info".tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => BlocProvider(
                      create: (context) => getIt<UpdateProfileCubit>(),
                      child: EditAccountBottomSheet(userProfile: userProfile),
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit_note_rounded,
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
            ],
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

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: ColorManager.black,
      ),
    );
  }

  Widget _buildReadOnlyField(String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.grey.shade300, width: 1.w),
      ),
      child: Text(
        value,
        style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
      ),
    );
  }
}
