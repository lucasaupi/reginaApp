import 'package:regina_app/domain/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

   CartItem copyWith(
    {
      Product? product,
       int? quantity
       })
   {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
   }
}