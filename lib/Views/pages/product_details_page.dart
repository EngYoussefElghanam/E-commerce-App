import 'package:ecommerce/Models/cart_item_model.dart';
import 'package:ecommerce/Models/product_item_model.dart';
import 'package:ecommerce/Views/widgets/counter_widget.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/view_models/CartCubit/cart_cubit.dart';
import 'package:ecommerce/view_models/HomeCubit/home_cubit.dart';
import 'package:ecommerce/view_models/product_cubit/product_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:another_flushbar/flushbar.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;
  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().getProduct(widget.productId);
  }

  void _incrementQuantity() {
    if (_quantity < 99) setState(() => _quantity++);
  }

  void _decrementQuantity() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    final heightB = MediaQuery.of(context).size.height;
    final widthB = MediaQuery.of(context).size.width;

    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (state is ProductFailure) {
          return Scaffold(body: Center(child: Text(state.message)));
        }

        if (state is! ProductLoaded) {
          return const Scaffold(body: Center(child: Text('Product not found')));
        }

        final product = state.product;

        Widget productImage(String path) {
          final isUrl = path.startsWith('http');
          return isUrl
              ? Image.network(
                  path,
                  fit: BoxFit.cover,
                  height: heightB * 0.5,
                  width: double.infinity,
                )
              : Image.asset(
                  path,
                  fit: BoxFit.cover,
                  height: heightB * 0.5,
                  width: double.infinity,
                );
        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: Padding(
              padding: EdgeInsets.symmetric(horizontal: widthB * 0.01),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(CupertinoIcons.xmark),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: darkTextColor,
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthB * 0.01),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    color: product.isFavorite ? primaryColor : darkTextColor,
                    onPressed: () {
                      context.read<ProductsCubit>().toggleFavorite(
                        product.id,
                        context.read<HomeCubit>(), // pass the other cubit
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        productImage(product.imageUrl),
                        Padding(
                          padding: EdgeInsets.only(top: heightB * 0.4),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(widthB * 0.14),
                                topRight: Radius.circular(widthB * 0.14),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.all(widthB * 0.07),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium!
                                                  .copyWith(
                                                    color: darkTextColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            SizedBox(height: heightB * 0.01),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                SizedBox(width: widthB * 0.01),
                                                Text(
                                                  product.rating,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        color: darkTextColor,
                                                      ),
                                                ),
                                                SizedBox(width: widthB * 0.01),
                                                Text(
                                                  "(${product.reviewCount} reviews)",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(widthB * 0.07),
                                      child: CounterWidget(
                                        value: _quantity,
                                        onIncrement: _incrementQuantity,
                                        onDecrement: _decrementQuantity,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: widthB * 0.07,
                                  ),
                                  child: Text(
                                    "Size",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: darkTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  height: heightB * 0.08,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: widthB * 0.07,
                                    ),
                                    child: BlocBuilder<ProductsCubit, ProductsState>(
                                      builder: (context, sizeState) {
                                        if (sizeState is! ProductLoaded) {
                                          return const SizedBox();
                                        }

                                        final currProduct = sizeState.product;

                                        return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: Sizes.values.length,
                                          itemBuilder: (context, index) {
                                            final size = Sizes.values[index];
                                            final selected =
                                                currProduct.size == size;

                                            return Padding(
                                              padding: EdgeInsets.only(
                                                right: widthB * 0.03,
                                              ),
                                              child: InkWell(
                                                onTap: () => context
                                                    .read<ProductsCubit>()
                                                    .changeSize(
                                                      currProduct.id,
                                                      size,
                                                    ),
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                    widthB * 0.04,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: selected
                                                        ? primaryColor
                                                        : Colors.grey.shade200,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      size.name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                            color: selected
                                                                ? Colors.white
                                                                : darkTextColor,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: widthB * 0.07,
                                    vertical: heightB * 0.01,
                                  ),
                                  child: Text(
                                    "Description",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: darkTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: widthB * 0.07,
                                  ),
                                  child: Text(
                                    product.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                                SizedBox(height: heightB * 0.12),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: widthB * 0.07,
                      vertical: heightB * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "\$",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              TextSpan(
                                text: (product.price * _quantity)
                                    .toStringAsFixed(2),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        BlocBuilder<CartCubit, CartState>(
                          builder: (context, cartState) {
                            final isLoading = cartState is CartLoading;
                            return ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      BlocProvider.of<CartCubit>(
                                        context,
                                      ).addToCart(
                                        CartItemModel(
                                          id: product.id,
                                          name: product.name,
                                          price: product.price,
                                          size: product.size.name,
                                          quantity: _quantity,
                                          imgurl: product.imageUrl,
                                        ),
                                      );

                                      Flushbar(
                                        icon: const Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          widthB * 0.05,
                                        ),
                                        margin: EdgeInsets.all(widthB * 0.05),
                                        message: "Added to cart",
                                        duration: const Duration(seconds: 1),
                                        backgroundColor: Colors.greenAccent,
                                        flushbarStyle: FlushbarStyle.FLOATING,
                                        flushbarPosition: FlushbarPosition.TOP,
                                      ).show(context);

                                      Future.delayed(
                                        const Duration(seconds: 1),
                                      ).then((_) {
                                        if (mounted) Navigator.pop(context);
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isLoading
                                    ? Colors.grey
                                    : primaryColor,
                                padding: EdgeInsets.symmetric(
                                  horizontal: widthB * 0.06,
                                  vertical: heightB * 0.01,
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    )
                                  : Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.bag,
                                          color: Colors.white,
                                          size: widthB * 0.06,
                                        ),
                                        SizedBox(width: widthB * 0.02),
                                        Text(
                                          "Add to Cart",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
