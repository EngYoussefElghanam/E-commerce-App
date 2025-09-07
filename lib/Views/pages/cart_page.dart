import 'package:ecommerce/Models/cart_item_model.dart';
import 'package:ecommerce/Views/widgets/counter_widget.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/utils/app_routes.dart';
import 'package:ecommerce/view_models/CartCubit/cart_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().startCartStream();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is CartError) {
            return Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (state is CartItems && state.items.isNotEmpty) {
            final items = state.items;
            final subtotal = state.subTotal;
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CartItemTile(item: items[index]);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: Column(
                      children: [
                        _summaryRow(
                          "Subtotal",
                          "\$${subtotal.toStringAsFixed(2)}",
                        ),
                        _summaryRow("Shipping", "\$3.00"),
                        const Divider(),
                        _summaryRow(
                          "Total",
                          "\$${(subtotal + 3).toStringAsFixed(2)}",
                          isBold: true,
                        ),
                        SizedBox(height: size.height * 0.025),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: Size(size.width, size.height * 0.06),
                          ),
                          onPressed: () {
                            rootNavigatorKey.currentState?.pushNamed(
                              AppRoutes.checkoutRoute,
                            );
                          },
                          child: Text(
                            "Proceed to Checkout",
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // ✅ Modern Empty Cart State
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.cart_badge_minus,
                      size: size.width * 0.3,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Your cart is empty",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Looks like you haven’t added anything yet. Start shopping and fill your cart!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final CartItemModel item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.012,
      ),
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12), // darker & more visible
            blurRadius: 20, // softer + larger blur for depth
            spreadRadius: 2, // wider spread
            offset: const Offset(0, 6), // floating effect
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(size.width * 0.04),
            child: Image.network(
              item.imgurl,
              width: size.width * 0.25,
              height: size.height * 0.14,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: size.width * 0.04),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Delete Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.trash, color: Colors.red),
                      onPressed: () =>
                          context.read<CartCubit>().removeFromCart(item),
                    ),
                  ],
                ),

                Text(
                  "Size: ${item.size}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                ),
                SizedBox(height: size.height * 0.012),

                // Counter + Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CounterWidget(
                      value: item.quantity,
                      onIncrement: () {
                        final newQuantity = item.quantity + 1;
                        if (newQuantity <= 99) {
                          context.read<CartCubit>().updateItemQuantity(
                            item.id,
                            newQuantity,
                          );
                        }
                      },
                      onDecrement: () {
                        final newQuantity = item.quantity - 1;
                        if (newQuantity >= 1) {
                          context.read<CartCubit>().updateItemQuantity(
                            item.id,
                            newQuantity,
                          );
                        }
                      },
                    ),
                    Text(
                      "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
