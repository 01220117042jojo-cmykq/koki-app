import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/network/cubit/network_cubit.dart';
import '../../../core/network/widget/top_network_banner.dart';
import '../../../core/resources/color_manager.dart';

class CartItemCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  Future<void> _handleAction(
      BuildContext context,
      VoidCallback action,
      ) async {
    final isConnected = await context.read<NetworkCubit>().checkConnection();
    if (!isConnected) {
      if (context.mounted) {
        TopNetworkBanner.show(context);
      }
      return;
    }
    action();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              imageUrl,
              width: 80.w,
              height: 80.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.darkSlate,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "${price.toStringAsFixed(2)} EGP",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: ColorManager.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: ColorManager.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    _handleAction(
                      context,
                      quantity == 1 ? onRemove : onDecrement,
                    );
                  },
                  icon: Icon(
                    quantity == 1 ? Icons.delete_outline : Icons.remove,
                    color: ColorManager.primary,
                    size: 18.sp,
                  ),
                ),
                Text(
                  "$quantity",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.darkSlate,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _handleAction(context, onIncrement);
                  },
                  icon: Icon(
                    Icons.add,
                    color: ColorManager.primary,
                    size: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}