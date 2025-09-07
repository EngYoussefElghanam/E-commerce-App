import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce/Models/add_card_model.dart';
import 'package:ecommerce/Models/cart_item_model.dart';
import 'package:ecommerce/Models/location.dart';
import 'package:ecommerce/services/checkout_service.dart';
import 'package:ecommerce/services/firestore_service.dart';
import 'package:ecommerce/view_models/CartCubit/cart_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CartCubit cartCubit; // reference to real cart cubit
  StreamSubscription<List<cardDetailsModel>>? _paymentMethodsSub; // stream sub

  CheckoutCubit(this.cartCubit) : super(CheckoutInitial());

  void checkoutLoadData() {
    emit(CheckoutLoading());
    _fetchData();
    _listenToPaymentMethods(); // listen here
  }

  Future<void> buttonChecked(String cardID, bool value) async {
    if (state is CheckoutLoaded) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final currentState = state as CheckoutLoaded;
      final updatedList = await CheckoutImpl().fetchPaymentMethods(uid);

      if (updatedList.any((element) => element.checked)) {
        final indx = updatedList.indexWhere((element) => element.checked);
        updatedList[indx] = updatedList[indx].copyWith(checked: false);
      }

      updatedList[updatedList.indexWhere(
        (card) => card.id == cardID,
      )] = updatedList[updatedList.indexWhere((card) => card.id == cardID)]
          .copyWith(checked: value);

      for (int i = 0; i < updatedList.length; i++) {
        FirestoreServices.updateData(
          collectionName: 'users/$uid/PaymentMethods',
          docName: updatedList[i].id,
          data: updatedList[i].toMap(),
        );
      }

      emit(
        CheckoutLoaded(
          chosenPaymentMethod: updatedList,
          cartItems: currentState.cartItems,
          total: currentState.total,
          locationList: currentState.locationList,
        ),
      );
    }
  }

  Future<void> deleteCard(String cardID) async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    await CheckoutImpl().removePaymentMethod(cardID, userID);
    _listenToPaymentMethods();
  }

  Future<void> _fetchData() async {
    try {
      final updatedLocationList = await CheckoutImpl().fetchAddresses(
        FirebaseAuth.instance.currentUser!.uid,
      );
      final updatedList = await CheckoutImpl().fetchPaymentMethods(
        FirebaseAuth.instance.currentUser!.uid,
      );

      if (cartCubit.state is CartItems) {
        final cartState = cartCubit.state as CartItems;

        if (cartState.items.isEmpty) throw Exception("Cart is empty");

        final double total = (cartState.subTotal) + 3;

        if (updatedList.isNotEmpty) {
          emit(
            CheckoutLoaded(
              cartItems: cartState.items,
              total: total,
              chosenPaymentMethod: updatedList,
              locationList: updatedLocationList,
            ),
          );
        } else {
          emit(
            CheckoutLoaded(
              cartItems: cartState.items,
              total: total,
              locationList: updatedLocationList,
            ),
          );
        }
      } else {
        throw Exception("Cart is empty");
      }
    } catch (e) {
      emit(CheckoutError(message: e.toString()));
    }
  }

  void _listenToPaymentMethods() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _paymentMethodsSub?.cancel(); // cancel old listener if any
    _paymentMethodsSub = CheckoutImpl()
        .paymentMethodsStream(uid) // make sure you implement this stream
        .listen((updatedList) {
          if (state is CheckoutLoaded) {
            final currentState = state as CheckoutLoaded;
            emit(
              CheckoutLoaded(
                chosenPaymentMethod: updatedList,
                cartItems: currentState.cartItems,
                total: currentState.total,
                locationList: currentState.locationList,
              ),
            );
          }
        });
  }

  @override
  Future<void> close() {
    _paymentMethodsSub?.cancel();
    return super.close();
  }
}
