import 'package:bloc/bloc.dart';
import 'package:ecommerce/Models/location.dart';
import 'package:ecommerce/services/checkout_service.dart';
import 'package:ecommerce/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'add_location_state.dart';

class AddLocationCubit extends Cubit<AddLocationState> {
  AddLocationCubit() : super(AddLocationInitial());

  Future<void> addLocation(String country, String city) async {
    emit(AddLocationLoading());
    try {
      final userID = FirebaseAuth.instance.currentUser!.uid;
      final locations = await CheckoutImpl().fetchAddresses(userID);

      Location location = Location(
        country: country,
        city: city,
        id: DateTime.now().toIso8601String(),
        isSelected: true,
      );

      // Deselect previous selection if exists
      if (locations.any((element) => element.isSelected)) {
        final indexslct = locations.indexWhere((element) => element.isSelected);
        locations[indexslct] = locations[indexslct].copyWith(isSelected: false);
      }

      locations.add(location);

      for (int i = 0; i < locations.length; i++) {
        await FirestoreServices.upsertData(
          collectionName: 'users/$userID/Addresses',
          docName: locations[i].id,
          data: locations[i].toMap(),
        );
      }

      if (isClosed) return; // ✅ prevent emit after close
      emit(
        AddLocationSuccess(
          location: location,
          locations: locations,
          message: "location_added",
        ),
      );
    } catch (e) {
      if (isClosed) return; // ✅ prevent emit after close
      emit(AddLocationFailure(message: e.toString()));
    }
  }

  Future<void> changeSelection(Location location) async {
    try {
      final userID = FirebaseAuth.instance.currentUser!.uid;
      final locations = await CheckoutImpl().fetchAddresses(userID);

      // Deselect current
      if (locations.any((element) => element.isSelected)) {
        final wantedIndex = locations.indexWhere(
          (element) => element.isSelected,
        );
        locations[wantedIndex] = locations[wantedIndex].copyWith(
          isSelected: false,
        );
      }

      // Select new one
      final index = locations.indexWhere(
        (element) => element.id == location.id,
      );
      final value = location.isSelected;
      location = location.copyWith(isSelected: !value);
      locations[index] = location;

      for (int i = 0; i < locations.length; i++) {
        await FirestoreServices.updateData(
          collectionName: 'users/$userID/Addresses',
          docName: locations[i].id,
          data: locations[i].toMap(),
        );
      }

      if (isClosed) return; // ✅ prevent emit after close
      emit(
        AddLocationSuccess(
          location: location,
          locations: locations,
          message: 'selection-changed',
        ),
      );
    } catch (e) {
      if (isClosed) return; // ✅ prevent emit after close
      emit(AddLocationFailure(message: e.toString()));
    }
  }
}
