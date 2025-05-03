import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:user/Backgrounds/background_2.dart';
import 'package:user/backend/auth/auth.dart';
import 'package:user/backend/user/user.dart';
import 'package:user/classes/user_class.dart';
import 'package:user/component/text_field.dart';

class PersonalInfoPage extends StatefulWidget {
  final User user;
  PersonalInfoPage({
    super.key,
    required this.user,
  });

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  late TextEditingController fullnameController;
  late TextEditingController emailController;
  late TextEditingController phonenumberController;
  final _formKey = GlobalKey<FormState>();
  var box = Hive.box("mybox");

  late String selectedGender;

  @override
  void initState() {
    super.initState();
    fullnameController = TextEditingController(text: widget.user.fullName);
    emailController = TextEditingController(text: widget.user.email);
    phonenumberController =
        TextEditingController(text: widget.user.phoneNumber);
    selectedGender = box.get("gender") ?? 'assets/icons/male_avatar.png';
  }

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    phonenumberController.dispose();
    super.dispose();
  }

  _handelSubmit() async {
    if (_formKey.currentState!.validate()) {
      final tokenMap = box.get("token");
      final refreshToken = tokenMap?["refresh"];

      final accessToken = await refreshAccessToken(refreshToken);

      final data = await updateUserInfo(accessToken, fullnameController.text,
          emailController.text, phonenumberController.text);
      if (data != null) {
        box.put("gender", selectedGender);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Personal Info Saved!'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final toppadding = MediaQuery.of(context).padding.top;
    final bottompadding = MediaQuery.of(context).padding.bottom;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        resizeToAvoidBottomInset: true,
        body: SizedBox(
          height: height - toppadding - bottompadding,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: height * 0.15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildRadioImage('assets/icons/male_avatar.png'),
                            const SizedBox(width: 20),
                            _buildRadioImage('assets/icons/female_avatar.png'),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Form(
                          key: _formKey,
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
                                  if (value == null || value.trim().isEmpty) {
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
                                  if (value!.isEmpty) {
                                    return "You should fill the phone number";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6C1144),
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            _handelSubmit();
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
                            SizedBox(width: 90),
                            const Text(
                              "Personal Info",
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

  Widget _buildRadioImage(String imagePath) {
    final isSelected = selectedGender == imagePath;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = imagePath;
        });
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Color(0xFF6C1144) : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  imagePath,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Radio<String>(
            value: imagePath,
            groupValue: selectedGender,
            onChanged: (val) {
              setState(() {
                selectedGender = val!;
              });
            },
          ),
        ],
      ),
    );
  }
}
