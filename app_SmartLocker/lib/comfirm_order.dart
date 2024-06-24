import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:smart_locker/models.dart';
import 'config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ConfirmOrderScreen extends StatefulWidget {
  final AuthStatus authStatus;
  final int historyId;

  ConfirmOrderScreen({
    required this.authStatus,
    required this.historyId,
  });

  @override
  _ConfirmOrderScreenState createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  final storage = FlutterSecureStorage();

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    isLoading = false;
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


  Future<void> sendOTPRequest({required int historyId}) async {
    final token = await storage.read(key: 'token');
    setState(() {
      isLoading = true;
    });
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final response = await httpClient
        .getUrl(Uri.parse('$endpoint/api/locker/register/sender/send/confirm/$historyId'))
        .then((HttpClientRequest request) {
      request.headers.set('Content-Type', 'application/json');
      request.headers.add('Authorization', 'Bearer $token');
      return request.close();
    }).then((HttpClientResponse response) async {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    });
    final responseData = json.decode(response);

    if (responseData['status'] == 'OK') {
      String message = responseData['message'];
      String message2 = responseData['data'];

      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      _showSnackBarForSuccessful(message + ". " + message2);
    } else {
      String errorMessage = responseData['errorMessage'];
      _showSnackBarForWarning(errorMessage);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> retryOTPRequest({required int historyId}) async {
    final token = await storage.read(key: 'token');
    setState(() {
      isLoading = true;
    });
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final response = await httpClient
        .postUrl(Uri.parse('$endpoint/api/locker/register/retry'))
        .then((HttpClientRequest request) {
      request.headers.set('Content-Type', 'application/json');
      request.headers.add('Authorization', 'Bearer $token');
      request.write(
          jsonEncode({"historyId": historyId}));
      return request.close();
    }).then((HttpClientResponse response) async {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    });
    final responseData = json.decode(response);

    if (responseData['status'] == 'OK') {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      _showSnackBarForSuccessful("Hãy kiểm tra gmail của bạn để lấy mã OTP");
    } else {
      String errorMessage = responseData['errorMessage'];
      _showSnackBarForWarning(errorMessage);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(251, 247, 239, 1),
      body: Stack(
        children: [
          Positioned(
            top: 30.0,
            left: 5.0,
            child: IconButton(
              icon:
                  Icon(Icons.arrow_back, color: Color.fromRGBO(58, 57, 103, 1)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          Positioned(
            top: 100.0, // Đặt chữ ở giữa theo chiều dọc
            left: null, // Đặt left thành null để sử dụng center
            right: screenWidth / 8, // Đặt right thành null để sử dụng center
            child: Center(
              child: Text(
                'Confirm Order Sent',
                style: TextStyle(
                  color: Color.fromRGBO(58, 57, 103, 1),
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 300.0, // Đặt Stack ở vị trí top 100
                child: Container(
                  width: 250, // Độ rộng của "khung tủ"
                  height: 200, // Chiều cao của "khung tủ"
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(245, 242, 237, 1),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Color.fromRGBO(58, 57, 103, 1),
                      width: 3.0,
                    ),
                  ),
                ),
              ),
              isLoading
                  ? Positioned(
                      top: 475.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(58, 57, 103, 1),
                        ),
                      ),
                    )
                  : Positioned(
                      top: 475.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(58, 57, 103, 1),
                          onPrimary: Colors.white,
                        ),
                        onPressed: () {
                          sendOTPRequest(historyId: widget.historyId);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Confirm Sent',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
              isLoading
                  ? Positioned(
                      top: 535.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(58, 57, 103, 1),
                        ),
                      ),
                    )
                  : Positioned(
                      top: 535.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(58, 57, 103, 1),
                          onPrimary: Colors.white,
                        ),
                        onPressed: () {
                          retryOTPRequest(historyId: widget.historyId);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Retry OTP',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          Positioned(
            top: 180.0, // Đặt hình ảnh tủ lên trên cùng
            left: null, // Đặt left thành null để sử dụng center
            right: screenWidth / 8,
            child: Container(
              width: 300, // Độ rộng của hình ảnh tủ
              height: 300, // Chiều cao của hình ảnh tủ
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://img.icons8.com/?size=256&id=X0DtpHwZq9IO&format=png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
