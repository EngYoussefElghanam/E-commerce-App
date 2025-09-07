import 'package:ecommerce/view_models/categories_cubit/categories_cubit.dart';
import 'package:ecommerce/utils/app_routes.dart';
import 'package:ecommerce/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesItems extends StatelessWidget {
  const CategoriesItems({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoriesError) {
          return Center(child: Text("Error: ${state.message}"));
        } else if (state is CategoriesLoaded) {
          final categories = state.categories;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return InkWell(
                onTap: () => rootNavigatorKey.currentState?.pushNamed(
                  AppRoutes.categoryPage,
                  arguments: category.title,
                ),
                child: Container(
                  margin: EdgeInsets.all(width * 0.02),
                  width: width * 0.5,
                  decoration: BoxDecoration(
                    color: category.bgcolor,
                    borderRadius: BorderRadius.circular(width * 0.05),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        category.imageUrl,
                        height: height * 0.5,
                        width: width * 0.42,
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        category.title,
                        style: Theme.of(context).textTheme.headlineSmall!
                            .copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: height * 0.004),
                      Text(
                        '${category.productCount} products',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.black87,
                          fontSize: width * 0.03,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink(); // for CategoriesInitial
      },
    );
  }
}
