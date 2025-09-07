import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce/Models/cart_item_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  StreamSubscription? _cartSub;

  CartCubit() : super(CartInitial());

  void startCartStream() {
    emit(CartLoading());

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      emit(CartError("User not logged in"));
      return;
    }

    _cartSub?.cancel();
    _cartSub = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("cart")
        .snapshots()
        .listen(
          (snapshot) {
            final items = snapshot.docs
                .map(
                  (doc) =>
                      CartItemModel.fromMap(doc.data()).copyWith(id: doc.id),
                )
                .toList();

            final subtotal = _calculateSubtotal(items);
            emit(CartItems(items: items, subTotal: subtotal));
          },
          onError: (e) {
            emit(CartError("Failed to load cart: $e"));
          },
        );
  }

  Future<void> addToCart(CartItemModel item) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final cartRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("cart");

    // Always add a new doc (Firestore generates unique ID)
    await cartRef.add(item.toMap());
  }

  Future<void> updateItemQuantity(String itemId, int newQuantity) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("cart")
        .doc(itemId);

    await docRef.update({"quantity": newQuantity});
  }

  Future<void> clearCart() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final cartRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("cart");

    final snapshot = await cartRef.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> removeFromCart(CartItemModel item) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("cart")
        .doc(item.id)
        .delete();
  }

  double _calculateSubtotal(List<CartItemModel> items) {
    return items.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  @override
  Future<void> close() {
    _cartSub?.cancel();
    return super.close();
  }
}
