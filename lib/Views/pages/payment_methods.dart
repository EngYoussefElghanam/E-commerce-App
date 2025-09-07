import 'package:ecommerce/Models/add_card_model.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/services/checkout_service.dart';
import 'package:ecommerce/utils/app_routes.dart';
import 'package:ecommerce/view_models/CheckouCubit/checkout_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final heightB = MediaQuery.of(context).size.height;
    final widthB = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            CupertinoIcons.xmark,
            color: darkTextColor, // was white, now themed dark
          ),
        ),
        title: Text(
          "My Payment Methods",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: darkTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade300, // subtle divider
            height: 1,
          ),
        ),
      ),

      body: StreamBuilder<List<cardDetailsModel>>(
        stream: CheckoutImpl().paymentMethodsStream(userID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final List<cardDetailsModel> paymentMethods = snapshot.data ?? [];

          if (paymentMethods.isNotEmpty) {
            return ListView.builder(
              padding: EdgeInsets.all(widthB * 0.05),
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                final card = paymentMethods[index];
                return Container(
                  margin: EdgeInsets.only(bottom: heightB * 0.02),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: widthB * 0.06,
                      vertical: heightB * 0.015,
                    ),
                    leading: Image.asset(
                      'assets/images/card.png',
                      width: widthB * 0.12,
                      fit: BoxFit.contain,
                    ),
                    title: Text(
                      card.cardHolderName,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "**** **** **** ${card.cardNumber.substring(14)}",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white70,
                        letterSpacing: 1.4,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        context.read<CheckoutCubit>().deleteCard(card.id);
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: widthB * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.credit_card_off_outlined,
                      size: widthB * 0.28,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "No Payment Methods",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: darkTextColor,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Looks like you have no Payment Method yet.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.addPaymentMethod,
                        ).then((_) {
                          context.read<CheckoutCubit>().checkoutLoadData();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Add Card",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),

      bottomNavigationBar: StreamBuilder<List<cardDetailsModel>>(
        stream: CheckoutImpl().paymentMethodsStream(userID),
        builder: (context, snapshot) {
          final List<cardDetailsModel> paymentMethods = snapshot.data ?? [];
          if (paymentMethods.isEmpty) return const SizedBox.shrink();

          return Padding(
            padding: EdgeInsets.all(widthB * 0.05),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.addPaymentMethod,
                ).then((_) => context.read<CheckoutCubit>().checkoutLoadData());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // changed from primaryColor
                padding: EdgeInsets.symmetric(vertical: heightB * 0.02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
              ),
              child: Text(
                "Add New Card",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
