import 'package:ecommerce/Views/pages/add_location.dart';
import 'package:ecommerce/Views/pages/add_payment.dart';
import 'package:ecommerce/Views/pages/addresses_page.dart';
import 'package:ecommerce/Views/pages/category_page.dart';
import 'package:ecommerce/Views/pages/checkout_page.dart';
import 'package:ecommerce/Views/pages/custom_button_navbar.dart';
import 'package:ecommerce/Views/pages/edit_profile_page.dart';
import 'package:ecommerce/Views/pages/payment_methods.dart';
import 'package:ecommerce/Views/pages/product_details_page.dart';
import 'package:ecommerce/Views/pages/register_page.dart';
import 'package:ecommerce/Views/pages/sign_page.dart';
import 'package:ecommerce/services/checkout_service.dart';
import 'package:ecommerce/services/order_service.dart';
import 'package:ecommerce/utils/app_routes.dart';
import 'package:ecommerce/view_models/AddCardCubit/add_card_cubit.dart';
import 'package:ecommerce/view_models/CartCubit/cart_cubit.dart';
import 'package:ecommerce/view_models/CheckouCubit/checkout_cubit.dart';
import 'package:ecommerce/view_models/CounterCubit/counter_cubit.dart';
import 'package:ecommerce/view_models/PlaceOrderCubit/place_order_cubit.dart';
import 'package:ecommerce/view_models/ProductDetailsCubit/prouduct_details_cubit.dart';
import 'package:ecommerce/view_models/add_location_cubit/add_location_cubit.dart';
import 'package:ecommerce/view_models/auth_cubit/auth_cubit_cubit.dart';
import 'package:ecommerce/view_models/categories_cubit/categories_cubit.dart';
import 'package:ecommerce/view_models/product_cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final String? productId = settings.arguments as String?;
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthCubitCubit(),
            child: SignPage(),
          ),
        );
      case AppRoutes.registration:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthCubitCubit(),
            child: RegisterPage(),
          ),
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) {
                  final cubit = ProuductDetailsCubit();
                  cubit.loadProductDetails(productId!);
                  return cubit;
                },
              ),
              BlocProvider(create: (context) => ProductsCubit()),
              BlocProvider(create: (context) => CounterCubit()),
            ],
            child: const ButtomNavBar(),
          ),
        );
      case AppRoutes.checkoutRoute:
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => MultiRepositoryProvider(
            providers: [
              RepositoryProvider<OrderService>(
                create: (context) => OrderImpl(),
              ),
              RepositoryProvider<CheckoutService>(
                create: (context) => CheckoutImpl(),
              ),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) {
                    final cubit = CheckoutCubit(
                      BlocProvider.of<CartCubit>(context),
                    );
                    cubit.checkoutLoadData();
                    return cubit;
                  },
                ),
                BlocProvider(create: (context) => AddLocationCubit()),
                BlocProvider(
                  create: (context) => PlaceOrderCubit(
                    cartCubit: BlocProvider.of<CartCubit>(context),
                    orderService: RepositoryProvider.of<OrderService>(context),
                    checkoutService: RepositoryProvider.of<CheckoutService>(
                      context,
                    ),
                  ),
                ),
              ],
              child: const CheckoutPage(),
            ),
          ),
        );
      case AppRoutes.addPaymentMethod:
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => BlocProvider(
            create: (context) => AddCardCubit(),
            child: const AddPayment(),
          ),
        );
      case AppRoutes.productDetails:
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) {
                  final cubit = ProuductDetailsCubit();
                  cubit.loadProductDetails(productId!);
                  return cubit;
                },
              ),
              BlocProvider(create: (context) => ProductsCubit()),
              BlocProvider(create: (context) => CartCubit()),
              BlocProvider(create: (context) => CounterCubit()),
            ],
            child: ProductDetailsPage(productId: productId!),
          ),
        );
      case AppRoutes.addLocation:
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => BlocProvider(
            create: (context) => AddLocationCubit(),
            child: const AddLocation(),
          ),
        );
      case AppRoutes.categoryPage:
        final category = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => CategoriesCubit()..fetchCategories(),
              ),
              BlocProvider(create: (context) => ProductsCubit()),
            ],
            child: CategoryPage(category: category),
          ),
        );

      case AppRoutes.addressesPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AddLocationCubit(),
            child: AddressesPage(),
          ),
        );

      case AppRoutes.paymentMethods:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                CheckoutCubit(BlocProvider.of<CartCubit>(context)),
            child: PaymentMethods(),
          ),
        );

      case AppRoutes.editProfile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                CheckoutCubit(BlocProvider.of<CartCubit>(context)),
            child: EditProfilePage(),
          ),
        );

      // Add more routes as needed
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
