  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koki/domain/use_cases/get_all_products_use_case.dart';
import 'package:koki/features/products_screen/presentation/cubit/products_state.dart';

class ProductsCubit extends Cubit<ProductsState>{
  final GetAllProductsUseCase getAllProductsUseCase;
  ProductsCubit(this.getAllProductsUseCase) : super(ProductsInitial());

  Future<void> getProducts() async{
    emit(ProductsLoading());

    try{
      final products = await getAllProductsUseCase();
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}