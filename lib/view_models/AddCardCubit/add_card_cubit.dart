import 'package:bloc/bloc.dart';
import 'package:ecommerce/Models/add_card_model.dart';
import 'package:ecommerce/services/checkout_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'add_card_state.dart';

class AddCardCubit extends Cubit<AddCardState> {
  AddCardCubit() : super(AddCardInitial());
  Future<void> addCard(
    String cardNumber,
    String expiryDate,
    String cvv,
    String name,
    bool checked,
  ) async {
    emit(AddCardLoading());
    final cardList = await CheckoutImpl().fetchPaymentMethods(
      FirebaseAuth.instance.currentUser!.uid,
    );
    final cardDetailsModel newCard = cardDetailsModel(
      id: DateTime.now().toIso8601String(),
      cardNumber: cardNumber,
      cardHolderName: name,
      expiryDate: expiryDate,
      cvv: cvv,
      checked: cardList.isEmpty ? true : checked,
    );
    CheckoutImpl().addPaymentMethod(
      newCard,
      FirebaseAuth.instance.currentUser!.uid,
    );
    emit(AddCardSuccess());
  }
}
