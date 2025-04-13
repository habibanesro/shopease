part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<Product> cartItems;

  const CartLoaded({required this.cartItems});

  double get totalPrice => cartItems.fold(
    0,
    (previousValue, product) => previousValue + product.price,
  );

  @override
  List<Object> get props => [cartItems];
}