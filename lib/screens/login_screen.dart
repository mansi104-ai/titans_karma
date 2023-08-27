import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pec_chat/resources/auth_methods.dart';
import 'package:pec_chat/responsive/mobile_screen_layout.dart';
import 'package:pec_chat/responsive/responsive_layout.dart';
import 'package:pec_chat/responsive/web_screen_layout.dart';
import 'package:pec_chat/screens/signup_screen.dart';
import 'package:pec_chat/utils/colors.dart';
import 'package:pec_chat/utils/global_variable.dart';
import 'package:pec_chat/utils/utils.dart';
import 'package:pec_chat/widgets/text_field_input.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              ),
            ),
            (route) => false);

        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  resizeToAvoidBottomInset: false,
  body: SafeArea(
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Container(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3)
                : const EdgeInsets.symmetric(horizontal: 32),
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
                const SizedBox(height: 64),
                Container( // Wrap the column in a Container
                  color: Colors.teal, // Set your desired background color
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFieldInput(
                        hintText: 'Enter your email',
                        textInputType: TextInputType.emailAddress,
                        textEditingController: _emailController,
                      ),
                      SizedBox(height: 24),
                      TextFieldInput(
                        hintText: 'Enter your password',
                        textInputType: TextInputType.text,
                        textEditingController: _passwordController,
                        isPass: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                InkWell(
                  onTap: loginUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: Colors.teal,
                    ),
                    child: !_isLoading
                        ? Text(
                            'Log in',
                            style: TextStyle(color: Colors.black),
                          )
                        : CircularProgressIndicator(
                            color: Colors.white,
                          ),
                  ),
                ),
                const SizedBox(height: 12),
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
                        'Don\'t have an account?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          ' Signup.',
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
      ],
    ),
  ),
);
    }}