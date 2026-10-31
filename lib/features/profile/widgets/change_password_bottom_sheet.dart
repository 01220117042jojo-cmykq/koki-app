import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/widget/custom_loading_indicator.dart';
import '../../../core/widget/validators.dart';
import '../cubit/change_password_cubit.dart';
import '../cubit/change_password_states.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({super.key});

  @override
  State<ChangePasswordBottomSheet> createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState
    extends State<ChangePasswordBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
  TextEditingController();
  final TextEditingController _newPasswordController =
  TextEditingController();

  final FocusNode _currentFocus = FocusNode();
  final FocusNode _newFocus = FocusNode();

  final ValueNotifier<bool> _isCurrentObscure = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isNewObscure = ValueNotifier<bool>(true);
  final ValueNotifier<String?> _apiCurrentPasswordError =
  ValueNotifier<String?>(null);

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _currentFocus.dispose();
    _newFocus.dispose();
    _isCurrentObscure.dispose();
    _isNewObscure.dispose();
    _apiCurrentPasswordError.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: BlocConsumer<ChangePasswordCubit, ChangePasswordStates>(
          listener: (context, state) {
            if (state is ChangePasswordSuccessState) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('password_updated_success'.tr()),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is ChangePasswordErrorState) {
              if (state.message.contains("Current password is incorrect")) {
                _apiCurrentPasswordError.value =
                    'current_password_incorrect'.tr();
                _formKey.currentState?.validate();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            final isLoading = state is ChangePasswordLoadingState;

            return SingleChildScrollView(
              child: Form(
                key: _formKey,
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
                        'change_password'.tr(),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    _buildLabel('current_password'.tr()),
                    SizedBox(height: 8.h),
                    ValueListenableBuilder<bool>(
                      valueListenable: _isCurrentObscure,
                      builder: (context, isObscure, _) {
                        return ValueListenableBuilder<String?>(
                          valueListenable: _apiCurrentPasswordError,
                          builder: (context, apiError, _) {
                            return _buildPasswordField(
                              controller: _currentPasswordController,
                              focusNode: _currentFocus,
                              nextFocusNode: _newFocus,
                              isObscure: isObscure,
                              isLoading: isLoading,
                              onToggleVisibility: () {
                                _isCurrentObscure.value =
                                !_isCurrentObscure.value;
                              },
                              onChanged: (_) {
                                if (_apiCurrentPasswordError.value != null) {
                                  _apiCurrentPasswordError.value = null;
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'enter_current_password'.tr();
                                }
                                if (apiError != null) {
                                  return apiError;
                                }
                                return null;
                              },
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 18.h),

                    _buildLabel('new_password'.tr()),
                    SizedBox(height: 8.h),
                    ValueListenableBuilder<bool>(
                      valueListenable: _isNewObscure,
                      builder: (context, isObscure, _) {
                        return _buildPasswordField(
                          controller: _newPasswordController,
                          focusNode: _newFocus,
                          textInputAction: TextInputAction.done,
                          isObscure: isObscure,
                          isLoading: isLoading,
                          onSubmitted: (_) => _submit(context),
                          onToggleVisibility: () {
                            _isNewObscure.value = !_isNewObscure.value;
                          },
                          validator: (value) => AppValidators.validatePassword(
                            value,
                            lastPassword: _currentPasswordController.text,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16.h),

                    Text(
                      'password_requirements'.tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    _buildRequirementItem('req_at_least_8'.tr()),
                    _buildRequirementItem('req_uppercase'.tr()),
                    _buildRequirementItem('req_lowercase'.tr()),
                    _buildRequirementItem('req_number'.tr()),
                    _buildRequirementItem('req_special_char'.tr()),
                    _buildRequirementItem('req_no_spaces'.tr()),

                    SizedBox(height: 28.h),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.primary,
                                disabledBackgroundColor: Colors.grey.shade300,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.r),
                                ),
                                elevation: 0,
                              ),
                              onPressed:
                              isLoading ? null : () => _submit(context),
                              child: isLoading
                                  ? CustomLoadingIndicator(size: 24.sp)
                                  : Text(
                                'submit'.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: SizedBox(
                            height: 48.h,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: ColorManager.primary,
                                  width: 1.2.w,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.r),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                              child: Text(
                                'cancel'.tr(),
                                style: TextStyle(
                                  color: ColorManager.primary,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
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

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Text(
        '• $text',
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey.shade600,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isObscure,
    required bool isLoading,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
    FocusNode? nextFocusNode,
    TextInputAction textInputAction = TextInputAction.next,
    void Function(String)? onSubmitted,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isObscure,
      enabled: !isLoading,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted ??
              (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
      validator: validator,
      style: TextStyle(fontSize: 14.sp, color: ColorManager.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        suffixIcon: IconButton(
          icon: Icon(
            isObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.black87,
            size: 22.sp,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.r),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.r),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.r),
          borderSide: BorderSide(color: ColorManager.primary, width: 1.5.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.r),
          borderSide: BorderSide(color: Colors.red, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.r),
          borderSide: BorderSide(color: Colors.red, width: 1.5.w),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<ChangePasswordCubit>().changePassword(
        currentPassword: _currentPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );
    }
  }
}