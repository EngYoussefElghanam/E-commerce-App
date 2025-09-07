import 'package:ecommerce/Models/user_info.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/services/auth_service.dart';
import 'package:ecommerce/utils/app_routes.dart';
import 'package:ecommerce/view_models/auth_cubit/auth_cubit_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final heightB = MediaQuery.of(context).size.height;
    final widthB = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE5E5), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header Card
              FutureBuilder<UserData?>(
                future: AuthServicesImpl().getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Text("No user data found");
                  }

                  final userData = snapshot.data!;

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widthB * 0.05,
                      vertical: heightB * 0.025,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(widthB * 0.07),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.25),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(widthB * 0.05),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {}, // Future: go to profile edit page
                            child: CircleAvatar(
                              radius: heightB * 0.04,
                              backgroundImage: NetworkImage(userData.imgUrl),
                            ),
                          ),
                          SizedBox(width: widthB * 0.05),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData.name, // ✅ from Firestore
                                  style: Theme.of(context).textTheme.titleLarge!
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(height: heightB * 0.006),
                                Text(
                                  userData.email, // ✅ from Firestore
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: widthB * 0.037,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                rootNavigatorKey.currentState!.pushNamed(
                                  AppRoutes.editProfile,
                                ), // Go to edit settings
                            icon: Icon(
                              CupertinoIcons.pencil_circle_fill,
                              color: Colors.white,
                              size: widthB * 0.085,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // List Tiles
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: widthB * 0.05,
                    vertical: heightB * 0.01,
                  ),
                  children: [
                    _buildSectionHeader(context, "Account"),
                    _buildProfileTile(
                      context,
                      icon: CupertinoIcons.location_solid,
                      title: "My Addresses",
                      onTap: () {
                        rootNavigatorKey.currentState?.pushNamed(
                          AppRoutes.addressesPage,
                        );
                      },
                    ),
                    _buildProfileTile(
                      context,
                      icon: CupertinoIcons.cart_fill,
                      title: "My Orders",
                      onTap: () {},
                    ),
                    _buildProfileTile(
                      context,
                      icon: CupertinoIcons.creditcard,
                      title: "Payment Methods",
                      onTap: () => rootNavigatorKey.currentState?.pushNamed(
                        AppRoutes.paymentMethods,
                      ),
                    ),

                    _buildSectionHeader(context, "Rewards & Support"),
                    _buildProfileTile(
                      context,
                      icon: CupertinoIcons.tag_fill,
                      title: "Coupons & Offers",
                      onTap: () {},
                      trailingBadge: "3",
                    ),
                    _buildProfileTile(
                      context,
                      icon: CupertinoIcons.chat_bubble_2_fill,
                      title: "Help & Support",
                      onTap: () {},
                    ),

                    _buildSectionHeader(context, "Preferences"),
                    _buildProfileTile(
                      context,
                      icon: CupertinoIcons.settings_solid,
                      title: "Settings",
                      onTap: () {},
                    ),

                    BlocConsumer<AuthCubitCubit, AuthCubitState>(
                      bloc: BlocProvider.of<AuthCubitCubit>(context),
                      buildWhen: (previous, current) =>
                          current is AuthCubitLoggingOut ||
                          current is AuthCubitLoggedOut ||
                          current is AuthCubitLoggedOutFailure,
                      builder: (context, state) {
                        if (state is AuthCubitLoggingOut) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return _buildProfileTile(
                          context,
                          icon: CupertinoIcons.arrow_right_square_fill,
                          title: "Logout",
                          iconColor: Colors.redAccent,
                          gradientBackground: false,
                          onTap: () async {
                            await BlocProvider.of<AuthCubitCubit>(
                              context,
                            ).logout();
                          },
                        );
                      },
                      listener: (context, state) {
                        if (state is AuthCubitLoggedOut) {
                          rootNavigatorKey.currentState?.popAndPushNamed(
                            AppRoutes.login,
                          );
                        } else if (state is AuthCubitLoggedOutFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Failed to logout")),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final widthB = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
        left: widthB * 0.02,
        top: widthB * 0.05,
        bottom: widthB * 0.02,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: widthB * 0.04,
          fontWeight: FontWeight.w700,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildProfileTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    bool gradientBackground = false,
    String? trailingBadge,
  }) {
    final widthB = MediaQuery.of(context).size.width;
    final heightB = MediaQuery.of(context).size.height;

    return InkWell(
      borderRadius: BorderRadius.circular(widthB * 0.05),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: heightB * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widthB * 0.05),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: widthB * 0.05,
            vertical: heightB * 0.015,
          ),
          leading: Container(
            padding: EdgeInsets.all(widthB * 0.03),
            decoration: BoxDecoration(
              gradient: gradientBackground
                  ? LinearGradient(
                      colors: [Colors.redAccent, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: gradientBackground
                  ? null
                  : (iconColor ?? Colors.deepOrange).withOpacity(0.15),
              borderRadius: BorderRadius.circular(widthB * 0.04),
            ),
            child: Icon(
              icon,
              color: iconColor ?? Colors.deepOrange,
              size: widthB * 0.055,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: widthB * 0.044,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          trailing: trailingBadge != null
              ? Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: widthB * 0.03,
                    vertical: heightB * 0.005,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.redAccent, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(widthB * 0.05),
                  ),
                  child: Text(
                    trailingBadge,
                    style: TextStyle(
                      fontSize: widthB * 0.036,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Icon(
                  CupertinoIcons.chevron_forward,
                  size: widthB * 0.045,
                  color: Colors.grey[500],
                ),
        ),
      ),
    );
  }
}
