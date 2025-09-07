import 'package:ecommerce/Views/categories_tab_view.dart';
import 'package:ecommerce/Views/home_tab_view.dart';
import 'package:ecommerce/Views/widgets/custom_app_bar.dart';
import 'package:ecommerce/view_models/HomeCubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    ); // Home and Categories tabs
  }

  @override
  Widget build(BuildContext context) {
    final heightB = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) {
        final cubit = HomeCubit();
        cubit.loadHomeData();
        return cubit;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            CustomAppBar(),
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: "Home"),
                  Tab(text: "Categories"),
                ],
              ),
            ),
            SizedBox(height: heightB * 0.02),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [HomeTabView(), CategoriesTabView()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
