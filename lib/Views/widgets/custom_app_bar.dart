import 'package:ecommerce/Models/user_info.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/services/auth_service.dart';
import 'package:ecommerce/utils/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final widthB = MediaQuery.of(context).size.width;
    final heightB = MediaQuery.of(context).size.height;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black54, blurRadius: widthB * 0.02),
        ],
      ),
      child: SafeArea(
        child: FutureBuilder<UserData?>(
          future: AuthServicesImpl().getUserData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                height: heightB * 0.1,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final user = snapshot.data!;

            return SizedBox(
              height: heightB * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widthB * 0.03,
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.imgUrl),

                          radius: widthB * 0.075,
                        ),
                      ),
                      SizedBox(width: widthB * 0.004),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, ${user.name}",
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Let's go shopping!",
                            style: Theme.of(context).textTheme.labelMedium!
                                .copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(CupertinoIcons.search, size: widthB * 0.07),
                      ),
                      IconButton(
                        onPressed: () => rootNavigatorKey.currentState
                            ?.pushNamed(AppRoutes.notificationPage),
                        icon: Icon(CupertinoIcons.bell, size: widthB * 0.07),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
