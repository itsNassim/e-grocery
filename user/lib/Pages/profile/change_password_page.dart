import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:user/Backgrounds/background_2.dart';
import 'package:user/backend/auth/auth.dart';
import 'package:user/backend/user/user.dart';
import 'package:user/component/text_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool hideOldPassword = true;
  bool hideNewPassword = true;
  bool hideConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();

  void handleChangePassword() async {
    var box = Hive.box("mybox");
    final accessToken = await refreshAccessToken(box.get("token")["refresh"]);

    final success = await changeUserPassword(
      accessToken: accessToken,
      currentPassword: oldPasswordController.text.trim(),
      newPassword: newPasswordController.text.trim(),
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password updated successfully.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update password.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final toppadding = MediaQuery.of(context).padding.top;
    final bottompadding = MediaQuery.of(context).padding.bottom;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SizedBox(
          height: height - toppadding - bottompadding,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: height * 0.3),
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: oldPasswordController,
                            hidingPassword: hideOldPassword,
                            textStyleColor: const Color(0xFF6C1144),
                            labelText: "Old Password",
                            labelStyleColor: const Color(0xFF6C1144),
                            hintText: "Enter your old password",
                            hintStyleColor: const Color(0xFF6C1144),
                            showError: false,
                            preIcon: Icons.lock_outline,
                            preIconColor: const Color(0xFF6C1144),
                            sufIcon: hideOldPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            sufIconColor: const Color(0xFF6C1144),
                            onPressed: () {
                              setState(() {
                                hideOldPassword = !hideOldPassword;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your old password";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: newPasswordController,
                            hidingPassword: hideNewPassword,
                            textStyleColor: const Color(0xFF6C1144),
                            labelText: "New Password",
                            labelStyleColor: const Color(0xFF6C1144),
                            hintText: "Enter your new password",
                            hintStyleColor: const Color(0xFF6C1144),
                            showError: false,
                            preIcon: Icons.lock_outline,
                            preIconColor: const Color(0xFF6C1144),
                            sufIcon: hideNewPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            sufIconColor: const Color(0xFF6C1144),
                            onPressed: () {
                              setState(() {
                                hideNewPassword = !hideNewPassword;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your new password";
                              } else if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: confirmPasswordController,
                            hidingPassword: hideConfirmPassword,
                            textStyleColor: const Color(0xFF6C1144),
                            labelText: "Confirm Password",
                            labelStyleColor: const Color(0xFF6C1144),
                            hintText: "Re-enter your new password",
                            hintStyleColor: const Color(0xFF6C1144),
                            showError: false,
                            preIcon: Icons.lock_outline,
                            preIconColor: const Color(0xFF6C1144),
                            sufIcon: hideConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            sufIconColor: const Color(0xFF6C1144),
                            onPressed: () {
                              setState(() {
                                hideConfirmPassword = !hideConfirmPassword;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please confirm your new password";
                              } else if (value != newPasswordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  handleChangePassword();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6C1144),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: const Text(
                                "Change Password",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.15,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SecondBackGround(ScreenHeight: height),
                    ),
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 80),
                            const Text(
                              "Change Password",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
