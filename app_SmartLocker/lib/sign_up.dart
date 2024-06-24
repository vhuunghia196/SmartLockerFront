import 'dart:convert';
import 'dart:io';
import 'config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;
  final storage = FlutterSecureStorage();

  Future<void> signUp(BuildContext context) async {
    String name = nameController.text.trim();
    String username = usernameController.text.trim();
    String phone = phoneNumberController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String email = emailController.text.trim();
    if (!isValidPhoneNumber(phone)) {
      // sai sdt
      _showSnackBarForWarning('Phone number should be 0923...(10 number) ');
      return;
    }
    if (!isEmailValid(email)) {
      // sai gmail
      _showSnackBarForWarning(
          'Email must be a valid Gmail address @gmail.com or @ou.edu.vn');
      return;
    }

    if (!doPasswordsMatch(password, confirmPassword)) {
      // sai mật khẩu
      _showSnackBarForWarning('Passwords do not match');
      return;
    }

    if (!isStrongPassword(password)) {
      // sai mật khẩu
      _showSnackBarForWarning(
          'Passwords are not special characters, numbers, uppercase letters, and lowercase letters, should be 123456@Aa ');
      return;
    }

    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final response = await httpClient
        .postUrl(Uri.parse('$endpoint/api/auth/signup'))
        .then((HttpClientRequest request) {
      request.headers.set('Content-Type', 'application/json');
      request.write(
          jsonEncode({
        'name': name,
        'password': password,
        'username': username,
        'email': email,
        'phone': phone,
      }));
      return request.close();
    }).then((HttpClientResponse response) async {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    });
    final responseData = json.decode(response);

    if (responseData['status']== 'OK') {
      String message = responseData['message'];

      String accessToken = responseData['data']['accessToken'];
      await storage.write(key: 'token', value: accessToken);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
      _showSnackBarForSuccessful(message);
    } else {
      String errorMessage = responseData['errorMessage'];
      _showSnackBarForWarning(errorMessage);
    }
  }

  // kiểm tra password trùng
  bool doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  // kiểm tra định dạng gmail
  bool isEmailValid(String email) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9._%+-]+@(gmail\.com|ou\.edu\.vn)$');
    return regex.hasMatch(email);
  }

  // kiểm tra sđt
  bool isValidPhoneNumber(String phoneNumber) {
    RegExp phoneRegExp = RegExp(r'^0[0-9]{9}$');
    return phoneRegExp.hasMatch(phoneNumber);
  }

  bool isStrongPassword(String password) {
    bool hasUppercase = RegExp(r'[A-Z]').hasMatch(password);

    bool hasLowercase = RegExp(r'[a-z]').hasMatch(password);

    bool hasDigit = RegExp(r'\d').hasMatch(password);

    bool hasSpecialCharacters =
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    bool isLengthValid = password.length >= 8;

    // Tổng hợp tất cả các điều kiện
    return hasUppercase &&
        hasLowercase &&
        hasDigit &&
        hasSpecialCharacters &&
        isLengthValid;
  }

  // thông báo sai cho người dùng
  void _showSnackBarForWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.warning,
              color: Colors.red,
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
                maxLines: 2, // Số dòng tối đa bạn muốn hiển thị
                overflow: TextOverflow
                    .ellipsis, // Hiển thị dấu chấm ở cuối nếu quá dài
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(58, 57, 101, 1),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  void _showSnackBarForSuccessful(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check,
              color: Colors.green,
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
                maxLines: 2, // Số dòng tối đa bạn muốn hiển thị
                overflow: TextOverflow
                    .ellipsis, // Hiển thị dấu chấm ở cuối nếu quá dài
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(58, 57, 101, 1),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double fontSize = screenSize.width * 0.04;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: <Widget>[
            Image.asset(
              'lib/images/signup.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Positioned(
              top: screenSize.height * 0.12,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Smart Storage Space for an Active Lifestyle',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize * 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(30, 120, 30, 30),
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    //SizedBox(height: 20.0),
                    TextField(
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: fontSize,
                      ),
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        filled: true,
                        labelStyle: TextStyle(
                          color: const Color.fromRGBO(58, 57, 101, 1),
                          fontWeight: FontWeight.bold,
                        ),
                        fillColor: Colors.transparent,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 3.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 15.0,
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: fontSize,
                      ),
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        filled: true,
                        labelStyle: TextStyle(
                          color: const Color.fromRGBO(58, 57, 101, 1),
                          fontWeight: FontWeight.bold,
                        ),
                        fillColor: Colors.transparent,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 3.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 15.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: fontSize,
                            ),
                            controller: usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              filled: true,
                              labelStyle: TextStyle(
                                color: const Color.fromRGBO(58, 57, 101, 1),
                                fontWeight: FontWeight.bold,
                              ),
                              fillColor: Colors.transparent,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 3.0),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 15.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: fontSize,
                            ),
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              filled: true,
                              labelStyle: TextStyle(
                                color: const Color.fromRGBO(58, 57, 101, 1),
                                fontWeight: FontWeight.bold,
                              ),
                              fillColor: Colors.transparent,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 3.0),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 15.0,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: fontSize,
                      ),
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        helperText:
                            'At least one uppercase letter, one lowercase letter, one digit, and one special character.',
                        helperMaxLines: 2,
                        filled: true,
                        labelStyle: TextStyle(
                          color: const Color.fromRGBO(58, 57, 101, 1),
                          fontWeight: FontWeight.bold,
                        ),
                        fillColor: Colors.transparent,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 3.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        suffixIcon: Icon(Icons.lock),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 15.0),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: fontSize,
                      ),
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        filled: true,
                        labelStyle: TextStyle(
                          color: const Color.fromRGBO(58, 57, 101, 1),
                          fontWeight: FontWeight.bold,
                        ),
                        fillColor: Colors.transparent,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 3.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        suffixIcon: Icon(Icons.lock),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 15.0),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(58, 57, 103, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 15.0),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              signUp(context);
                              FocusScope.of(context).unfocus();
                            },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 0.0),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 1.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'or',
                            style: TextStyle(
                              color: Color.fromRGBO(58, 57, 103, 1),
                              fontSize: fontSize,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 1.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Center(
                      child: Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                        ),
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    LoginScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOutQuart;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                            transitionDuration: Duration(milliseconds: 200),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        padding: EdgeInsets.zero,
                        primary: Color.fromRGBO(58, 57, 103, 1),
                      ),
                    ),
                    if (isLoading) SizedBox(height: 16.0),
                    if (isLoading) CircularProgressIndicator(),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
