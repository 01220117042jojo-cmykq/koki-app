import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/color_manager.dart';
/// Ai
class OrderCardItem extends StatelessWidget {
  final Map<String, dynamic> order;
  final Function(List<dynamic> items) onReOrder;

  const OrderCardItem({
    super.key,
    required this.order,
    required this.onReOrder,
  });

  @override
  Widget build(BuildContext context) {
    final Timestamp? createdAtTimestamp = order['createdAt'] as Timestamp?;
    final DateTime orderTime = createdAtTimestamp?.toDate() ?? DateTime.now();
    final double minutesPassed = DateTime.now().difference(orderTime).inSeconds / 60;

    String rawStatus = order['status'] ?? 'Pending';
    if (rawStatus != 'Cancelled') {
      if (minutesPassed < 0.5) {
        rawStatus = 'Pending';
      } else if (minutesPassed < 2.0) {
        rawStatus = 'Preparing';
      } else {
        rawStatus = 'Delivered';
      }
    }

    String statusLocalizedKey;
    Color statusBgColor;
    Color statusTextColor;

    if (rawStatus == 'Delivered') {
      statusLocalizedKey = 'status_delivered';
      statusBgColor = const Color(0xFFE8F5E9);
      statusTextColor = const Color(0xFF2E7D32);
    } else if (rawStatus == 'Cancelled') {
      statusLocalizedKey = 'status_cancelled';
      statusBgColor = const Color(0xFFFFEBEE);
      statusTextColor = const Color(0xFFC62828);
    } else if (rawStatus == 'Preparing') {
      statusLocalizedKey = 'status_preparing';
      statusBgColor = const Color(0xFFFFF3E0);
      statusTextColor = const Color(0xFFEF6C00);
    } else {
      statusLocalizedKey = 'status_pending';
      statusBgColor = const Color(0xFFFFF8E1);
      statusTextColor = const Color(0xFFF57F17);
    }

    final double subTotal = (order['totalPrice'] ?? 0.0).toDouble();
    final double vat = (order['vat'] ?? 20.0).toDouble();
    final double deliveryFee = (order['deliveryFee'] ?? 26.0).toDouble();

    final double finalTotalPrice = order.containsKey('vat')
        ? subTotal
        : (subTotal + vat + deliveryFee);

    final String address = order['address'] ?? 'no_address_provided'.tr();
    final String formattedDate = DateFormat('dd MMM yyyy, hh:mm a', context.locale.languageCode).format(orderTime);
    final List<dynamic> items = order['items'] ?? [];

    final String rawOrderId = (order['orderId'] ?? order['id'] ?? '').toString();
    final String displayOrderId = rawOrderId.length >= 6
        ? rawOrderId.substring(0, 6)
        : rawOrderId;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'order_id'.tr(namedArgs: {'displayOrderId': displayOrderId}),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  statusLocalizedKey.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: statusTextColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 60.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final String thumbnail = item['thumbnail'] ?? '';

                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 55.w,
                        height: 55.h,
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: thumbnail.startsWith('http')
                              ? Image.network(
                            thumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                            const Icon(Icons.fastfood, size: 20),
                          )
                              : Image.asset(
                            thumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                            const Icon(Icons.fastfood, size: 20),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -3,
                        right: -3,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: Colors.red, width: 1.5),
                          ),
                          child: Text(
                            'x${item['quantity'] ?? 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16.sp, color: Colors.grey.shade600),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ordered_on'.tr(),
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
              ),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: const Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${finalTotalPrice.toStringAsFixed(0)} ${'egp'.tr()}',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primary,
                ),
              ),
            ],
          ),
          if (rawStatus == 'Delivered') ...[
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => onReOrder(items),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
                child: Text(
                  'order_again'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}