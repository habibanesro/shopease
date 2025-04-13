import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease/domain/entities/product.dart';
import 'package:shopease/presentation/bloc/cart/cart_bloc.dart';
import 'package:shopease/presentation/bloc/favorite/favorite_bloc.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.image,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(product.description),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlocBuilder<FavoriteBloc, FavoriteState>(
                  builder: (context, state) {
                    bool isFavorite = false;
                    if (state is FavoriteLoaded) {
                      isFavorite = state.favorites.any((p) => p.id == product.id);
                    }
                    return ElevatedButton.icon(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      label: Text(isFavorite ? 'Saved' : 'Save'),
                      onPressed: () {
                        if (isFavorite) {
                          context.read<FavoriteBloc>().add(RemoveFromFavorites(product: product));
                        } else {
                          context.read<FavoriteBloc>().add(AddToFavorites(product: product));
                        }
                      },
                    );
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Add to Cart'),
                  onPressed: () {
                    context.read<CartBloc>().add(AddToCart(product: product));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cart')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}