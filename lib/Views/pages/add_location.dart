import 'package:ecommerce/Models/location.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/services/checkout_service.dart';
import 'package:ecommerce/view_models/add_location_cubit/add_location_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final widthB = MediaQuery.of(context).size.width;
    final heightB = MediaQuery.of(context).size.height;
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
        padding: EdgeInsets.only(left: widthB * 0.04, right: widthB * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose Location",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              "Let's find your unforgettable event, Choose a location below to get started.",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(color: Colors.black45),
            ),
            Padding(
              padding: EdgeInsets.only(top: heightB * 0.03),
              child: Form(
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

                    // Split and trim both parts
                    List<String> parts = trimmedValue
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    if (parts.length != 2 ||
                        parts.any((part) => part.isEmpty)) {
                      return 'Please use the format: Country, City';
                    }

                    return null; // valid
                  },
                  keyboardType: TextInputType.text,
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
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: heightB * 0.02),
              child: Text(
                "Select Location",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<AddLocationCubit, AddLocationState>(
                buildWhen: (previous, current) =>
                    current is AddLocationSuccess ||
                    current is AddLocationLoading,
                builder: (context, state) {
                  if (state is AddLocationLoading) {
                    return Center(child: CircularProgressIndicator.adaptive());
                  } else if (state is AddLocationSuccess) {
                    final locations = state.locations;
                    return ListView.builder(
                      itemCount: locations.length,
                      itemBuilder: (BuildContext context, int index) {
                        final location = locations[index];

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: heightB * 0.01,
                          ),
                          child: InkWell(
                            onTap: () {
                              context.read<AddLocationCubit>().changeSelection(
                                location,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: location.isSelected
                                      ? primaryColor
                                      : Colors.grey,
                                  width: location.isSelected
                                      ? widthB * 0.01
                                      : 1,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(widthB * 0.02),
                                child: ListTile(
                                  title: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: heightB * 0.005,
                                    ),
                                    child: Text(
                                      location.country,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: heightB * 0.005,
                                    ),
                                    child: Text(
                                      "${location.country}, ${location.city}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(color: Colors.grey),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize
                                        .min, // prevents the row from taking all space
                                    children: [
                                      CircleAvatar(
                                        radius:
                                            widthB * 0.08, // restore image size
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
                                        onPressed: () {
                                          // Delete logic placeholder
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
                  } else {
                    final uid = FirebaseAuth.instance.currentUser!.uid;
                    return StreamBuilder<List<Location>>(
                      stream: CheckoutImpl().addressesStream(uid),
                      builder: (context, snapshot) {
                        final locations = snapshot.data ?? [];
                        return ListView.builder(
                          itemCount: locations.length,
                          itemBuilder: (BuildContext context, int index) {
                            final location = locations[index];

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: heightB * 0.01,
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (locations.length == 1 &&
                                      location.isSelected) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Can't unselect the only Location you have",
                                        ),
                                      ),
                                    );
                                  } else {
                                    context
                                        .read<AddLocationCubit>()
                                        .changeSelection(location);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: location.isSelected
                                          ? primaryColor
                                          : Colors.grey,
                                      width: location.isSelected
                                          ? widthB * 0.01
                                          : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(widthB * 0.02),
                                    child: ListTile(
                                      title: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: heightB * 0.005,
                                        ),
                                        child: Text(
                                          location.country,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: heightB * 0.005,
                                        ),
                                        child: Text(
                                          "${location.country}, ${location.city}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(color: Colors.grey),
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize
                                            .min, // prevents the row from taking all space
                                        children: [
                                          CircleAvatar(
                                            radius:
                                                widthB *
                                                0.08, // restore image size
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
                                                await CheckoutImpl()
                                                    .removeAddress(
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
                    );
                  }
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
              if (state is AddLocationSuccess) {
                Navigator.pop(context);
              }
            },
            buildWhen: (previous, current) =>
                current is AddLocationInitial ||
                current is AddLocationLoading ||
                current is AddLocationFailure,
            builder: (context, state) {
              if (state is AddLocationInitial) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(primaryColor),
                    fixedSize: WidgetStatePropertyAll(
                      Size(widthB * 0.9, heightB * 0.065),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      List<String> location = locationController.text.split(
                        ',',
                      );
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
              } else if (state is AddLocationLoading) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.grey),
                    fixedSize: WidgetStatePropertyAll(
                      Size(widthB * 0.9, heightB * 0.065),
                    ),
                  ),
                  onPressed: null,
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is AddLocationFailure) {
                return Text("Error: ${state.message}");
              } else {
                return Center(child: Text("something went wrong"));
              }
            },
          ),
        ),
      ),
    );
  }
}
