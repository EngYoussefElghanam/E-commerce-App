import 'package:ecommerce/main.dart';
import 'package:ecommerce/utils/app_routes.dart';
import 'package:ecommerce/view_models/HomeCubit/home_cubit.dart';
import 'package:ecommerce/view_models/product_cubit/product_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart'; // ✅ added

class ProductItemsGrid extends StatelessWidget {
  const ProductItemsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final heightB = MediaQuery.of(context).size.height;
    final widthB = MediaQuery.of(context).size.width;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          // ✅ Show shimmer placeholders instead of CircularProgressIndicator
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: widthB * 0.04),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: widthB * 0.04,
                mainAxisSpacing: heightB * 0.02,
                childAspectRatio: 0.7,
              ),
              itemCount: 6, // ✅ Show 6 shimmer placeholders
              itemBuilder: (BuildContext context, int index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(widthB * 0.03),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is HomeLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return const Center(child: Text("No products available"));
          }

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widthB * 0.04, // ✅ away from phone walls
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: widthB * 0.04,
                mainAxisSpacing: heightB * 0.02,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(widthB * 0.03),
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
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(widthB * 0.03),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Image + Favorite button
                        Expanded(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(widthB * 0.03),
                                ),
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              Positioned(
                                top: heightB * 0.01,
                                right: widthB * 0.02,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    iconSize: widthB * 0.07,
                                    onPressed: () {
                                      context.read<HomeCubit>().toggleFavorite(
                                        product.id,
                                        context.read<ProductsCubit>(),
                                      );
                                    },
                                    icon: Icon(
                                      product.isFavorite
                                          ? CupertinoIcons.heart_fill
                                          : CupertinoIcons.heart,
                                      color: product.isFavorite
                                          ? const Color(0xffff6b6b)
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ✅ Product Info (left aligned)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: widthB * 0.025,
                            vertical: heightB * 0.01,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // ✅ left
                            children: [
                              Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: widthB * 0.045,
                                      color: Colors.black87,
                                    ),
                              ),
                              SizedBox(height: heightB * 0.005),
                              Text(
                                "\$${product.price.toStringAsFixed(2)}",
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: widthB * 0.043,
                                      color: Colors.black,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
    );
  }
}
