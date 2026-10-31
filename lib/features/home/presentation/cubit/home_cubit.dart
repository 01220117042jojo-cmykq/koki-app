import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/product_entity.dart';
import '../../../../domain/use_cases/get_all_products_use_case.dart';
import '../../../../domain/use_cases/get_products_by_category_use_case.dart';
import '../../../../domain/use_cases/search_products_use_case.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final GetAllProductsUseCase getAllProductsUseCase;
  final SearchProductsUseCase searchProductsUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  HomeCubit(
      this.getAllProductsUseCase,
      this.searchProductsUseCase,
      this.getProductsByCategoryUseCase,
      ) : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of<HomeCubit>(context);

  List<ProductEntity> cachedTablets = [];
  List<ProductEntity> cachedBeauty = [];
  List<ProductEntity> cachedSkinCare = [];
  List<ProductEntity> cachedWomensBags = [];

  List<ProductEntity> searchProductsList = [];

  String _cleanError(dynamic e, String defaultMessage) {
    if (e is Exception) {
      return e.toString().replaceAll('Exception: ', '');
    }
    return defaultMessage;
  }

  Future<void> getHomeProducts() async {
    emit(HomeGetProductsLoadingState());
    try {
      final products = await getAllProductsUseCase.call();
      emit(HomeGetProductsSuccessState(products));
    } catch (e) {
      emit(HomeGetProductsErrorState(_cleanError(e, 'Failed to load products')));
    }
  }

  Future<void> searchHomeProducts(String query) async {
    if (query.trim().isEmpty) {
      searchProductsList.clear();
      emit(HomeInitialState());
      return;
    }
    emit(HomeSearchProductsLoadingState());
    try {
      final results = await searchProductsUseCase.call(query);
      searchProductsList = results;
      emit(HomeSearchProductsSuccessState(results));
    } catch (e) {
      searchProductsList.clear();
      emit(HomeSearchProductsErrorState(_cleanError(e, 'search_failed'.tr())));
    }
  }

  void resetSearch() {
    searchProductsList.clear();
    emit(HomeInitialState());
  }

  Future<void> getTabletsProducts() async {
    if (cachedTablets.isNotEmpty) {
      emit(HomeGetTabletsSuccessState(cachedTablets));
      return;
    }
    emit(HomeGetTabletsLoadingState());
    try {
      final tablets = await getProductsByCategoryUseCase.call('tablets');
      cachedTablets = tablets;
      emit(HomeGetTabletsSuccessState(tablets));
    } catch (e) {
      emit(HomeGetTabletsErrorState(_cleanError(e, 'failed_to_load_tablets'.tr())));
    }
  }

  Future<void> getBeautyProducts() async {
    if (cachedBeauty.isNotEmpty) {
      emit(HomeGetBeautySuccessState(cachedBeauty));
      return;
    }
    emit(HomeGetBeautyLoadingState());
    try {
      final beauty = await getProductsByCategoryUseCase.call('beauty');
      cachedBeauty = beauty;
      emit(HomeGetBeautySuccessState(beauty));
    } catch (e) {
      emit(HomeGetBeautyErrorState(_cleanError(e, 'failed_to_load_beauty_products'.tr())));    }
  }

  Future<void> getSkinCareProducts() async {
    if (cachedSkinCare.isNotEmpty) {
      emit(HomeGetSkinCareSuccessState(cachedSkinCare));
      return;
    }
    emit(HomeGetSkinCareLoadingState());
    try {
      final skinCare = await getProductsByCategoryUseCase.call('skin-care');
      cachedSkinCare = skinCare;
      emit(HomeGetSkinCareSuccessState(skinCare));
    } catch (e) {
      emit(HomeGetSkinCareErrorState(_cleanError(e, 'failed_to_load_skin_care_products'.tr())));
    }
  }

  Future<void> getWomenBagsProducts() async {
    if (cachedWomensBags.isNotEmpty) {
      emit(HomeGetWomensBagsSuccessState(cachedWomensBags));
      return;
    }
    emit(HomeGetWomensBagsLoadingState());
    try {
      final womensBags = await getProductsByCategoryUseCase.call('womens-bags');
      cachedWomensBags = womensBags;
      emit(HomeGetWomensBagsSuccessState(womensBags));
    } catch (e) {
      emit(HomeGetWomensBagsErrorState(_cleanError(e, 'failed_to_load_bags'.tr())));
    }
  }
}