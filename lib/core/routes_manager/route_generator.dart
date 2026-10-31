import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koki/core/routes_manager/routes.dart';
import 'package:koki/features/category/category_screen.dart';
import 'package:koki/features/forget_password/forget_password_screen.dart';
import 'package:koki/features/offers/offers_screen.dart';
import 'package:koki/features/profile/screens/account_info_screen.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../features/auth/presentation/screens/login/login_screen.dart';
import '../../features/auth/presentation/screens/register/register_screen.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/cart/pages/my_orders_screen.dart';
import '../../features/location/cubit/location_cubit.dart';
import '../../features/location/map_screen.dart';
import '../../features/main_layout/main_layout.dart';
import '../../features/offers/cubit/offers_cubit.dart';
import '../../features/onboarding/presentation/screens/language/language_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding/onboarding_screen.dart';
import '../../features/product_details/cubit/product_details_cubit.dart';
import '../../features/product_details/product_details_screen.dart';
import '../../features/products_screen/presentation/cubit/products_cubit.dart';
import '../../features/products_screen/presentation/screens/products_screen.dart';
import '../../features/profile/cubit/profile_cubit.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../di/service_locator.dart';


class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.cartRoute:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => const MainLayout());
      case Routes.productsScreenRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ProductsCubit>()..getProducts(),
            child: const ProductsScreen(),
          ),
        );
      case Routes.signInRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.splashScreenRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.signUpRoute:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case Routes.langueageRoute:
        return MaterialPageRoute(builder: (_) => const LanguageScreen());
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.category:
        return MaterialPageRoute(builder: (_) => const CategoryScreen());
      case Routes.forgetPassword:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());
      case Routes.accountInfoScreen:
        final userProfile = settings.arguments as UserProfileEntity;
        return MaterialPageRoute(
          builder: (_) => AccountInfoScreen(initialProfile: userProfile),
        );

      case Routes.profile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<ProfileCubit>()..getProfileData(),
            child: const ProfileScreen(),
          ),
        );
      case Routes.myOrders:
        return MaterialPageRoute(builder: (_) => const MyOrdersScreen());
      case Routes.offers:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<OffersCubit>()..loadOffers(),
            child: const OffersScreen(),
          ),
        );

      case Routes.productDetailsScreen:
        final productId = settings.arguments as int;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
            getIt<ProductDetailsCubit>()..getProductDetails(productId),
            child: const ProductDetailsScreen(),
          ),
        );

      case Routes.mapScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<LocationCubit>(),
            child: const MapScreen(),
          ),
        );

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("No Route Found")),
        body: const Center(child: Text("No Route Found")),
      ),
    );
  }
}