import 'package:ecommerce/utils/app_router.dart';
import 'package:ecommerce/utils/app_routes.dart';
import 'package:ecommerce/view_models/CartCubit/cart_cubit.dart';
import 'package:ecommerce/view_models/HomeCubit/home_cubit.dart';
import 'package:ecommerce/view_models/auth_cubit/auth_cubit_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

const Color primaryColor = Color(0xFFFF6B6B); // Coral Punch
const Color backgroundColor = Colors.white; // Soft Cream
const Color darkTextColor = Color(0xFF3F3D56); // Deep Indigo
const Color secondaryColor = Color(0xFF7BC96F); // Moss Green
const Color infoColor = Color(0xFF7FDBFF); // Muted Sky Blue
const Color grayColor = Color(0xFF6E7582); // Slate Gray
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = AuthCubitCubit();
            cubit.checkAuth();
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = CartCubit();
            cubit.startCartStream();
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = HomeCubit();
            cubit.loadHomeData();
            return cubit;
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final authCubit = BlocProvider.of<AuthCubitCubit>(context);
          return BlocBuilder<AuthCubitCubit, AuthCubitState>(
            bloc: authCubit,
            buildWhen: (previous, current) =>
                current is AuthCubitSuccess || current is AuthCubitInitial,
            builder: (context, state) {
              return MaterialApp(
                navigatorKey: rootNavigatorKey,
                title: 'Shoporia',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  useMaterial3: true,
                  scaffoldBackgroundColor: backgroundColor,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: primaryColor,
                    brightness: Brightness.light,
                    primary: primaryColor,
                    secondary: secondaryColor,
                    onPrimary: Colors.white, // Text on primary color
                    onSecondary: Colors.white,
                    surface: Colors.white,
                    onSurface: grayColor,
                  ),
                  appBarTheme: const AppBarTheme(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    selectedItemColor: primaryColor,
                    // ignore: deprecated_member_use
                    unselectedItemColor: grayColor.withOpacity(0.6),
                    backgroundColor: Colors.white,
                    showUnselectedLabels: true,
                  ),
                  textTheme: ThemeData.light().textTheme.apply(
                    bodyColor: darkTextColor,
                    displayColor: darkTextColor,
                  ),
                ),
                initialRoute: state is AuthCubitSuccess
                    ? AppRoutes.home
                    : AppRoutes.login,
                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
