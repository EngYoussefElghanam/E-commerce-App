import 'package:ecommerce/Models/user_info.dart';
import 'package:ecommerce/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/services/auth_service.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _authService = AuthServicesImpl();

  @override
  Widget build(BuildContext context) {
    final widthB = MediaQuery.of(context).size.width;
    final heightB = MediaQuery.of(context).size.height;
    final userID = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<UserData?>(
        future: _authService.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No user data found"));
          }

          final userData = snapshot.data!;
          final nameController = TextEditingController(text: userData.name);
          final imgUrlController = TextEditingController(text: userData.imgUrl);

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: widthB * 0.05,
              vertical: heightB * 0.02,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: widthB * 0.18,
                    backgroundImage: NetworkImage(userData.imgUrl),
                  ),
                  SizedBox(height: heightB * 0.04),

                  // Name field
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Name cannot be empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: heightB * 0.025),
                  // Img URL field
                  TextFormField(
                    controller: imgUrlController,
                    decoration: InputDecoration(
                      labelText: "Profile Image URL",
                      prefixIcon: const Icon(Icons.link),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final urlRegex = RegExp(
                          r'^(http|https):\/\/[^\s$.?#].[^\s]*$',
                        );
                        if (!urlRegex.hasMatch(value)) {
                          return "Enter a valid URL";
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: heightB * 0.04),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: heightB * 0.065,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await FirestoreServices.upsertData(
                              collectionName: 'users',
                              docName: userID,
                              data: {
                                "name": nameController.text,
                                "imgUrl": imgUrlController.text,
                              },
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Profile updated successfully ✅"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error: $e"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
