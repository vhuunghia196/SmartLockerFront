import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_locker/main.dart';
import 'package:smart_locker/models.dart';
import 'config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditProfileScreen extends StatefulWidget {
  final AuthStatus
      authStatus; // User object to display and edit personal information

  EditProfileScreen({required this.authStatus});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    // Initialize initial values for personal information fields
    _nameController.text = widget.authStatus.user.name;
    _emailController.text = widget.authStatus.user.email;
    _phoneController.text = widget.authStatus.user.phone;
  }

  bool isEmailValid(String email) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9._%+-]+@(gmail\.com|ou\.edu\.vn)$');
    return regex.hasMatch(email);
  }

  void _saveChanges(context) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    // Save changes to user's personal information
    final newName = _nameController.text;
    final newEmail = _emailController.text;
    final newPhone = _phoneController.text;
    if (!isEmailValid(newEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Email must be in the format @gmail.com'),
      ));
      return; // Do not proceed with saving if email is invalid
    }
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final response = await httpClient
        .postUrl(Uri.parse('$endpoint/api/user/user-info/role'))
        .then((HttpClientRequest request) {
      request.headers.set('Content-Type', 'application/json');
      request.headers.add('Authorization', 'Bearer $token');

      request.write(
          jsonEncode({
        "name": newName,
        "phone": newPhone,
        "mail": newEmail,
      }));
      return request.close();
    }).then((HttpClientResponse response) async {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    });
    final responseData = json.decode(response);
    // Show notification or success message
    if (responseData['status'] == 'OK') {
      User updatedUser = User(
        id: widget.authStatus.user.id,
        name: newName,
        email: newEmail,
        phone: newPhone,
        roles: widget.authStatus.user.roles
      );

      widget.authStatus.updateUser(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Personal information has been updated.'),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => (HomeScreen(authStatus: widget.authStatus)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

// Tính toán giá trị padding và margin dựa trên phần trăm của kích thước màn hình
    final double verticalPadding =
        screenHeight * 0.05; // 5% của chiều cao màn hình
    final double horizontalPadding =
        screenWidth * 0.05; // 5% của chiều rộng màn hình
    final double margin = 130.0; // Giá trị margin muốn thêm vào

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
                  icon: Icon(
                    Icons.arrow_back,
                    color: const Color.fromRGBO(58, 57, 101, 1),
                  ),
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
                  'Change Infomations',
                  style: TextStyle(
                    color: Color.fromRGBO(58, 57, 101, 1),
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: verticalPadding + margin,
                bottom: verticalPadding,
                left: horizontalPadding + 20,
                right: horizontalPadding + 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name'),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Email'),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Phone'),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(58, 57, 103, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 13.0,
                        horizontal: 13.0,
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            _saveChanges(context);
                            FocusScope.of(context).unfocus();
                          },
                    child: Container(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
