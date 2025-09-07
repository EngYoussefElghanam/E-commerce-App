// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:ecommerce/Models/product_item_model.dart';
// import 'package:ecommerce/services/firestore_service.dart';
// import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// part 'wishlist_state.dart';

// class WishlistCubit extends Cubit<WishlistState> {
//   StreamSubscription? _subscription;

//   WishlistCubit() : super(WishlistInitial());

//   /// Start listening to wishlist updates in Firestore
//   void startWishlistStream() {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) {
//       emit(WishlistError("User not logged in"));
//       return;
//     }

//     emit(WishlistLoading());

//     _subscription =
//         FirestoreServices.streamData<ProductItemModel>(
//           collectionName: 'users/$userId/Favorited',
//           fromMap: (data, docId) => ProductItemModel.fromMap(data, docId),
//         ).listen(
//           (favorites) {
//             emit(WishlistLoaded(favorites));
//           },
//           onError: (error) {
//             emit(WishlistError(error.toString()));
//           },
//         );
//   }

//   /// Stop listening when cubit is closed
//   @override
//   Future<void> close() {
//     _subscription?.cancel();
//     return super.close();
//   }
// }
