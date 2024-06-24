import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_locker/comfirm_order.dart';
import 'package:smart_locker/models.dart';
import 'config.dart';

class OrderLocker extends StatefulWidget {
  final AuthStatus authStatus;
  OrderLocker({required this.authStatus});

  @override
  _OrderLockerState createState() => _OrderLockerState();
}

class _OrderLockerState extends State<OrderLocker> {
  String selectedRecipient = "Người nhận số 0";

  String selectedLocation1 = "1"; // Điểm gửi mặc định
  String selectedLocation2 = "2"; // Điểm đến mặc định
  List<String> availableHours = [];
  String selectedUserId =
      '1'; // Thêm biến này để lưu trữ userId người được chọn

  //List<dynamic> users = [];
  List<dynamic> users = [];
  TextEditingController txtOtp = TextEditingController();
  String historyId = "";
  bool isLoading = false;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }
  Future<void> _loadUsers() async {
    final userIdLoggedIn = widget.authStatus.user.id;
    final token = await storage.read(key: 'token');
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final response = await httpClient
        .getUrl(Uri.parse('$endpoint/api/user/all'))
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

      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('data')) {
        final List<dynamic> userList = responseData['data'];

        // Lấy giá trị của khóa "id" và "roles" từ mỗi phần tử trong danh sách userList
        final List<Map<String, dynamic>> extractedUsers = userList
            .where((user) {
              // Lấy danh sách các vai trò của người dùng
              final List<dynamic> roles = user['roles'];

              // Kiểm tra xem người dùng có vai trò "ROLE_USER" không
              return roles.contains("ROLE_USER") &&
                  !roles.contains("ROLE_SHIPPER");
            })
            .map((user) {
              return {
                'id': user['id'].toString(),
                'name': user['name'], // Lấy tên của người dùng
                'phone': user['phone'], // Lấy số điện thoại của người dùng
                'roles': ["ROLE_USER"], // Chỉ lấy vai trò "ROLE_USER"
                // Bạn có thể trích xuất các thông tin khác ở đây nếu cần
              };
            })
            .where((user) =>
                user['id'] !=
                userIdLoggedIn) // Loại bỏ người dùng có ID giống như userIdLoggedIn
            .toList();

        setState(() {
          // Chuyển đổi extractedUsers thành đúng định dạng của users
          users = extractedUsers.map((user) {
            return {
              'userId': user['id'],
              'name': user['name'], // Bạn có thể cung cấp thông tin tên nếu có
              'phone': user[
                  'phone'], // Bạn có thể cung cấp thông tin số điện thoại nếu có
            };
          }).toList();
          selectedUserId = users.isNotEmpty ? users[0]['userId'] : '';
        });
      } else {
        print('Dữ liệu JSON không có cấu trúc phù hợp.');
      }
    } else if (responseData['status'] != 'OK') {
      print('Chưa đăng nhập');
    } else {
      print("Lỗi Server");
    }
  }

  List<DropdownMenuItem<String>> _buildRecipientItems() {
    return users.map((user) {
      final String name = user['name'] ?? '';
      final String phone = user['phone'] ?? '';
      final String userId = user['userId'] ?? '';

      return DropdownMenuItem<String>(
        value: userId,
        child: Text('$name - $phone'),
      );
    }).toList();
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
  Future<void> registerLocker() async {
    final token = await storage.read(key: 'token');

    setState(() {
      isLoading = true;
    });

    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final response = await httpClient
        .postUrl(Uri.parse('$endpoint/api/locker/register/sender/send'))
        .then((HttpClientRequest request) {
      request.headers.set('Content-Type', 'application/json');
      request.headers.add('Authorization', 'Bearer $token');
      request.write(
          jsonEncode({
        "receiver": selectedUserId,
        "locationSend": selectedLocation1,
        "locationReceive": selectedLocation2
      }));
      return request.close();
    }).then((HttpClientResponse response) async {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    });
    final responseData = json.decode(response);

    if (responseData['status'] == 'OK') {
      String messageTrueorFalse = responseData['message'];
      // nếu không còn tủ thì dô hàm này
      if (messageTrueorFalse.contains("Register locker fail")) {
        _showSnackBarForWarning(
            "Failed to register locker, no available lockers left");
        setState(() {
          isLoading = false;
        });
        return;
      }
      final historyId = responseData['data']['historyId'];
      String message = responseData['message'];
      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmOrderScreen(
            authStatus: widget.authStatus,
            historyId: historyId,
          ),
        ),
      );
      _showSnackBarForSuccessful(message);
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
    double screenHeight = MediaQuery.of(context).size.height;

    double appBarHeight = 80.0;
    double paddingVertical = screenHeight * 0.1;
    double paddingHorizontal = screenWidth * 0.1;
    double fontSize = screenWidth * 0.05;

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(251, 247, 239, 1),
        child: Stack(
          children: [
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: Color.fromRGBO(58, 57, 103, 1)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Positioned(
              top: appBarHeight ,
              left: paddingHorizontal,
              right: paddingHorizontal,
              bottom: paddingVertical,
              child: Text(
                'Register Locker',
                style: TextStyle(
                  color: Color.fromRGBO(58, 57, 103, 1),
                  fontSize: fontSize + 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: paddingHorizontal, vertical: appBarHeight + paddingVertical + 20),
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 0.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(236, 226, 201, 1),
                      blurRadius: screenWidth * 0.02,
                      spreadRadius: screenWidth * 0.02,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromRGBO(58, 57, 103, 1),
                            width: screenWidth * 0.01,
                          ),
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.03),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02),
                              child: Icon(
                                Icons.person,
                                size: screenWidth * 0.07,
                                color: Color.fromRGBO(58, 57, 103, 1),
                              ),
                            ),
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedUserId,
                                onChanged: (String? newValue) {
                                  final selectedUser = users.firstWhere(
                                      (user) => user['userId'] == newValue);
                                  setState(() {
                                    selectedRecipient =
                                        selectedUser['name'] ?? '';
                                    selectedUserId = newValue!;
                                  });
                                },
                                items: _buildRecipientItems(),
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                underline: Container(),
                                dropdownColor: Color.fromRGBO(255, 247, 233, 1),
                                menuMaxHeight: screenHeight * 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            width: screenWidth * 0.01,
                          ),
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.03),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02),
                              child: Icon(
                                Icons.location_on,
                                size: screenWidth * 0.07,
                                color: Colors.green,
                              ),
                            ),
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedLocation1,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedLocation1 = newValue!;
                                    if (selectedLocation1 ==
                                        selectedLocation2) {
                                      selectedLocation2 =
                                          (selectedLocation1 == "1")
                                              ? "2"
                                              : "1";
                                    }
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: "1",
                                    child: Text("Send: Vo Van Tan"),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "2",
                                    child: Text("Send: Nha Be"),
                                  ),
                                ],
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.black,
                                ),
                                underline: Container(),
                                dropdownColor: Color.fromRGBO(255, 247, 233, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.orange,
                            width: screenWidth * 0.01,
                          ),
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.03),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02),
                              child: Icon(
                                Icons.location_on,
                                size: screenWidth * 0.07,
                                color: Colors.orange,
                              ),
                            ),
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedLocation2,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedLocation2 = newValue!;
                                    if (selectedLocation1 ==
                                        selectedLocation2) {
                                      selectedLocation1 =
                                          (selectedLocation2 == "1")
                                              ? "2"
                                              : "1";
                                    }
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: "1",
                                    child: Text("To: Vo Van Tan"),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "2",
                                    child: Text("To: Nha Be"),
                                  ),
                                ],
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.black,
                                ),
                                underline: Container(),
                                dropdownColor: Color.fromRGBO(255, 247, 233, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Padding(
                              padding: EdgeInsets.only(top: screenWidth * 0.06),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (mounted) {
                                    registerLocker();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(58, 57, 103, 1),
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.025),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(screenWidth * 0.0375),
                                  child: Text(
                                    'Register Locker',
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
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
