import 'dart:async';
import 'package:ecommerce/services/firestore_service.dart';
import 'package:ecommerce/services/product_repository.dart';
import 'package:ecommerce/view_models/product_cubit/product_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/Models/carousel_item_model.dart';
import 'package:ecommerce/Models/product_item_model.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  StreamSubscription? _favoritesSub;

  HomeCubit() : super(HomeLoading());

  Future<void> loadHomeData() async {
    try {
      emit(HomeLoading());

      // Load products
      final products = await FirestoreServices.getData(
        collectionName: "Products",
        fromMap: (data, docId) => ProductItemModel.fromMap(data, docId),
      );

      // Load carousels
      final carousels = await FirestoreServices.getData(
        collectionName: "announcement",
        fromMap: (data, docId) => CarouselItemModel.fromMap(data),
      );
      carouselItems = carousels;

      // Start listening to favorites
      final userId = FirebaseAuth.instance.currentUser?.uid;
      _favoritesSub?.cancel();
      _favoritesSub =
          FirestoreServices.streamData(
            collectionName: "users/$userId/Favorited",
            fromMap: (data, docId) => docId,
          ).listen((favoriteIds) {
            final updatedProducts = products.map((p) {
              return p.copyWith(isFavorite: favoriteIds.contains(p.id));
            }).toList();

            emit(HomeLoaded(products: updatedProducts, carousels: carousels));
          });
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> toggleFavorite(
    String productId,
    ProductsCubit? productsCubit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    final toggledProduct = currentState.products.firstWhere(
      (p) => p.id == productId,
    );
    final newStatus = !toggledProduct.isFavorite;

    // Optimistic UI update
    updateFavoriteStatus(productId, newStatus);
    productsCubit?.updateFavoriteStatus(productId, newStatus);

    try {
      await ProductRepository.toggleFavoriteStatus(
        productId: productId,
        currentStatus: toggledProduct.isFavorite,
      );
    } catch (e) {
      // rollback
      updateFavoriteStatus(productId, toggledProduct.isFavorite);
      productsCubit?.updateFavoriteStatus(productId, toggledProduct.isFavorite);
    }
  }

  void updateFavoriteStatus(String productId, bool newStatus) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      final updatedProducts = currentState.products.map((p) {
        return p.id == productId ? p.copyWith(isFavorite: newStatus) : p;
      }).toList();

      emit(
        HomeLoaded(
          products: updatedProducts,
          carousels: currentState.carousels,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _favoritesSub?.cancel();
    return super.close();
  }
}
