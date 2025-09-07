import 'package:ecommerce/Views/widgets/product_items_grid.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/view_models/HomeCubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:shimmer/shimmer.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final heightB = MediaQuery.of(context).size.height;
    final widthB = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          BlocBuilder<HomeCubit, HomeState>(
            bloc: BlocProvider.of<HomeCubit>(context),
            builder: (context, state) {
              if (state is HomeLoading) {
                // ✅ Shimmer placeholder instead of spinner
                return SizedBox(
                  height: heightB * 0.22,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3, // 3 shimmer placeholders
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widthB * 0.015,
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: widthB * 0.75,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(
                                widthB * 0.05,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is HomeLoaded) {
                return FlutterCarousel.builder(
                  options: FlutterCarouselOptions(
                    height: heightB * 0.22,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 900,
                    ),
                    enlargeCenterPage: true,
                    viewportFraction: 0.85,
                    aspectRatio: 16 / 9,
                    slideIndicator: CircularSlideIndicator(
                      slideIndicatorOptions: SlideIndicatorOptions(
                        padding: const EdgeInsets.only(top: 10),
                        currentIndicatorColor: primaryColor,
                        indicatorBackgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                  itemCount: state.carousels.length,
                  itemBuilder:
                      (BuildContext context, int itemIndex, int pageViewIndex) {
                        return GestureDetector(
                          onTap: () {
                            // 👉 Optional navigation to carousel details if needed
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: widthB * 0.015,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                widthB * 0.05,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                widthB * 0.05,
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Carousel image
                                  Image.network(
                                    state.carousels[itemIndex].imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                  // ✅ Gradient overlay
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.4),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // ✅ Optional caption
                                  Positioned(
                                    bottom: 12,
                                    left: 16,
                                    child: Text(
                                      "Special Offer",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: widthB * 0.045,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black54,
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          SizedBox(height: heightB * 0.02),
          // Section Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widthB * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Featured Products",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: widthB * 0.055,
                    color: Colors.black87,
                    letterSpacing: 1.3,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: heightB * 0.007),
                  height: heightB * 0.004,
                  width: widthB * 0.13,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(widthB * 0.01),
                  ),
                ),
              ],
            ),
          ),
          // Products Grid
          const ProductItemsGrid(),
        ],
      ),
    );
  }
}
