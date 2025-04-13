import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:user/authuntication/sing_up.dart';


import '../component/button.dart';
import '../component/text_field.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool hidingPassword = false;
  bool showError = false;

  double? imageWidth;
  double? imageHieght;

  void _loadImageWidth() {
    final image = Image.asset("assets/logo/logo.png");

    image.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool sync) {
      setState(() {
        imageWidth = info.image.width.toDouble();
        imageHieght = info.image.height.toDouble();
      });
    }));
  }

  @override
  void initState() {
    super.initState();
    _loadImageWidth();
  }

  void handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        showError = false;
      });
      String email = emailController.text;
      String password = passwordController.text;
      print("Email: $email");
      print("Password: $password");

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: Icon(Icons.check_circle, color: Colors.green, size: 40),
            title: Text("Login Successful"),
            content: Text("Email: $email\nPassword: $password"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              )
            ],
          );
        },
      );
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
                    decoration: BoxDecoration(
                      color: Color(0xFF064C4F),
                    ),
                  ),
                ),
                if (imageWidth != null)
                  Positioned(
                    top: ((hieght / 3 - 50) - imageHieght! / 2) / 2,
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
                  top: hieght / 3 - 50,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),
                              const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C1144),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 60),
                              if (showError)
                                const Text(
                                  "Wrong email/password",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        controller: emailController,
                                        hidingPassword: false,
                                        textStyleColor: Color(0xFF6C1144),
                                        labelText: "Email",
                                        labelStyleColor: Color(0xFF6C1144),
                                        hintText: "Enter your email",
                                        hintStyleColor: Color(0xFF6C1144),
                                        showError: showError,
                                        preIcon: Icons.email_outlined,
                                        preIconColor: Color(0xFF6C1144),
                                        sufIcon: null,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "You should fill the email";
                                          } else if (value !=
                                              "John@gmail.com") {
                                            setState(() {
                                              showError = true;
                                            });
                                            return "";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      CustomTextField(
                                        controller: passwordController,
                                        hidingPassword: hidingPassword,
                                        textStyleColor: Color(0xFF6C1144),
                                        labelText: "Password",
                                        labelStyleColor: Color(0xFF6C1144),
                                        hintText: "Enter your password",
                                        hintStyleColor: Color(0xFF6C1144),
                                        showError: showError,
                                        preIcon: Icons.password_outlined,
                                        preIconColor: Color(0xFF6C1144),
                                        sufIcon: Icons.remove_red_eye_outlined,
                                        sufIconColor: Color(0xFF6C1144),
                                        onPressed: () {
                                          setState(() {
                                            hidingPassword = !hidingPassword;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "You should fill the password";
                                          } else if (value.length <= 3) {
                                            return "The entered password is too short";
                                          } else if (value != "JohnJohn") {
                                            setState(() {
                                              showError = true;
                                            });
                                            return " ";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 3),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {
                                            // TODO: handle forget password
                                          },
                                          child: Text(
                                            "Forget Password?",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFFF7006),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      CustomButton(
                                        text: "Submit",
                                        height: 50,
                                        width: double.infinity,
                                        backgroundColor: Color(0xFF064C4F),
                                        fontColor: Colors.white,
                                        onTap: handleSubmit,
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
                                "Don't have an account? ",
                                style: TextStyle(color: Color(0xFF064C4F)),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SingUpPage(),
                                      ));
                                },
                                child: Text(
                                  "Sign up",
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
