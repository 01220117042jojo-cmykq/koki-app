import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../widget/custom_elevates_button.dart';
import '../cubit/network_cubit.dart';

enum OfflineViewType { logo, dog }

class OfflineEmptyStateWidget extends StatefulWidget {
  final OfflineViewType viewType;
  final VoidCallback? onRetrySuccess;

  const OfflineEmptyStateWidget({
    super.key,
    this.viewType = OfflineViewType.logo,
    this.onRetrySuccess,
  });

  @override
  State<OfflineEmptyStateWidget> createState() =>
      _OfflineEmptyStateWidgetState();
}

class _OfflineEmptyStateWidgetState extends State<OfflineEmptyStateWidget> {
  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            if (canGoBack)
              Positioned(
                top: 12.h,
                left: 16.w,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    width: 38.w,
                    height: 38.h,
                    decoration:  BoxDecoration(
                      color: ColorManager.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: ColorManager.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      widget.viewType == OfflineViewType.logo
                          ? ImageAssets.smallLogoKoki
                          : ImageAssets.network,
                      width: 60.w,
                      height: 60.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      'No internet connection.\nPlease try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: 180.w,
                      child: CustomElevatedButton(
                        label: 'Retry',
                        backgroundColor: ColorManager.primaryDark,
                        isStadiumBorder: true,
                        onTap: () async {
                          final isConnected = await context
                              .read<NetworkCubit>()
                              .checkConnection();
                          if (isConnected &&
                              mounted &&
                              widget.onRetrySuccess != null) {
                            widget.onRetrySuccess!();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}