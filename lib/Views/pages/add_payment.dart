import 'package:ecommerce/Views/widgets/text_field_widget.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/view_models/AddCardCubit/add_card_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({super.key});

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthB = MediaQuery.of(context).size.width;
    final heightB = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: darkTextColor,
        title: const Text('Add Card'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(widthB * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        validator: (value) {
                          return value == null || value.isEmpty
                              ? 'Please enter your Card Number'
                              : value.length != 19
                              ? 'Invalid Card Number'
                              : null;
                        },

                        controller: cardNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CardInputFormatters(),
                        ],
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(widthB * 0.05),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          prefixIcon: Icon(
                            CupertinoIcons.text_alignleft,
                            color: Colors.grey.shade700,
                          ),
                          hintText: "Enter Card Number",
                          hintStyle: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w300,
                              ),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(widthB * 0.05),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: heightB * 0.03),
                      TextFieldWidget(
                        name: "Card Holder Name",
                        hintText: "Enter Name On Card",
                        prefixIcon: CupertinoIcons.person,
                        controller: nameController,
                        formatter: FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z ]'),
                        ),
                      ),
                      SizedBox(height: heightB * 0.03),
                      TextFieldWidget(
                        name: "Expiry Date",
                        hintText: "MM/YY",
                        prefixIcon: CupertinoIcons.calendar,
                        controller: expiryDateController,
                        formatter: ExpiryDateFormatter(),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: heightB * 0.03),
                      TextFieldWidget(
                        name: "CVV",
                        hintText: "Enter CVV",
                        prefixIcon: CupertinoIcons.lock,
                        controller: cvvController,
                        keyboardType: TextInputType.number,
                        formatter: CVVFormatter(),
                        info:
                            "You will find CVV on the back of your card after the hidden signature usually",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widthB * 0.05),
          child: BlocConsumer<AddCardCubit, AddCardState>(
            bloc: BlocProvider.of<AddCardCubit>(context),
            buildWhen: (previous, current) =>
                current is AddCardInitial ||
                current is AddCardLoading ||
                current is AddCardSuccess ||
                current is AddCardFailure,
            listenWhen: (previous, current) =>
                current is AddCardSuccess || current is AddCardFailure,
            listener: (context, state) {
              if (state is AddCardSuccess) {
                Navigator.pop(context);
              } else if (state is AddCardFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              if (state is AddCardInitial) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(primaryColor),
                    fixedSize: WidgetStatePropertyAll(
                      Size(widthB * 0.9, heightB * 0.065),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AddCardCubit>().addCard(
                        cardNumberController.text,
                        expiryDateController.text,
                        cvvController.text,
                        nameController.text,
                        false,
                      );
                    }
                  },
                  child: Text(
                    "Add Card",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              } else if (state is AddCardLoading) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.grey.shade500,
                    ),
                    fixedSize: WidgetStatePropertyAll(
                      Size(widthB * 0.9, heightB * 0.065),
                    ),
                  ),
                  onPressed: null,
                  child: CircularProgressIndicator.adaptive(),
                );
              } else {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.grey.shade500,
                    ),
                    fixedSize: WidgetStatePropertyAll(
                      Size(widthB * 0.9, heightB * 0.065),
                    ),
                  ),
                  onPressed: null,
                  child: Text("Error"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class CardInputFormatters extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(" ", "");
    StringBuffer newString = StringBuffer();
    if (digitsOnly.length > 16) {
      digitsOnly = digitsOnly.substring(0, 16);
    }
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && i % 4 == 0 && i != digitsOnly.length - 1) {
        newString.write(" ");
      }
      newString.write(digitsOnly[i]);
    }
    return TextEditingValue(
      text: newString.toString(),
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final original = newValue.text;

    // Keep only digits
    String digitsOnly = original.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length > 4) {
      digitsOnly = digitsOnly.substring(0, 4);
    }

    // Clamp month (if two digits available)
    if (digitsOnly.length >= 2) {
      final monthText = digitsOnly.substring(0, 2);
      int month = int.tryParse(monthText) ?? 0;
      if (month < 1) {
        month = 1;
      } else if (month > 12) {
        month = 12;
      }
      // Replace the month digits with the clamped value (preserve rest)
      final rest = digitsOnly.length > 2 ? digitsOnly.substring(2) : '';
      final monthStr = month.toString().padLeft(2, '0');
      digitsOnly = monthStr + rest;
    }

    // Build formatted string with slash after MM
    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digitsOnly[i]);
    }
    final formatted = buffer.toString();

    // Preserve caret position:
    // Count digits before the newValue selection offset in the original (unformatted) text
    int baseOffset = newValue.selection.baseOffset;
    if (baseOffset < 0) baseOffset = 0;
    if (baseOffset > original.length) baseOffset = original.length;

    int digitsBefore = 0;
    for (int i = 0; i < baseOffset; i++) {
      if (RegExp(r'\d').hasMatch(original[i])) digitsBefore++;
    }

    // Map digitsBefore to the formatted index (add 1 if past the slash)
    int newSelection = digitsBefore;
    if (digitsBefore >= 2) newSelection += 1; // account for the inserted '/'

    // Clamp selection to formatted length
    if (newSelection > formatted.length) newSelection = formatted.length;
    if (newSelection < 0) newSelection = 0;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newSelection),
    );
  }
}

class CVVFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Keep only digits
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Limit to 3 digits
    if (digitsOnly.length > 3) {
      digitsOnly = digitsOnly.substring(0, 3);
    }

    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}
