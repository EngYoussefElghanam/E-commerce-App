import 'package:ecommerce/Views/widgets/categories_items.dart';
import 'package:ecommerce/view_models/categories_cubit/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesTabView extends StatelessWidget {
  const CategoriesTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesCubit()..fetchCategories(),
      child: const CategoriesItems(),
    );
  }
}
