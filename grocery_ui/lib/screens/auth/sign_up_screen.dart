import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _shopAddressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;
  String? _errorMessage;
  int _currentStep = 0;

  // Green theme colors
  final Color primaryGreen = const Color(0xFF2E7D32);
  final Color lightGreen = const Color(0xFF4CAF50);
  final Color darkGreen = const Color(0xFF1B5E20);
  final Color accentGreen = const Color(0xFF8BC34A);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _shopNameController.dispose();
    _shopAddressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      setState(() {
        _errorMessage = 'You must agree to the Terms and Conditions';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signUp(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        shopName: _shopNameController.text,
        shopAddress: _shopAddressController.text,
        password: _passwordController.text,
      );

      if (success) {
        // Show success dialog and navigate to sign in
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: lightGreen),
                const SizedBox(width: 10),
                const Text('Registration Successful'),
              ],
            ),
            content: const Text(
              'Your account has been created successfully. You can now sign in with your credentials.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pushReplacementNamed(
                    SignInScreen.routeName,
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: primaryGreen,
                ),
                child: const Text('Sign In'),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to create account. Please try again.';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _nextStep() {
    bool isValid = false;
    
    if (_currentStep == 0) {
      // Validate personal info
      isValid = _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _emailController.text.contains('@') &&
          _phoneController.text.isNotEmpty;
    } else if (_currentStep == 1) {
      // Validate shop info
      isValid = _shopNameController.text.isNotEmpty &&
          _shopAddressController.text.isNotEmpty;
    }
    
    if (isValid) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all required fields correctly'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _previousStep() {
    setState(() {
      _currentStep -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: size.width > 800 ? 600 : size.width * 0.9,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0A1F0A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
                color: accentGreen.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
  width: 100,
  height: 100,
  padding: const EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: primaryGreen.withOpacity(0.1),
    shape: BoxShape.circle,
  ),
  child: ClipOval(
    child: Image.asset(
      'assets/images/app_logo.png',
      fit: BoxFit.contain,
    ),
  ),
),
                // Title
                Text(
                  'Create Shopkeeper Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : darkGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Join our platform to manage your grocery store',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                // Error Message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_errorMessage != null) const SizedBox(height: 24),
                // Stepper Indicator
                Row(
                  children: [
                    _buildStepIndicator(0, 'Personal Info'),
                    _buildStepConnector(0),
                    _buildStepIndicator(1, 'Shop Info'),
                    _buildStepConnector(1),
                    _buildStepIndicator(2, 'Security'),
                  ],
                ),
                const SizedBox(height: 32),
                // Form
                Form(
                  key: _formKey,
                  child: [
                    _buildPersonalInfoStep(isDarkMode),
                    _buildShopInfoStep(isDarkMode),
                    _buildSecurityStep(isDarkMode),
                  ][_currentStep],
                ),
                const SizedBox(height: 24),
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentStep > 0)
                      OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: primaryGreen),
                        ),
                        child: Text(
                          'Previous',
                          style: TextStyle(color: primaryGreen),
                        ),
                      )
                    else
                      const SizedBox(),
                    if (_currentStep < 2)
                      ElevatedButton(
                        onPressed: _nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Next'),
                      )
                    else
                      ElevatedButton(
                        onPressed: _isLoading ? null : _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Create Account'),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                          SignInScreen.routeName,
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: primaryGreen,
                      ),
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep == step;
    final isCompleted = _currentStep > step;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive
                  ? primaryGreen
                  : isCompleted
                      ? lightGreen
                      : isDarkMode
                          ? const Color(0xFF0A1F0A)
                          : accentGreen.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive
                    ? primaryGreen
                    : isCompleted
                        ? lightGreen
                        : isDarkMode
                            ? accentGreen.withOpacity(0.5)
                            : accentGreen,
                width: 2,
              ),
              boxShadow: isActive || isCompleted
                  ? [
                      BoxShadow(
                        color: primaryGreen.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ]
                  : null,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    )
                  : Text(
                      '${step + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : isDarkMode ? accentGreen : darkGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? primaryGreen
                  : isDarkMode
                      ? Colors.white70
                      : Colors.black54,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(int beforeStep) {
    final isCompleted = _currentStep > beforeStep;
    
    return Container(
      width: 40,
      height: 2,
      color: isCompleted ? lightGreen : Colors.grey.shade300,
    );
  }

  Widget _buildPersonalInfoStep(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Full Name',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            prefixIcon: Icon(Icons.person, color: primaryGreen),
            filled: true,
            fillColor: isDarkMode
                ? const Color(0xFF0A1F0A)
                : accentGreen.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryGreen, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: accentGreen.withOpacity(0.3)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Email Address',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter your email',
            prefixIcon: Icon(Icons.email, color: primaryGreen),
            filled: true,
            fillColor: isDarkMode
                ? const Color(0xFF0A1F0A)
                : accentGreen.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryGreen, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: accentGreen.withOpacity(0.3)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Phone Number',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Enter your phone number',
            prefixIcon: Icon(Icons.phone, color: primaryGreen),
            filled: true,
            fillColor: isDarkMode
                ? const Color(0xFF0A1F0A)
                : accentGreen.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryGreen, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: accentGreen.withOpacity(0.3)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildShopInfoStep(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shop Name',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _shopNameController,
          decoration: InputDecoration(
            hintText: 'Enter your shop name',
            prefixIcon: Icon(Icons.store, color: primaryGreen),
            filled: true,
            fillColor: isDarkMode
                ? const Color(0xFF0A1F0A)
                : accentGreen.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryGreen, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: accentGreen.withOpacity(0.3)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your shop name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Shop Address',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _shopAddressController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter your shop address',
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 64),
              child: Icon(Icons.location_on, color: primaryGreen),
            ),
            filled: true,
            fillColor: isDarkMode
                ? const Color(0xFF0A1F0A)
                : accentGreen.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryGreen, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: accentGreen.withOpacity(0.3)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your shop address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Shop Category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: 'Grocery Store',
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.category, color: primaryGreen),
            filled: true,
            fillColor: isDarkMode
                ? const Color(0xFF0A1F0A)
                : accentGreen.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryGreen, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: accentGreen.withOpacity(0.3)),
            ),
          ),
          dropdownColor: isDarkMode ? const Color(0xFF0A1F0A) : Colors.white,
          items: [
            'Grocery Store',
            'Supermarket',
            'Convenience Store',
            'Organic Food Store',
            'Specialty Food Store',
          ].map((category) => DropdownMenuItem(
            value: category,
            child: Text(category),
          )).toList(),
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildSecurityStep(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Create a password',
            prefixIcon: Icon(Icons.lock, color: primaryGreen),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: primaryGreen,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            filled: true,
            fillColor: isDarkMode
                ? const Color(0xFF0A1F0A)
                : accentGreen.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryGreen, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: accentGreen.withOpacity(0.3)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Confirm Password',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            hintText: 'Confirm your password',
            prefixIcon: Icon(Icons.lock_outline, color: primaryGreen),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: primaryGreen,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            filled: true,
            fillColor: isDarkMode
                ? const Color(0xFF0A1F0A)
                : accentGreen.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryGreen, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: accentGreen.withOpacity(0.3)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: accentGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: accentGreen.withOpacity(0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTerms = value ?? false;
                    });
                  },
                  activeColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                    children: [
                      const TextSpan(
                        text: 'I agree to the ',
                      ),
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: TextStyle(
                          color: primaryGreen,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(
                        text: ' and ',
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: primaryGreen,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
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
    );
  }
}