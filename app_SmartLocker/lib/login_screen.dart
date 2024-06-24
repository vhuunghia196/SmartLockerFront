import 'dart:io';

import 'package:smart_locker/forget_password.dart';
import 'package:smart_locker/main.dart';
import 'package:smart_locker/models.dart';
import 'config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:convert';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  final storage = FlutterSecureStorage();

  FocusNode _focusNode = FocusNode();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(58, 57, 103, 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    String username = usernameController.text;
    String password = passwordController.text;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final response = await httpClient
        .postUrl(Uri.parse('$endpoint/api/auth/login'))
        .then((HttpClientRequest request) {
      request.headers.set('Content-Type', 'application/json');
      request.write(
          jsonEncode({'usernameOrEmail': username, 'password': password}));
      return request.close();
    }).then((HttpClientResponse response) async {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    });
    final responseData = json.decode(response);

    if (responseData['status'] == 'OK') {
      String message = responseData['message'];

      final userData = responseData['data']['user'];
      List<String> roles = List<String>.from(userData['roles']);
      String accessToken = responseData['data']['accessToken'];
      await storage.write(key: 'token', value: accessToken);

      final user = User(
        id: userData['id'].toString(),
        name: userData['name'],
        email: userData['email'],
        phone: userData['phone'],
        roles: roles,
      );
      final authStatus = AuthStatus(true, user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(authStatus: authStatus),
        ),
      );
      _showSnackBar(message);
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Username or password are incorrect');
      _showSnackBar("Username or password are incorrect");
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              'lib/images/login.jpg',
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
              top: MediaQuery.of(context).size.height * 0.2,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Guarding your belongings, one locker at a time!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(30, 50, 30, 30),
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 15.0),
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Phone number/Username',
                        filled: true,
                        labelStyle: TextStyle(
                            color: const Color.fromRGBO(58, 57, 101, 1),
                            fontWeight: FontWeight.bold),
                        fillColor: Colors.transparent,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0), // Màu viền khi focus
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white, // Màu viền khi không focus
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 15.0),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 15.0),
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        labelStyle: TextStyle(
                            color: const Color.fromRGBO(58, 57, 101, 1),
                            fontWeight: FontWeight.bold),
                        fillColor: Colors.transparent,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0), // Màu viền khi focus
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white, // Màu viền khi không focus
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
                          vertical: 15.0,
                          horizontal: 15.0,
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              FocusScope.of(context).unfocus(); // Ẩn bàn phím
                              login(context);
                            },
                      child: Container(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isLoading) SizedBox(height: 16.0),
                    if (isLoading) CircularProgressIndicator(),

                    SizedBox(height: 10.0),
                    // Text('Forgot password?'),
                    InkWell(
                      onTap: () {
                        // Khi nút Quên mật khẩu được nhấn, chuyển sang màn hình Quên mật khẩu
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: const Color.fromARGB(
                              255, 0, 0, 0), // Màu sắc của văn bản nút
                          decoration:
                              TextDecoration.underline, // Gạch chân văn bản
                        ),
                      ),
                    ),
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
