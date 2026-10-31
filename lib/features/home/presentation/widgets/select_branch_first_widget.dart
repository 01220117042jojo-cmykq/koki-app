// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:koki/core/resources/assets_manager.dart';
// import 'package:koki/core/resources/color_manager.dart';
// import 'package:koki/core/widget/custom_elevates_button.dart';
//
// class SelectBranchFirstWidget extends StatelessWidget {
//   final VoidCallback onSelectBranchPressed;
//
//   const SelectBranchFirstWidget({
//     super.key,
//     required this.onSelectBranchPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24.w),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Stack(
//               alignment: Alignment.topRight,
//               children: [
//                 Container(
//                   width: 140.w,
//                   height: 140.h,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.08),
//                         blurRadius: 20,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(20.w),
//                     child: Image.asset(
//                       ImageAssets.smallLogoKoki,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//                 CircleAvatar(
//                   radius: 18.r,
//                   backgroundColor: ColorManager.navy,
//                   child: Icon(
//                     Icons.location_on,
//                     color: Colors.white,
//                     size: 18.sp,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 36.h),
//             Text(
//               "select_branch_desc".tr(),
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 15.sp,
//                 height: 1.5,
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             SizedBox(height: 32.h),
//             SizedBox(
//               width: double.infinity,
//               height: 52.h,
//               child: CustomElevatedButton(
//                 label: "select_branch_first".tr(),
//                 onTap: onSelectBranchPressed,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/color_manager.dart';
import 'package:koki/core/widget/custom_elevates_button.dart';
import 'package:koki/core/widget/custom_loading_indicator.dart'; // 👈 ضيفنا الـ import بتاع الـ Loading الخاص بيك

class SelectBranchFirstWidget extends StatelessWidget {
  final VoidCallback onSelectBranchPressed;

  const SelectBranchFirstWidget({
    super.key,
    required this.onSelectBranchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 👈 استبدلنا الـ Stack القديم بالكامل بالأنيميشن الجميل بتاعك
            CustomLoadingIndicator(
              size: 130.r,
            ),

            SizedBox(height: 36.h),
            Text(
              "select_branch_desc".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                height: 1.5,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: CustomElevatedButton(
                label: "select_branch_first".tr(),
                onTap: onSelectBranchPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}