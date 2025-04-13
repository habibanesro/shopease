import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopease/domain/entities/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final updatedCart = List<Product>.from(currentState.cartItems)..add(event.product);
      emit(CartLoaded(cartItems: updatedCart));
    } else {
      emit(CartLoaded(cartItems: [event.product]));
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final updatedCart = List<Product>.from(currentState.cartItems)..remove(event.product);
      emit(CartLoaded(cartItems: updatedCart));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(CartLoaded(cartItems: []));
  }
}