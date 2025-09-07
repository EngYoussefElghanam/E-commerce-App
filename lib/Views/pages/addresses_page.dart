// Import section remains unchanged
import 'package:ecommerce/Models/location.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/services/checkout_service.dart';
import 'package:ecommerce/view_models/add_location_cubit/add_location_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  final locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final widthB = MediaQuery.of(context).size.width;
    final heightB = MediaQuery.of(context).size.height;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Location', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(CupertinoIcons.chevron_back),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: widthB * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: heightB * 0.03),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: locationController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a location';
                  }
                  String trimmedValue = value.trim();
                  int commaCount = trimmedValue.split(',').length - 1;
                  if (commaCount != 1) {
                    return 'Please use the format: Country, City';
                  }
                  List<String> parts = trimmedValue
                      .split(',')
                      .map((e) => e.trim())
                      .toList();
                  if (parts.length != 2 || parts.any((part) => part.isEmpty)) {
                    return 'Please use the format: Country, City';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "France, Paris",
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    color: Colors.black45,
                    size: 34,
                  ),
                  suffixIcon: Icon(CupertinoIcons.location_circle, size: 34),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: heightB * 0.02),
            Text(
              "Select Location",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w700),
            ),
            Expanded(
              child: StreamBuilder<List<Location>>(
                stream: CheckoutImpl().addressesStream(uid),
                builder: (context, snapshot) {
                  final locations = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: locations.length,
                    itemBuilder: (BuildContext context, int index) {
                      final location = locations[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: heightB * 0.01),
                        child: InkWell(
                          onTap: () {
                            if (locations.length == 1 && location.isSelected) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Can't unselect the only Location you have",
                                  ),
                                ),
                              );
                            } else {
                              context.read<AddLocationCubit>().changeSelection(
                                location,
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: location.isSelected
                                    ? primaryColor
                                    : Colors.grey,
                                width: location.isSelected ? widthB * 0.01 : 1,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(widthB * 0.02),
                              child: ListTile(
                                title: Text(
                                  location.country,
                                  style: Theme.of(context).textTheme.titleLarge!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  "${location.country}, ${location.city}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: Colors.grey),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: widthB * 0.08,
                                      backgroundColor: Colors.transparent,
                                      child: Image.asset(
                                        location.imageURL,
                                        fit: BoxFit.cover,
                                        width: widthB * 0.16,
                                        height: heightB * 0.08,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        if (location.isSelected) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Can't delete selected Location",
                                              ),
                                            ),
                                          );
                                        } else {
                                          await CheckoutImpl().removeAddress(
                                            location.id,
                                            uid,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widthB * 0.03),
          child: BlocConsumer<AddLocationCubit, AddLocationState>(
            listenWhen: (previous, current) => current is AddLocationSuccess,
            listener: (context, state) {
              // Only show snackbar if state was triggered by adding location
              if (state is AddLocationSuccess &&
                  state.message == "location_added") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Location Added Successfully")),
                );
              }
            },
            buildWhen: (previous, current) =>
                current is AddLocationInitial ||
                current is AddLocationLoading ||
                current is AddLocationSuccess ||
                current is AddLocationFailure,
            builder: (context, state) {
              if (state is AddLocationLoading) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    fixedSize: Size(widthB * 0.9, heightB * 0.065),
                  ),
                  onPressed: null,
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  fixedSize: Size(widthB * 0.9, heightB * 0.065),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    List<String> location = locationController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    context.read<AddLocationCubit>().addLocation(
                      location[0],
                      location[1],
                    );
                  }
                },
                child: Text(
                  "Add Location",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
