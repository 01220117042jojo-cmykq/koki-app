import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/data_sources/local_data_source/cart_local_data_source.dart';
import '../../data/data_sources/local_data_source/location_local_data_source.dart';
import '../../data/data_sources/remote_data_source/auth_remote_data_source.dart';
import '../../data/data_sources/remote_data_source/cart_remote_data_source.dart';
import '../../data/data_sources/remote_data_source/favourites_remote_data_source.dart';
import '../../data/data_sources/remote_data_source/location_remote_data_source.dart';
import '../../data/data_sources/remote_data_source/products_remote_data_source.dart';
import '../../data/data_sources/remote_data_source/profile_remote_data_source.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../data/repository/cart_repository_impl.dart';
import '../../data/repository/favourites_repository_impl.dart';
import '../../data/repository/location_repository_impl.dart';
import '../../data/repository/products_repository_impl.dart';
import '../../data/repository/profile_repository_impl.dart';
import '../../domain/repository/cart_repository.dart';
import '../../domain/repository/favourites_repository.dart';
import '../../domain/repository/location_repository.dart';
import '../../domain/repository/products_repository.dart';
import '../../domain/repository/profile_repository.dart';
import '../../domain/use_cases/add_to_cart_use_case.dart';
import '../../domain/use_cases/change_password_use_case.dart';
import '../../domain/use_cases/checkout_use_case.dart';
import '../../domain/use_cases/delete_account_use_case.dart';
import '../../domain/use_cases/delete_cart_use_case.dart';
import '../../domain/use_cases/get_all_products_use_case.dart';
import '../../domain/use_cases/get_cart_use_case.dart';
import '../../domain/use_cases/get_categories_use_case.dart';
import '../../domain/use_cases/get_offers_use_case.dart';
import '../../domain/use_cases/get_product_details_use_case.dart';
import '../../domain/use_cases/get_products_by_category_use_case.dart';
import '../../domain/use_cases/get_user_address_use_case.dart';
import '../../domain/use_cases/get_user_profile_use_case.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/register_use_case.dart';
import '../../domain/use_cases/search_products_use_case.dart';
import '../../domain/use_cases/update_cart_use_case.dart';
import '../../domain/use_cases/update_user_name_use_case.dart';
import '../../features/auth/presentation/screens/login/cubit/login_view_model.dart';
import '../../features/auth/presentation/screens/register/cubit/register_view_model.dart';
import '../../features/cart/cubit/cart_cubit.dart';
import '../../features/category/cubit/category_cubit.dart';
import '../../features/category/cubit/category_products_cubit.dart';
import '../../features/favourites/cubit/favourites_cubit.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/location/cubit/location_cubit.dart';
import '../../features/offers/cubit/offers_cubit.dart';
import '../../features/product_details/cubit/product_details_cubit.dart';
import '../../features/products_screen/presentation/cubit/products_cubit.dart';
import '../../features/profile/cubit/change_password_cubit.dart';
import '../../features/profile/cubit/delete_account_cubit.dart';
import '../../features/profile/cubit/profile_cubit.dart';
import '../../features/profile/cubit/update_profile_cubit.dart';
import '../../features/splash/cubit/splash_cubit.dart';
import '../network/cubit/network_cubit.dart';
import '../network/network_info.dart';
import '../network/network_info_impl.dart';
import '../services/url_launcher_service.dart';

final getIt = GetIt.instance;
  ///          Modules
Future<void> setupServiceLocator() async {
  /// CORE & EXTERNAL
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<UrlLauncherService>(
    () => UrlLauncherServiceImpl(),
  );
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  ///AUTH
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(),
  );
  getIt.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(repository: getIt<AuthRepositoryImpl>()),
  );
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(repository: getIt<AuthRepositoryImpl>()),
  );
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(loginUseCase: getIt<LoginUseCase>()),
  );
  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(registerUseCase: getIt<RegisterUseCase>()),
  );

  /// products and category
  getIt.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(getIt<ProductsRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetAllProductsUseCase>(
    () => GetAllProductsUseCase(getIt<ProductsRepository>()),
  );
  getIt.registerLazySingleton<SearchProductsUseCase>(
    () => SearchProductsUseCase(getIt<ProductsRepository>()),
  );
  getIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(getIt<ProductsRepository>()),
  );
  getIt.registerLazySingleton<GetProductsByCategoryUseCase>(
    () => GetProductsByCategoryUseCase(getIt<ProductsRepository>()),
  );
  getIt.registerLazySingleton<GetOffersUseCase>(
    () => GetOffersUseCase(repository: getIt<ProductsRepository>()),
  );
  getIt.registerLazySingleton<GetProductDetailsUseCase>(
    () => GetProductDetailsUseCase(getIt<ProductsRepository>()),
  );

  getIt.registerLazySingleton<CategoryCubit>(
    () => CategoryCubit(getIt<GetCategoriesUseCase>()),
  );
  getIt.registerFactory<CategoryProductsCubit>(
    () => CategoryProductsCubit(getIt<GetProductsByCategoryUseCase>()),
  );
  getIt.registerFactory<ProductsCubit>(
    () => ProductsCubit(getIt<GetAllProductsUseCase>()),
  );
  getIt.registerFactory<OffersCubit>(
    () => OffersCubit(getOffersUseCase: getIt<GetOffersUseCase>()),
  );
  getIt.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(
      getIt<GetProductDetailsUseCase>(),
      getIt<AddToCartUseCase>(),
    ),
  );
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(
      getIt<GetAllProductsUseCase>(),
      getIt<SearchProductsUseCase>(),
      getIt<GetProductsByCategoryUseCase>(),
    ),
  );

