import 'package:ecommerce/Models/product_item_model.dart';
import 'package:ecommerce/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class HomeService {
  Future<List<ProductItemModel>> fetchProducts();
  Future<void> addFavoriteProduct(String productId);
  Future<void> removefavoriteProduct(String productId);
}

class HomeImpl implements HomeService {
  @override
  Future<List<ProductItemModel>> fetchProducts() async {
    final result = await FirestoreServices.getData<ProductItemModel>(
      collectionName: 'Products',
      fromMap: (data, documentId) => ProductItemModel.fromMap(data, documentId),
    );
    return result;
  }

  @override
  Future<void> addFavoriteProduct(String productId) async {
    final product = await FirestoreServices.getDocData(
      docName: productId,
      collectionName: 'Products',
      fromMap: (data, docId) => ProductItemModel.fromMap(data, docId),
    );

    await FirestoreServices.createCollectionWithDoc(
      // 👈 use setData with docId instead of addData
      collectionName:
          'users/${FirebaseAuth.instance.currentUser?.uid}/Favorited',
      docName: productId, // 👈 use productId as key
      data: product!.toMap(),
    );
  }

  @override
  Future<void> removefavoriteProduct(String productId) async {
    await FirestoreServices.deleteData(
      collectionName:
          'users/${FirebaseAuth.instance.currentUser?.uid}/Favorited',
      documentId: productId,
    );
  }
}
