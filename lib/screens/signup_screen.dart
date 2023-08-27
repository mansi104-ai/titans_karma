import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pec_chat/resources/auth_methods.dart';
import 'package:pec_chat/responsive/mobile_screen_layout.dart';
import 'package:pec_chat/responsive/responsive_layout.dart';
import 'package:pec_chat/responsive/web_screen_layout.dart';
import 'package:pec_chat/screens/login_screen.dart';
import 'package:pec_chat/utils/colors.dart';
import 'package:pec_chat/utils/utils.dart';
import 'package:pec_chat/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
return Scaffold(
  resizeToAvoidBottomInset: false,
  body: Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/bg.jpg'),
        fit: BoxFit.cover,
      ),
    ),
    child: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            SvgPicture.asset(
              'assets/images/pec_chat.svg',
              color: Colors.white,
              height: 100,
            ),
            const SizedBox(
              height: 64,
            ),
            Stack(
              children: [
                // ... circle avatar code ...
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              color: Colors.teal, // Change background color to teal
              padding: const EdgeInsets.all(8),
              child: TextFieldInput(
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              color: Colors.teal, // Change background color to teal
              padding: const EdgeInsets.all(8),
              child: TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              color: Colors.teal, // Change background color to teal
              padding: const EdgeInsets.all(8),
              child: TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              color: Colors.teal, // Change background color to teal
              padding: const EdgeInsets.all(8),
              child: TextFieldInput(
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
                textEditingController: _bioController,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: signUpUser,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  color: Colors.teal,
                ),
                child: !_isLoading
                    ? const Text(
                        'Sign up',
                        style: TextStyle(color: Colors.white), // Set text color
                      )
                    : const CircularProgressIndicator(
                        color: primaryColor,
                      ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    'Already have an account?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      ' Login.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
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
);

  }
}