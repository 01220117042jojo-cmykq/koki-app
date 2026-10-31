import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koki/core/resources/color_manager.dart';
import '../../../core/widget/custom_elevates_button.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_states.dart';

class AddressSubmitButton extends StatelessWidget {
  final bool isEdit;
  final ValueNotifier<bool> isFormValidNotifier;
  final VoidCallback onSubmit;

  const AddressSubmitButton({
    super.key,
    required this.isEdit,
    required this.isFormValidNotifier,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationCubit, LocationStates>(
      listener: (context, state) {
        if (state is AddressActionSuccessState) {
          Navigator.pop(context, true);
        }
      },
      builder: (context, state) {
        final isLoading = state is LocationLoadingState;

        return ValueListenableBuilder<bool>(
          valueListenable: isFormValidNotifier,
          builder: (context, isValid, _) {
            return SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                label: isLoading
                    ? "saving".tr()
                    : (isEdit ? "edit_address".tr() : "add_new_address".tr()),
                backgroundColor: isValid
                    ? ColorManager.primary
                    : Colors.grey.shade300,
                onTap: (isValid && !isLoading) ? onSubmit : null,
              ),
            );
          },
        );
      },
    );
  }
}