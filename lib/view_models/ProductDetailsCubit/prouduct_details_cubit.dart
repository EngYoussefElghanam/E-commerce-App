import 'package:bloc/bloc.dart';
import 'package:ecommerce/Models/product_item_model.dart';
import 'package:ecommerce/services/firestore_service.dart';
part 'prouduct_details_state.dart';

class ProuductDetailsCubit extends Cubit<ProuductDetailsState> {
  ProuductDetailsCubit() : super(ProuductDetailsInitial());
  Future<void> loadProductDetails(String productId) async {
    emit(ProuductDetailsLoading());

    try {
      final product = await FirestoreServices.getDocData(
        collectionName: "Products",
        docName: productId,
        fromMap: (data, docId) => ProductItemModel.fromMap(data, docId),
      );
      emit(ProuductDetailsLoaded(product!));
    } catch (e) {
      emit(ProuductDetailsError('Failed to load product details'));
    }
  }
}
