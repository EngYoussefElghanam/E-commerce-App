import 'package:ecommerce/Models/add_card_model.dart';
import 'package:ecommerce/Models/location.dart';
import 'package:ecommerce/services/firestore_service.dart';

abstract class CheckoutService {
  Future<void> addPaymentMethod(cardDetailsModel card, String userId);
  Future<List<cardDetailsModel>> fetchPaymentMethods(String userID);
  Stream<List<cardDetailsModel>> paymentMethodsStream(String userID);
  Future<void> removePaymentMethod(String cardID, String userID);
  Future<void> addLocationAddress(Location location, String userID);
  Future<List<Location>> fetchAddresses(String userID);
  Stream<List<Location>> addressesStream(String userID);
  Future<void> removeAddress(String locationID, String userID);
}

final class CheckoutImpl implements CheckoutService {
  @override
  Future<void> addPaymentMethod(cardDetailsModel card, String userId) async {
    await FirestoreServices.addData(
      collectionName: 'users/$userId/PaymentMethods',
      id: card.id,
      data: card.toMap(),
    );
  }

  @override
  Future<List<cardDetailsModel>> fetchPaymentMethods(String userID) async {
    final methods = await FirestoreServices.getData(
      collectionName: 'users/$userID/PaymentMethods',
      fromMap: (data, docID) => cardDetailsModel.fromMap(data),
    );
    return methods;
  }

  @override
  Stream<List<cardDetailsModel>> paymentMethodsStream(String userID) {
    return FirestoreServices.streamData(
      collectionName: 'users/$userID/PaymentMethods',
      fromMap: (data, docID) => cardDetailsModel.fromMap(data),
    );
  }

  @override
  Future<void> removePaymentMethod(String cardID, String userID) async {
    await FirestoreServices.deleteData(
      collectionName: 'users/$userID/PaymentMethods',
      documentId: cardID,
    );
  }

  @override
  Future<void> addLocationAddress(Location location, String userID) async {
    await FirestoreServices.addData(
      collectionName: 'users/$userID/Addresses',
      id: location.id,
      data: location.toMap(),
    );
  }

  @override
  Stream<List<Location>> addressesStream(String userID) {
    return FirestoreServices.streamData(
      collectionName: 'users/$userID/Addresses',
      fromMap: (data, docID) => Location.fromMap(data),
    );
  }

  @override
  Future<List<Location>> fetchAddresses(String userID) async {
    return await FirestoreServices.getData(
      collectionName: 'users/$userID/Addresses',
      fromMap: (data, docID) => Location.fromMap(data),
    );
  }

  @override
  Future<void> removeAddress(String locationID, String userID) async {
    await FirestoreServices.deleteData(
      collectionName: 'users/$userID/Addresses',
      documentId: locationID,
    );
  }
}
