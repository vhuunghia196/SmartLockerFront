import 'dart:convert';
import 'dart:io';
import 'package:smart_locker/login_screen.dart';

import 'config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfirmEmailScreen extends StatefulWidget {
  final String email;

  ConfirmEmailScreen({required this.email});

  @override
  _ConfirmEmailScreenState createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  final TextEditingController otpController = TextEditingController();
  bool _isProcessing = false;

  Future<void> confirmOTP(BuildContext context) async {
    String otpConfirm = otpController.text;

    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final response = await httpClient
        .postUrl(Uri.parse('$endpoint/api/user/forgot-password/confirm'))
        .then((HttpClientRequest request) {
      request.headers.set('Content-Type', 'application/json');
      request.write(
          jsonEncode({
        'otp': otpConfirm,
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
                  'Confirm Email',
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
                  'Please enter the OTP sent to your email to confirm.',
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
                margin: EdgeInsets.fromLTRB(30, 250, 30, 30),
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Enter OTP:',
                        style: TextStyle(
                          color: Color.fromRGBO(58, 57, 101, 1),
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: otpController,
                      style: TextStyle(
                        color: const Color.fromRGBO(58, 57, 101, 1),
                        fontSize: 15.0,
                      ),
                      keyboardType:
                          TextInputType.number, // Chỉ cho phép nhập số
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter
                            .digitsOnly // Giới hạn chỉ cho phép nhập số
                      ],
                      decoration: InputDecoration(
                        hintText: 'Enter OTP',
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
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(58, 57, 103, 1),
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(15.0),
                        ),
                        onPressed: _isProcessing
                            ? null
                            : () async {
                                setState(() {
                                  _isProcessing = true;
                                });
                                FocusScope.of(context).unfocus(); // Ẩn bàn phím
                                await confirmOTP(context); // Xác nhận OTP
                                setState(() {
                                  _isProcessing = false;
                                });
                              },
                        child: _isProcessing
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 30.0,
                              ),
                      ),
                    ),

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
