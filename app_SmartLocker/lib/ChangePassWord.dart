import 'dart:convert';
import 'dart:io';
import 'package:smart_locker/login_screen.dart';

import 'config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

  bool isLoading = false;
  final storage = FlutterSecureStorage();

  Future<void> sendResetPassWord(BuildContext context) async {
    String oldPassword = oldPasswordController.text;
    String newPassword = newPasswordController.text;
    final token = await storage.read(key: 'token');



    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final response = await httpClient
        .postUrl(Uri.parse('$endpoint/api/user/change-password'))
        .then((HttpClientRequest request) {
      request.headers.set('Content-Type', 'application/json');
      request.headers.add('Authorization', 'Bearer $token');

      request.write(
          jsonEncode({
        'oldPass': oldPassword,
        'newPass' : newPassword
      }));
      return request.close();
    }).then((HttpClientResponse response) async {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    });
    final responseData = json.decode(response);
    if (responseData['status'] == 'OK') {
      String message = responseData['message'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => (LoginScreen()),
        ),
      );
      _showSnackBarForSuccessful(message);
    } else {
      String errorMessage = responseData['errorMessage'];
      _showSnackBarForWarning(errorMessage);
    }
  }

  // Hiển thị SnackBar cảnh báo
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(58, 57, 101, 1),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  // Hiển thị SnackBar thành công
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: const Color.fromRGBO(58, 57, 101, 1)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.12,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    color: Color.fromRGBO(58, 57, 101, 1),
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.20,
              left: 20.0,
              right: 20.0,
              child: Center(
                child: Text(
                  'Please enter your old password, so we will send you a new password to your email!',
                  style: TextStyle(
                    color: Color.fromRGBO(58, 57, 101, 1),
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(30, 200, 30, 30),
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Đặt căn chỉnh theo chiều ngang là start
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0), // Điều chỉnh khoảng cách bên trái
                      child: Text(
                        'Old password:',
                        style: TextStyle(
                            color: Color.fromRGBO(58, 57, 101, 1),
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      style: TextStyle(
                        color: const Color.fromRGBO(58, 57, 101, 1),
                        fontSize: 15.0,
                      ),
                      controller: oldPasswordController,
                      decoration: InputDecoration(
                        hintText: '123456@Aa',
                        filled: true,
                        labelStyle: TextStyle(
                          color: const Color.fromRGBO(58, 57, 101, 1),
                          fontWeight: FontWeight.bold,
                        ),
                        fillColor: Colors.transparent,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(58, 57, 101, 1),
                              width: 1.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(58, 57, 101, 1),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 20.0,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: true
                    ),
                    SizedBox(height: 16.0),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0), // Điều chỉnh khoảng cách bên trái
                      child: Text(
                        'New password:',
                        style: TextStyle(
                            color: Color.fromRGBO(58, 57, 101, 1),
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      style: TextStyle(
                        color: const Color.fromRGBO(58, 57, 101, 1),
                        fontSize: 15.0,
                      ),
                      controller: newPasswordController,
                      decoration: InputDecoration(
                        filled: true,
                        labelStyle: TextStyle(
                          color: const Color.fromRGBO(58, 57, 101, 1),
                          fontWeight: FontWeight.bold,
                        ),
                        fillColor: Colors.transparent,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(58, 57, 101, 1),
                              width: 1.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(58, 57, 101, 1),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 20.0,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: true
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
                              sendResetPassWord(context);
                              FocusScope.of(context).unfocus();
                            },
                      child: Container(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Reset password',
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
