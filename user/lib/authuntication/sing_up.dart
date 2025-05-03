import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:user/authuntication/log_in.dart';
import 'package:user/backend/auth/auth.dart';

import '../component/button.dart';
import '../component/text_field.dart';

class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phonenumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confairmepasswordController =
      TextEditingController();

  double? imageWidth;
  double? imageHieght;

  void _loadImageWidth() {
    final image = Image.asset("assets/logo/logo.png");

    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool sync) {
        setState(() {
          imageWidth = info.image.width.toDouble();
          imageHieght = info.image.height.toDouble();
        });
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadImageWidth();
  }

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String fullname = fullnameController.text.trim();
      String phonenumber = phonenumberController.text.trim();
      String password = passwordController.text.trim();

      bool token = await signup(
        email,
        fullname,
        phonenumber,
        password,
      );

      if (token) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LogInPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hieght = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: hieght - topPadding - bottomPadding,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: hieght,
                    width: width,
                    decoration: BoxDecoration(color: Color(0xFF064C4F)),
                  ),
                ),
                if (imageWidth != null)
                  Positioned(
                    top: ((hieght / 5 - 50) - imageHieght! / 3) / 2 + 5,
                    left: (width - imageWidth! / 2) / 2,
                    child: ClipRRect(
                      child: Image.asset(
                        "assets/logo/logo.png",
                        width: imageWidth! / 2,
                        height: imageHieght! / 2,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Positioned(
                  top: hieght / 5,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(100),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              const Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C1144),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 40),
                              Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        controller: fullnameController,
                                        hidingPassword: false,
                                        textStyleColor: Color(0xFF6C1144),
                                        labelText: "Full Name",
                                        labelStyleColor: Color(0xFF6C1144),
                                        hintText: "Enter your full name",
                                        hintStyleColor: Color(0xFF6C1144),
                                        showError: false,
                                        preIcon: Icons.face,
                                        preIconColor: Color(0xFF6C1144),
                                        sufIcon: null,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "You should fill the full name";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      CustomTextField(
                                        controller: emailController,
                                        hidingPassword: false,
                                        textStyleColor: Color(0xFF6C1144),
                                        labelText: "Email",
                                        labelStyleColor: Color(0xFF6C1144),
                                        hintText: "Enter your email",
                                        hintStyleColor: Color(0xFF6C1144),
                                        showError: false,
                                        preIcon: Icons.email_outlined,
                                        preIconColor: Color(0xFF6C1144),
                                        sufIcon: null,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "Please enter your email";
                                          } else if (!RegExp(
                                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                              .hasMatch(value)) {
                                            return "Please enter a valid email";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      CustomTextField(
                                        controller: phonenumberController,
                                        hidingPassword: false,
                                        textStyleColor: Color(0xFF6C1144),
                                        labelText: "Phone Number",
                                        labelStyleColor: Color(0xFF6C1144),
                                        hintText: "Enter your phone number",
                                        hintStyleColor: Color(0xFF6C1144),
                                        showError: false,
                                        preIcon: Icons.phone_android_outlined,
                                        preIconColor: Color(0xFF6C1144),
                                        sufIcon: null,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "You should fill the phone number";
                                          } else if (!RegExp(r'^\d{7,15}$')
                                              .hasMatch(value.trim())) {
                                            return "Please enter a valid phone number";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      CustomTextField(
                                        controller: passwordController,
                                        hidingPassword: false,
                                        textStyleColor: Color(0xFF6C1144),
                                        labelText: "Password",
                                        labelStyleColor: Color(0xFF6C1144),
                                        hintText: "Enter your Password",
                                        hintStyleColor: Color(0xFF6C1144),
                                        showError: false,
                                        preIcon: Icons.password_outlined,
                                        preIconColor: Color(0xFF6C1144),
                                        sufIcon: null,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "Please enter your password";
                                          } else if (value.length < 6) {
                                            return "Password is too short (min 6 characters)";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      CustomTextField(
                                        controller: confairmepasswordController,
                                        hidingPassword: true,
                                        textStyleColor: Color(0xFF6C1144),
                                        labelText: "Confirm Password",
                                        labelStyleColor: Color(0xFF6C1144),
                                        hintText: "rewrite your password",
                                        hintStyleColor: Color(0xFF6C1144),
                                        showError: false,
                                        preIcon: Icons.password_outlined,
                                        preIconColor: Color(0xFF6C1144),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "Please confirm your password";
                                          } else if (value !=
                                              passwordController.text) {
                                            return "The passwords do not match";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 50),
                                      CustomButton(
                                        text: "Sing Up",
                                        height: 50,
                                        width: double.infinity,
                                        backgroundColor: Color(0xFF064C4F),
                                        fontColor: Colors.white,
                                        onTap: () {
                                          handleSubmit();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(color: Color(0xFF064C4F)),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LogInPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF7006),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
