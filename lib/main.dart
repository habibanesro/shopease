import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease/core/themes/app_theme.dart';
import 'package:shopease/core/utils/dependency_injection.dart';
import 'package:shopease/domain/entities/product.dart';
import 'package:shopease/presentation/bloc/cart/cart_bloc.dart';
import 'package:shopease/presentation/bloc/favorite/favorite_bloc.dart';
import 'package:shopease/presentation/bloc/product/product_bloc.dart';
import 'package:shopease/presentation/screens/cart_screen.dart';
import 'package:shopease/presentation/screens/favorites_screen.dart';
import 'package:shopease/presentation/screens/product_detail_screen.dart';
import 'package:shopease/presentation/screens/product_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopease/domain/usecases/get_products.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const ShopEaseApp());
}

class ShopEaseApp extends StatelessWidget {
  const ShopEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductBloc(getProducts: getIt<GetProducts>())..add(FetchProducts()),
        ),
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(
          create: (_) => FavoriteBloc(
            sharedPreferences: getIt<SharedPreferences>(),
          )..add(LoadFavorites()),
        ),
      ],
      child: MaterialApp(
        title: 'ShopEase',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const ProductListScreen(),
          '/product_detail': (context) {
            final product = ModalRoute.of(context)!.settings.arguments as Product;
            return ProductDetailScreen(product: product);
          },
          '/cart': (context) => const CartScreen(),
          '/favorites': (context) => const FavoritesScreen(),
        },
      ),
    );
  }
}