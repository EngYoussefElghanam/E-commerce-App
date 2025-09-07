import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce/Models/catgory_item_model.dart';
import 'package:ecommerce/services/firestore_service.dart';
import 'package:equatable/equatable.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {

  CategoriesCubit() : super(CategoriesInitial());

  Future<void> fetchCategories() async {
    emit(CategoriesLoading());
    try {
      final categories = await FirestoreServices.getData(
        collectionName: "Categories",
        fromMap: (data, docId) => CategoryItemModel.fromMap(data),
      );
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }
}
