import 'package:ecommerce/services/firestore_service.dart';
import 'package:ecommerce/services/home_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductRepository {
  static Future<bool> toggleFavoriteStatus({
    required String productId,
    required bool currentStatus,
  }) async {
    if (currentStatus) {
      // currently favorite → remove it
      await HomeImpl().removefavoriteProduct(productId);
      return false;
    } else {
      // not favorite → add it
      await HomeImpl().addFavoriteProduct(productId);
      return true;
    }
  }

  static Future<bool> isProductFavorited(String productId) async {
    final doc = await FirestoreServices.getDocData(
      collectionName:
          "users/${FirebaseAuth.instance.currentUser?.uid}/Favorited",
      docName: productId,
      fromMap: (data, id) => true, // if doc exists → favorited
    );
    return doc != null;
  }
}