/// Cart
  getIt.registerLazySingleton<CartLocalDataSource>(
        () => CartLocalDataSource(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<CartRemoteDataSource>(
        () => CartRemoteDataSourceImpl(firestore: getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<CartRepository>(
        () => CartRepositoryImpl(
      remoteDataSource: getIt<CartRemoteDataSource>(),
      localDataSource: getIt<CartLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetCartUseCase>(
        () => GetCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<AddToCartUseCase>(
        () => AddToCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<UpdateCartUseCase>(
        () => UpdateCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<DeleteCartUseCase>(
        () => DeleteCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<CheckoutUseCase>(
        () => CheckoutUseCase(getIt<CartRepository>()),
  );

  getIt.registerLazySingleton<CartCubit>(
        () => CartCubit(
      getCartUseCase: getIt<GetCartUseCase>(),
      addToCartUseCase: getIt<AddToCartUseCase>(),
      updateCartUseCase: getIt<UpdateCartUseCase>(),
      deleteCartUseCase: getIt<DeleteCartUseCase>(),
      checkoutUseCase: getIt<CheckoutUseCase>(),
    ),
  );

/// Favourites
  getIt.registerLazySingleton<FavouritesRemoteDataSource>(
    () => FavouritesRemoteDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
      firebaseAuth: getIt<FirebaseAuth>(),
    ),
  );

  getIt.registerLazySingleton<FavouritesRepository>(
    () => FavouritesRepositoryImpl(
      remoteDataSource: getIt<FavouritesRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<FavouritesCubit>(
    () =>
        FavouritesCubit(repository: getIt<FavouritesRepository>())
          ..loadFavorites(),
  );

///Profile
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: getIt<ProfileRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<UpdateUserNameUseCase>(
    () => UpdateUserNameUseCase(repository: getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(repository: getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(repository: getIt<ProfileRepository>()),
  );

  getIt.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(getUserProfileUseCase: getIt<GetUserProfileUseCase>()),
  );
  getIt.registerFactory<UpdateProfileCubit>(
    () => UpdateProfileCubit(
      updateUserNameUseCase: getIt<UpdateUserNameUseCase>(),
    ),
  );
  getIt.registerFactory<ChangePasswordCubit>(
    () => ChangePasswordCubit(
      changePasswordUseCase: getIt<ChangePasswordUseCase>(),
    ),
  );
  getIt.registerFactory<DeleteAccountCubit>(
    () =>
        DeleteAccountCubit(deleteAccountUseCase: getIt<DeleteAccountUseCase>()),
  );

  /// Location
  getIt.registerLazySingleton<LocationLocalDataSource>(
        () => LocationLocalDataSourceImpl(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<LocationRemoteDataSource>(
        () => LocationRemoteDataSourceImpl(
      dio: getIt<Dio>(),
      firestore: getIt<FirebaseFirestore>(),
      firebaseAuth: getIt<FirebaseAuth>(),
    ),
  );
  getIt.registerLazySingleton<LocationRepository>(
        () => LocationRepositoryImpl(getIt<LocationRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetUserAddressUseCase>(
        () => GetUserAddressUseCase(getIt<LocationRepository>()),
  );

  getIt.registerLazySingleton<LocationCubit>(
        () => LocationCubit(
      getUserAddressUseCase: getIt<GetUserAddressUseCase>(),
      locationRepository: getIt<LocationRepository>(),
      localDataSource: getIt<LocationLocalDataSource>(),
      firebaseAuth: getIt<FirebaseAuth>(),
    )..loadSelectedAddress(),
  );

  /// Splash
  getIt.registerFactory<SplashCubit>(
    () => SplashCubit(getIt<SharedPreferences>()),
  );
  /// network
  getIt.registerLazySingleton<InternetConnection>(() => InternetConnection());
  getIt.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(getIt<InternetConnection>()),
  );
  getIt.registerLazySingleton<NetworkCubit>(
        () => NetworkCubit(networkInfo: getIt<NetworkInfo>()),
  );
}
