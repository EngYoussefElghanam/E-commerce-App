import 'package:ecommerce/view_models/categories_cubit/categories_cubit.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/utils/app_routes.dart';
import 'package:ecommerce/view_models/HomeCubit/home_cubit.dart';
import 'package:ecommerce/view_models/product_cubit/product_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPage extends StatelessWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final heightB = MediaQuery.of(context).size.height;
    final widthB = MediaQuery.of(context).size.width;

    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, catState) {
        Color? categoryColor;

        if (catState is CategoriesLoaded) {
          final matchedCategory = catState.categories.firstWhere(
            (c) => c.title == category,
            orElse: () => catState.categories.first,
          );
          categoryColor = matchedCategory.bgcolor;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: categoryColor ?? Colors.grey.shade200,
            title: Text(
              category,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            elevation: 1,
          ),

          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is HomeLoaded) {
                final products = state.products
                    .where((p) => p.category == category)
                    .toList();

                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      "No products in $category",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widthB * 0.04,
                    vertical: widthB * 0.04,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
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
                        key: ValueKey(product.id), 
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
                                            context
                                                .read<HomeCubit>()
                                                .toggleFavorite(
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

                              // ✅ Product Info
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: widthB * 0.025,
                                  vertical: heightB * 0.01,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: widthB * 0.045,
                                            color: Colors.black87,
                                          ),
                                    ),
                                    SizedBox(height: heightB * 0.005),
                                    Text(
                                      "\$${product.price.toStringAsFixed(2)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
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
          ),
        );
      },
    );
  }
}
