import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_text_form_field.dart';
import '../../../core/widget/validators.dart';

class AddressFormFields extends StatelessWidget {
  final TextEditingController labelController;
  final TextEditingController phoneController;
  final TextEditingController secondaryPhoneController;
  final TextEditingController buildingController;
  final TextEditingController floorController;

  const AddressFormFields({
    super.key,
    required this.labelController,
    required this.phoneController,
    required this.secondaryPhoneController,
    required this.buildingController,
    required this.floorController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          controller: labelController,
          hintText: "address_label_hint".tr(),
          validator: (val) =>
          val == null || val.trim().isEmpty ? "label_required".tr() : null,
        ),
        SizedBox(height: 16.h),
        CustomTextFormField(
          controller: phoneController,
          hintText: "phone".tr(),
          keyboardType: TextInputType.phone,
          validator: AppValidators.validatePhoneNumber,
        ),
        SizedBox(height: 16.h),
        CustomTextFormField(
          controller: secondaryPhoneController,
          hintText: "another_phone_optional".tr(),
          keyboardType: TextInputType.phone,
          validator: AppValidators.validateOptionalPhoneNumber,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: buildingController,
                hintText: "building_no".tr(),
                keyboardType: TextInputType.number,
                validator: (val) =>
                val == null || val.trim().isEmpty ? "required".tr() : null,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomTextFormField(
                controller: floorController,
                hintText: "floor_no".tr(),
                keyboardType: TextInputType.number,
                validator: (val) =>
                val == null || val.trim().isEmpty ? "required".tr() : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}