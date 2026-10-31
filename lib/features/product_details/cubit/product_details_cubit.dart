import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koki/features/product_details/cubit/product_details_states.dart';

import '../../../domain/entities/product_entity.dart';
import '../../../domain/use_cases/add_to_cart_use_case.dart';
import '../../../domain/use_cases/get_product_details_use_case.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsStates> {
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final AddToCartUseCase addToCartUseCase;

  ProductDetailsCubit(
      this.getProductDetailsUseCase,
      this.addToCartUseCase,
      ) : super(ProductDetailsInitialState());

  int selectedImageIndex = 0;
  int quantity = 1;

  void getProductDetails(int id) async {
    emit(ProductDetailsLoadingState());
    try {
      final product = await getProductDetailsUseCase.call(id);
      quantity = 1;
      emit(ProductDetailsSuccessState(product));
    } catch (e) {
      final message = e is Exception
          ? e.toString().replaceAll('Exception: ', '')
          : 'failed_to_load_product_details';
      emit(ProductDetailsErrorState(message));
    }
  }

  void changeSelectedImage(int index) {
    selectedImageIndex = index;
    emit(ProductImageChangedState(index));
  }

  void incrementQuantity() {
    quantity++;
    emit(ProductQuantityChangedState(quantity));
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
      emit(ProductQuantityChangedState(quantity));
    }
  }

  Future<void> addToCart({required ProductEntity product}) async {
    emit(AddToCartLoadingState());
    try {
      final user = FirebaseAuth.instance.currentUser;
      final int userId = user != null ? user.uid.hashCode.abs() : 1;

      await addToCartUseCase.call(
        userId: userId,
        product: product,
        quantity: quantity,
      );
      emit(AddToCartSuccessState("product_added_to_cart_success"));
    } catch (e) {
      final message = e is Exception
          ? e.toString().replaceAll('Exception: ', '')
          : 'failed_to_add_to_cart';
      emit(AddToCartErrorState(message));
    }
  }
}