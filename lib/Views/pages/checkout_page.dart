import 'dart:async';

import 'package:ecommerce/Models/add_card_model.dart';
import 'package:ecommerce/Models/location.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/services/checkout_service.dart';
import 'package:ecommerce/utils/app_routes.dart';
import 'package:ecommerce/view_models/CartCubit/cart_cubit.dart';
import 'package:ecommerce/view_models/CheckouCubit/checkout_cubit.dart';
import 'package:ecommerce/view_models/PlaceOrderCubit/place_order_cubit.dart';
import 'package:ecommerce/view_models/add_location_cubit/add_location_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  StreamSubscription? _cartSubscription; // ✅ hold subscription

  @override
  void initState() {
    super.initState();
    final cartCubit = context.read<CartCubit>();
    cartCubit.startCartStream();

    _cartSubscription = cartCubit.stream.listen((state) {
      if (state is CartItems) {
        if (mounted) {
          context.read<CheckoutCubit>().checkoutLoadData();
        }
      }
    });
  }

  @override
  void dispose() {
    _cartSubscription?.cancel(); // ✅ cancel subscription when leaving
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heightB = MediaQuery.of(context).size.height;
    final widthB = MediaQuery.of(context).size.width;

    // ---------- Shipping Section ----------
    Widget buildShippingMethod(List<Location>? chosenMethod) {
      if (chosenMethod != null &&
          chosenMethod.isNotEmpty &&
          chosenMethod.any((address) => address.isSelected)) {
        final location = chosenMethod.firstWhere((l) => l.isSelected);
        return _modernCard(
          widthB,
          heightB,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(widthB * 0.03),
                child: Image.asset(
                  location.imageURL,
                  width: widthB * 0.28,
                  height: heightB * 0.12,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: widthB * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.country,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: heightB * 0.008),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.location_solid,
                          size: widthB * 0.045,
                          color: Colors.black,
                        ),
                        SizedBox(width: widthB * 0.01),
                        Expanded(
                          child: Text(
                            "${location.city}, ${location.country}",
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                color: primaryColor,
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.addLocation).then((
                      _,
                    ) {
                      context.read<CheckoutCubit>().checkoutLoadData();
                    }),
              ),
            ],
          ),
        );
      } else {
        return _emptyCard(
          context,
          widthB,
          heightB,
          icon: CupertinoIcons.add,
          text: "Add Shipping Address",
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.addLocation).then((_) {
              context.read<CheckoutCubit>().checkoutLoadData();
            });
          },
        );
      }
    }

    // ---------- Payment Section ----------
    Widget buildPaymentMethod(List<cardDetailsModel>? chosenMethod) {
      if (chosenMethod != null &&
          chosenMethod.isNotEmpty &&
          chosenMethod.any((card) => card.checked)) {
        final selectedCard = chosenMethod.firstWhere((card) => card.checked);
        return _modernCard(
          widthB,
          heightB,
          child: ListTile(
            leading: Image.asset(
              'assets/images/card.png',
              height: heightB * 0.05,
              width: widthB * 0.1,
            ),
            title: Text(
              selectedCard.cardHolderName,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "**** **** **** ${selectedCard.cardNumber.substring(14)}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: Icon(CupertinoIcons.right_chevron, color: Colors.grey),
            onTap: () {
              _showPaymentMethods(context, widthB, heightB);
            },
          ),
        );
      } else if (chosenMethod != null && chosenMethod.isNotEmpty) {
        return _emptyCard(
          context,
          widthB,
          heightB,
          icon: CupertinoIcons.creditcard,
          text: "Choose Payment Method",
          onTap: () {
            _showPaymentMethods(context, widthB, heightB);
          },
        );
      } else {
        return _emptyCard(
          context,
          widthB,
          heightB,
          icon: CupertinoIcons.creditcard,
          text: "Add Payment Method",
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.addPaymentMethod).then((_) {
              context.read<CheckoutCubit>().checkoutLoadData();
            });
          },
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Checkout'),
        elevation: 0.5,
        foregroundColor: darkTextColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: heightB * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Shipping Address", Icons.location_on_outlined),
                  BlocBuilder<CheckoutCubit, CheckoutState>(
                    builder: (context, checkoutState) {
                      return BlocBuilder<AddLocationCubit, AddLocationState>(
                        buildWhen: (_, current) =>
                            current is AddLocationSuccess ||
                            current is AddLocationLoading ||
                            current is AddLocationInitial,
                        builder: (context, addLocationState) {
                          if (addLocationState is AddLocationSuccess) {
                            return buildShippingMethod(
                              addLocationState.locations,
                            );
                          } else {
                            final uid = FirebaseAuth.instance.currentUser!.uid;
                            return StreamBuilder<List<Location>>(
                              stream: CheckoutImpl().addressesStream(uid),
                              builder: (context, snapshot) {
                                return buildShippingMethod(snapshot.data ?? []);
                              },
                            );
                          }
                        },
                      );
                    },
                  ),

                  _sectionTitle("Products", CupertinoIcons.bag),
                  BlocBuilder<CartCubit, CartState>(
                    buildWhen: (_, current) => current is CartItems,
                    builder: (context, state) {
                      if (state is CartItems && state.items.isNotEmpty) {
                        return Column(
                          children: state.items.map((item) {
                            return _modernCard(
                              widthB,
                              heightB,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      widthB * 0.03,
                                    ),
                                    child: Image.network(
                                      item.imgurl,
                                      width: widthB * 0.22,
                                      height: heightB * 0.12,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: widthB * 0.03),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        SizedBox(height: heightB * 0.005),
                                        Text(
                                          "Size: ${item.size}",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        SizedBox(height: heightB * 0.01),
                                        Text(
                                          "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: darkTextColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => context
                                        .read<CartCubit>()
                                        .removeFromCart(item),
                                    icon: Icon(
                                      CupertinoIcons.trash,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  _sectionTitle("Payment", CupertinoIcons.creditcard),
                  BlocBuilder<CheckoutCubit, CheckoutState>(
                    builder: (context, state) {
                      if (state is CheckoutLoaded) {
                        return buildPaymentMethod(state.chosenPaymentMethod);
                      } else if (state is CheckoutLoading) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
          // ---------- Bottom Place Order ----------
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              double total = 0;
              List<String> productNames = [];
              List<int> productQuantities = [];

              if (state is CartItems) {
                total = state.subTotal + 3;
                productNames = state.items.map((e) => e.name).toList();
                productQuantities = state.items.map((e) => e.quantity).toList();
              }

              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: widthB * 0.05,
                  vertical: heightB * 0.015,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: widthB * 0.03,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${total.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      BlocConsumer<PlaceOrderCubit, PlaceOrderState>(
                        listener: (context, orderState) {
                          if (orderState is OrderPlaced) {
                            showModalBottomSheet(
                              context: context,
                              isDismissible: false,
                              enableDrag: false,
                              backgroundColor: Colors.transparent,
                              builder: (_) => Center(
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  margin: const EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Lottie.asset(
                                        'assets/animations/success.json',
                                        repeat: false,
                                        onLoaded: (composition) {
                                          Future.delayed(
                                            composition.duration,
                                            () {
                                              Navigator.pop(
                                                context,
                                              ); // close modal
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                AppRoutes
                                                    .home, // 👈 your home route
                                                (route) => false,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        "Order placed successfully!",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else if (orderState is PlaceOrderError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(orderState.message)),
                            );
                          }
                        },
                        builder: (context, orderState) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: widthB * 0.15,
                                vertical: heightB * 0.018,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  widthB * 0.03,
                                ),
                              ),
                              elevation: 3,
                            ),
                            onPressed:
                                (state is CartItems && state.items.isNotEmpty)
                                ? () {
                                    context.read<PlaceOrderCubit>().placeOrder(
                                      productNames: productNames,
                                      productQuantities: productQuantities,
                                      totalPrice: total,
                                    );
                                  }
                                : null,
                            child: orderState is PlacingOrder
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Place Order",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------- Helpers ----------
  Widget _modernCard(double widthB, double heightB, {required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: widthB * 0.04,
        vertical: heightB * 0.008,
      ),
      padding: EdgeInsets.all(widthB * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widthB * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: widthB * 0.03,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 6),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _emptyCard(
    BuildContext context,
    double widthB,
    double heightB, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: _modernCard(
        widthB,
        heightB,
        child: Column(
          children: [
            Icon(icon, size: widthB * 0.08, color: primaryColor),
            SizedBox(height: heightB * 0.01),
            Text(text, style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethods(
    BuildContext context,
    double widthB,
    double heightB,
  ) {
    final checkoutCubit = context.read<CheckoutCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(widthB * 0.05),
        ),
      ),
      builder: (_) => BlocProvider.value(
        value: checkoutCubit,
        child: BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            if (state is CheckoutLoaded) {
              final cards = state.chosenPaymentMethod ?? [];
              return SizedBox(
                height: heightB * 0.5, // 👈 restrict to half screen
                child: Padding(
                  padding: EdgeInsets.all(widthB * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Handle drag bar
                      Center(
                        child: Container(
                          width: widthB * 0.15,
                          height: 5,
                          margin: EdgeInsets.only(bottom: heightB * 0.015),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Text(
                        "Choose Payment Method",
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: heightB * 0.02),
                      // --- Cards List
                      Expanded(
                        child: ListView.builder(
                          itemCount: cards.length,
                          itemBuilder: (_, i) {
                            final card = cards[i];
                            return _modernCard(
                              widthB,
                              heightB,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                leading: Image.asset(
                                  'assets/images/card.png',
                                  width: widthB * 0.1,
                                ),
                                title: Text(
                                  card.cardHolderName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  "**** **** **** ${card.cardNumber.substring(14)}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: card.checked,
                                      activeColor: primaryColor,
                                      onChanged: (val) {
                                        checkoutCubit.buttonChecked(
                                          card.id,
                                          val ?? false,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          checkoutCubit.deleteCard(card.id),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.redAccent,
                                        size: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // --- Add new method
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(
                            vertical: heightB * 0.018,
                            horizontal: widthB * 0.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            AppRoutes.addPaymentMethod,
                          );
                        },
                        icon: Icon(CupertinoIcons.add, color: Colors.white),
                        label: const Text(
                          "Add Payment Method",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

void showOrderProgressSheet(BuildContext context, PlaceOrderState state) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      if (state is PlacingOrder) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  "Placing your order...",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        );
      } else if (state is OrderPlaced) {
        return SizedBox(
          height: 250,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/animations/success.json',
                  repeat: false,
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 20),
                Text(
                  "Order placed successfully!",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (state is PlaceOrderError) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 60),
                const SizedBox(height: 15),
                Text(
                  state.message,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    },
  );
}
