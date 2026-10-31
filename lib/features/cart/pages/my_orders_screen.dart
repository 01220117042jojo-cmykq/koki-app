import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/network/cubit/network_cubit.dart';
import '../../../core/network/cubit/network_state.dart';
import '../../../core/network/widget/offline_empty_state.dart';
import '../../../core/routes_manager/routes.dart';
import '../../../core/widget/custom_loading_indicator.dart';
import '../../../domain/entities/product_entity.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/empty_orders_view.dart';
import '../widgets/order_card_item.dart';
import '../widgets/orders_header_widget.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  bool _isReordering = false;

  int _getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid.hashCode.abs();
    }
    return 1;
  }

  static final Map<String, dynamic> _dummyOrderData = {
    'orderId': 'ORD-12345678',
    'createdAt': Timestamp.now(),
    'status': 'Processing',
    'totalAmount': 450.0,
    'paymentMethod': 'Cash On Delivery',
    'address': 'Cairo, Egypt - Placeholder Address For Loading',
    'items': [
      {
        'id': 1,
        'title': 'Placeholder Loading Order Item Title 1',
        'price': 150.0,
        'quantity': 2,
        'thumbnail': '',
      },
      {
        'id': 2,
        'title': 'Placeholder Loading Order Item Title 2',
        'price': 150.0,
        'quantity': 1,
        'thumbnail': '',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final int userId = _getCurrentUserId();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          BlocBuilder<NetworkCubit, NetworkState>(
            builder: (context, networkState) {
              if (networkState is NetworkDisconnected) {
                return OfflineEmptyStateWidget(
                  viewType: OfflineViewType.dog,
                  onRetrySuccess: () {
                    //automatically
                  },
                );
              }

              return Column(
                children: [
                  const OrdersHeaderWidget(),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('orders')
                          .where('userId', isEqualTo: userId)
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Skeletonizer(
                            enabled: true,
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 8.h),
                              itemCount: 3,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 12.h),
                              itemBuilder: (context, index) {
                                return OrderCardItem(
                                  order: _dummyOrderData,
                                  onReOrder: (_) {},
                                );
                              },
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "something_went_wrong".tr(),
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.red),
                            ),
                          );
                        }

                        final docs = snapshot.data?.docs ?? [];

                        if (docs.isEmpty) {
                          return const EmptyOrdersView();
                        }

                        return Skeletonizer(
                          enabled: false,
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            itemCount: docs.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final data =
                              docs[index].data() as Map<String, dynamic>;
                              return OrderCardItem(
                                order: data,
                                onReOrder: (items) =>
                                    _reOrderItems(context, items),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          if (_isReordering)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CustomLoadingIndicator(size: 70.0),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _reOrderItems(BuildContext context, List<dynamic> items) async {
    setState(() {
      _isReordering = true;
    });

    final cartCubit = context.read<CartCubit>();
    final userId = _getCurrentUserId();

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      for (var item in items) {
        if (item is! Map<String, dynamic>) continue;

        final product = ProductEntity(
          id: item['id'] ?? 0,
          title: item['title'] ?? '',
          description: item['description'] ?? '',
          price: (item['price'] ?? 0.0).toDouble(),
          discountPercentage: (item['discountPercentage'] ?? 0.0).toDouble(),
          thumbnail: item['thumbnail'] ?? '',
          images: item['images'] != null
              ? List<String>.from(item['images'])
              : [item['thumbnail'] ?? ''],
        );

        final quantity = (item['quantity'] ?? 1) as int;

        await cartCubit.addToCart(
          userId: userId,
          product: product,
          quantity: quantity,
        );
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text('items_added_to_cart_success'.tr()),
          backgroundColor: Colors.green,
        ),
      );

      navigator.pushNamedAndRemoveUntil(
        Routes.mainRoute,
            (route) => false,
        arguments: 2,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isReordering = false;
        });
      }
    }
  }
}