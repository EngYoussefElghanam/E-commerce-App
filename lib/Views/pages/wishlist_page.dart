import 'package:ecommerce/main.dart';
import 'package:ecommerce/utils/app_routes.dart';
import 'package:ecommerce/view_models/HomeCubit/home_cubit.dart';
import 'package:ecommerce/view_models/product_cubit/product_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final heightB = MediaQuery.of(context).size.height;
    final widthB = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        centerTitle: true,
        title: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoaded) {
              final count = state.products.where((p) => p.isFavorite).length;
              return Text(
                "Wishlist ($count)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: widthB * 0.05,
                ),
              );
            }
            return const Text("Wishlist");
          },
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          // ✅ Shimmer placeholders while loading
          if (state is HomeLoading) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widthB * 0.04,
                vertical: widthB * 0.02,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: widthB * 0.04,
                  mainAxisSpacing: heightB * 0.025,
                  childAspectRatio: 0.72,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Material(
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(widthB * 0.05),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(widthB * 0.05),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // image skeleton
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(widthB * 0.05),
                                ),
                                child: Container(color: Colors.white),
                              ),
                            ),
                            // name + heart skeleton lines
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: widthB * 0.03,
                                vertical: heightB * 0.012,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: heightB * 0.018,
                                    width: double.infinity,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: heightB * 0.008),
                                  Container(
                                    height: heightB * 0.018,
                                    width: widthB * 0.3,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            // price pill skeleton
                            Padding(
                              padding: EdgeInsets.only(
                                left: widthB * 0.03,
                                bottom: heightB * 0.012,
                              ),
                              child: Container(
                                height: heightB * 0.032,
                                width: widthB * 0.22,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is HomeLoaded) {
            final favorites = state.products
                .where((p) => p.isFavorite)
                .toList();

            if (favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.heart_slash,
                      size: widthB * 0.25,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Your wishlist is empty",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Add items you love to keep track of them!",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(
                          horizontal: widthB * 0.1,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
                          AppRoutes.home,
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Start Shopping",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widthB * 0.04,
                vertical: widthB * 0.02,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: widthB * 0.04,
                  mainAxisSpacing: heightB * 0.025,
                  childAspectRatio: 0.72,
                ),
                itemCount: favorites.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = favorites[index];

                  return GestureDetector(
                    onTap: () {
                      rootNavigatorKey.currentState
                          ?.pushNamed(
                            AppRoutes.productDetails,
                            arguments: product.id,
                          )
                          .then((_) {
                            context.read<HomeCubit>().loadHomeData();
                          });
                    },
                    child: AnimatedScale(
                      scale: 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Material(
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(widthB * 0.05),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(widthB * 0.05),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // image (no shimmer here anymore)
                              Expanded(
                                child: Hero(
                                  tag: "product_${product.id}",
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(widthB * 0.05),
                                    ),
                                    child: Image.network(
                                      product.imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                              ),

                              // name + favorite button
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: widthB * 0.03,
                                  vertical: heightB * 0.012,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: widthB * 0.043,
                                              color: Colors.black87,
                                            ),
                                      ),
                                    ),
                                    BlocBuilder<HomeCubit, HomeState>(
                                      buildWhen: (prev, curr) =>
                                          curr is HomeLoaded,
                                      builder: (context, state) {
                                        return GestureDetector(
                                          onTap: () {
                                            context
                                                .read<HomeCubit>()
                                                .toggleFavorite(
                                                  product.id,
                                                  context.read<ProductsCubit>(),
                                                );
                                          },
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            transitionBuilder:
                                                (child, animation) =>
                                                    ScaleTransition(
                                                      scale: animation,
                                                      child: child,
                                                    ),
                                            child: Icon(
                                              product.isFavorite
                                                  ? CupertinoIcons.heart_fill
                                                  : CupertinoIcons.heart,
                                              key: ValueKey(product.isFavorite),
                                              color: product.isFavorite
                                                  ? const Color(0xffff6b6b)
                                                  : Colors.black54,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              // price tag
                              Padding(
                                padding: EdgeInsets.only(
                                  left: widthB * 0.03,
                                  bottom: heightB * 0.012,
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: widthB * 0.03,
                                    vertical: heightB * 0.007,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "\$${product.price.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: widthB * 0.04,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
