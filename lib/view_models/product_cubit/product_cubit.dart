import 'package:ecommerce/services/firestore_service.dart';
import 'package:ecommerce/services/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/Models/product_item_model.dart';
import 'package:ecommerce/view_models/HomeCubit/home_cubit.dart';
part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductInitial());

  Future<void> getProduct(String productId) async {
    try {
      emit(ProductLoading());

      final product = await FirestoreServices.getDocData(
        collectionName: "Products",
        docName: productId,
        fromMap: (data, docId) => ProductItemModel.fromMap(data, docId),
      );

      if (product == null) {
        emit(ProductFailure("Product not found"));
        return;
      }

      // check if it's favorited for this user
      final isFav = await ProductRepository.isProductFavorited(productId);

      emit(ProductLoaded(product.copyWith(isFavorite: isFav)));
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  Future<void> toggleFavorite(String productId, HomeCubit? homeCubit) async {
    final currentState = state;
    if (currentState is! ProductLoaded) return;

    final currentProduct = currentState.product;
    final newStatus = !currentProduct.isFavorite;

    // 1. Optimistic UI update
    emit(ProductLoaded(currentProduct.copyWith(isFavorite: newStatus)));
    homeCubit?.updateFavoriteStatus(productId, newStatus);

    try {
      // 2. Firestore in background
      await ProductRepository.toggleFavoriteStatus(
        productId: productId,
        currentStatus: currentProduct.isFavorite,
      );
    } catch (e) {
      // 3. Optional rollback if it failed
      emit(ProductLoaded(currentProduct));
      homeCubit?.updateFavoriteStatus(productId, currentProduct.isFavorite);
    }
  }

  void updateFavoriteStatus(String productId, bool newStatus) {
    final currentState = state;

    if (currentState is ProductLoaded && currentState.product.id == productId) {
      final updatedProduct = currentState.product.copyWith(
        isFavorite: newStatus,
      );
      emit(ProductLoaded(updatedProduct));
    }
  }

  void changeSize(String productId, Sizes newSize) {
    final currentState = state;

    if (currentState is ProductLoaded && currentState.product.id == productId) {
      final updatedProduct = currentState.product.copyWith(size: newSize);
      emit(ProductLoaded(updatedProduct));
    }
  }
}
