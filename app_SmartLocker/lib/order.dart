import 'dart:convert';
import 'dart:io';
import 'package:smart_locker/shipper_send_order.dart';

import 'config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:smart_locker/models.dart';
import 'package:intl/intl.dart';
import 'dart:core';

// Widget hiển thị thông tin của một đơn hàng
class HistoryItem extends StatelessWidget {
  final History history;
  final AuthStatus authStatus;
  final Function(History)? onPressed;
  final Function(History)? onReceiveOrderPressed;

  const HistoryItem({
    Key? key,
    required this.history,
    required this.authStatus,
    this.onPressed,
    this.onReceiveOrderPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String formattedStartTime =
        DateFormat('HH:mm:ss MM/dd/yyyy').format(history.startTime);

    String formattedEndTime =
        DateFormat('HH:mm:ss MM/dd/yyyy').format(history.endTime);
    UserHistory? userSend;
    for (var user in history.userHistory) {
      if (user.role == 'SENDER') {
        userSend = user;
        break; // Assuming there is only one sender
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: Color.fromRGBO(58, 57, 103, 1),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (userSend != null)
                        Text(
                          'Sender: ${userSend.name}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      // Display locations
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var location in history.location)
                            if (location.roleLocation == 'LOCATION_SEND')
                              Text(
                                'From: ${location.locationName}',
                                style: TextStyle(fontSize: 12),
                              )
                            else if (location.roleLocation ==
                                'LOCATION_RECEIVE')
                              Text(
                                'To: ${location.locationName}',
                                style: TextStyle(fontSize: 12),
                              ),
                          Text(
                            'Start time: ${formattedStartTime}',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            'End time: ${formattedEndTime}',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(58, 57, 103, 1),
                      onPrimary: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    onPressed: () {
                      if (history.userHistory
                          .any((user) => user.role == 'SHIPPER')) {
                        onPressed?.call(
                            history); // Gọi hàm onPressed và truyền vào đối tượng history
                      } else {
                        onReceiveOrderPressed?.call(
                            history); // Gọi hàm onReceiveOrderPressed và truyền vào đối tượng history
                      }
                    },
                    child: Text(
                      history.userHistory.any((user) => user.role == 'SHIPPER')
                          ? 'Order detail'
                          : 'Receive order',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryDetailDialog extends StatefulWidget {
  final History history;
  final AuthStatus authStatus;
  final Function()? loadHistory;
  const HistoryDetailDialog(
      {Key? key,
      required this.history,
      required this.authStatus,
      required this.loadHistory})
      : super(key: key);

  @override
  _HistoryDetailDialogState createState() => _HistoryDetailDialogState();
}

class _HistoryDetailDialogState extends State<HistoryDetailDialog> {
  final storage = FlutterSecureStorage();
  bool isLoadingGetOTP = false;
  bool isLoadingConfirm = false;
  bool isLoadingRetryOTP = false;
  Future<void> retryOTPRequest({required int historyId}) async {
    final token = await storage.read(key: 'token');
    setState(() {
      isLoadingRetryOTP = true;
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
        isLoadingRetryOTP = false;
      });
      Navigator.pop(context);
      _showSnackBarForSuccessful("Hãy kiểm tra gmail của bạn để lấy mã OTP");
    } else {
      String errorMessage = responseData['errorMessage'];
      _showSnackBarForWarning(errorMessage);
      setState(() {
        isLoadingRetryOTP = false;
      });
    }
  }


  Future<void> _getOTP({required History history}) async {
    final token = await storage.read(key: 'token');
    setState(() {
      isLoadingGetOTP = true; // Bắt đầu quá trình tải
    });
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final response = await httpClient
        .postUrl(Uri.parse('$endpoint/api/locker/register/shipper/get'))
        .then((HttpClientRequest request) {
      request.headers.set('Content-Type', 'application/json');
      request.headers.add('Authorization', 'Bearer $token');
      request.write(jsonEncode({"historyId": history.historyId}));
      return request.close();
    }).then((HttpClientResponse response) async {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    });
    final responseData = json.decode(response);

    if (responseData['status'] == 'OK') {
      String message = responseData['message'];
      _showSnackBarForSuccessful(message);
      widget.loadHistory!();
      Navigator.pop(context);
    } else {
      String errorMessage = responseData['errorMessage'];
      _showSnackBarForWarning(errorMessage);
    }
    setState(() {
      isLoadingGetOTP = false; // Kết thúc quá trình tải
    });
  }

  Future<void> confirmPickup({required History history}) async {
    final token = await storage.read(key: 'token');
    setState(() {
      isLoadingConfirm = true; // Bắt đầu quá trình tải
    });
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final response = await httpClient
        .getUrl(Uri.parse('$endpoint/api/locker/register/shipper/get/confirm/${history.historyId}'))
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
      widget.loadHistory!();
      Navigator.pop(context);
      _showSnackBarForSuccessful(message);
    } else {
      String errorMessage = responseData['errorMessage'];
      _showSnackBarForWarning(errorMessage);
    }
    setState(() {
      isLoadingConfirm = false; // Kết thúc quá trình tải
    });
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
    bool otpExpired = widget.history.otpExpireTime.isBefore(DateTime.now());

    bool endTimeExpired = widget.history.endTime.isBefore(DateTime.now());
    int onProcedure = widget.history.onProcedure;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10), // Margin-top cho nút đầu tiên
            Text('Number order: ${widget.history.historyId}'),
            for (var userHistory
                in widget.history.userHistory) // Duyệt qua mỗi userHistory
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (userHistory.role == 'SENDER') // Kiểm tra vai trò
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sender: ${userHistory.name}'),
                        Text('Phone of sender: ${userHistory.phone}'),
                      ],
                    ),
                  if (userHistory.role == 'RECEIVER') // Kiểm tra vai trò
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Receiver: ${userHistory.name}'),
                        Text('Phone of receiver: ${userHistory.phone}'),
                      ],
                    ),
                ],
              ),
            SizedBox(height: 10), // Margin-top cho nút thứ hai
            Flexible(
              // Nút nhận đơn và lấy OTP
              child: isLoadingGetOTP
                  ? CircularProgressIndicator() // Hiển thị nút xoay tròn loading
                  : ElevatedButton(
                      onPressed: !(otpExpired && !endTimeExpired)
                          ? null
                          : () => _getOTP(history: widget.history),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(58, 57, 103, 1),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Get OTP',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            // Flexible(
            //   // Nút nhận đơn và lấy OTP
            //   child: isLoadingRetryOTP
            //       ? CircularProgressIndicator() // Hiển thị nút xoay tròn loading
            //       : ElevatedButton(
            //           onPressed: !otpExpired
            //               ? null
            //               : () => retryOTPRequest(historyId: widget.history.historyId),
            //           style: ElevatedButton.styleFrom(
            //             primary: Color.fromRGBO(58, 57, 103, 1),
            //             padding:
            //                 EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //           ),
            //           child: Text(
            //             'Retry OTP',
            //             style: TextStyle(
            //               fontSize: 14,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            // ),
            SizedBox(height: 10), 
            Flexible(
              // Nút xác nhận lấy hàng
              child: isLoadingConfirm
                  ? CircularProgressIndicator() // Hiển thị nút xoay tròn loading
                  : ElevatedButton(
                      // onPressed: !(!otpExpired && !endTimeExpired)
                        onPressed: otpExpired
                          ? null // Trường hợp 2 và 3: expireTimeOTP hết hạn hoặc endTime hết hạn
                          : () => confirmPickup(history: widget.history),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(58, 57, 103, 1),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Confirm Pickup',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 10), // Margin-top cho nút thứ tư
            Flexible(
              // Nút xác nhận lấy hàng
              child: ElevatedButton(
                onPressed: !endTimeExpired || (onProcedure > 0)
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterSendOrder(
                                history: widget.history,
                                authStatus: widget.authStatus),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(58, 57, 103, 1),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Register send order',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget hiển thị danh sách đơn hàng
class OrderList extends StatefulWidget {
  final AuthStatus authStatus;
  final BuildContext context;

  OrderList({required this.authStatus, required this.context});

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final storage = FlutterSecureStorage();
  List<History> listHistories = [];

  @override
  void initState() {
    super.initState();
    loadHistory(); // Gọi hàm loadHistory khi initState được gọi
  }


  Future<void> loadHistory() async {
    final userIdLoggedIn = widget.authStatus.user.id;
    final token = await storage.read(key: 'token');
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final response = await httpClient
        .getUrl(Uri.parse('$endpoint/api/history/all'))
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
      final responeseDataAllHistory = responseData['data'];
      List<History> listHistory = parseHistoryList(responeseDataAllHistory);

      setState(() {
        listHistories = filterHistories(listHistory, int.parse(userIdLoggedIn));
      });
    } else {
      String errorMessage = responseData['errorMessage'];
      _showSnackBarForWarning(errorMessage);
    }
  }

  // chuyển thành listHistory từ response
  List<History> parseHistoryList(dynamic data) {
    List<History> historyList = [];
    for (var item in data) {
      List<UserHistory> users = [];
      for (var user in item['users']) {
        users.add(UserHistory(
          userId: user['user']['id'],
          name: user['user']['name'],
          phone: user['user']['phone'],
          role: user['role'],
        ));
      }

      List<Location> locations = [];
      for (var loc in item['location']) {
        locations.add(Location(
          locationName: loc['location']['location'],
          roleLocation: loc['role'],
        ));
      }

      // Kiểm tra xem 'onProcedure' có tồn tại trong 'item' không
      var onProcedure =
          item.containsKey('onProcedure') ? item['onProcedure'] : -1;

      historyList.add(History(
        historyId: item['historyId'],
        userHistory: users,
        startTime: DateTime.parse(item['startTime']),
        endTime: DateTime.parse(item['endTime']),
        location: locations,
        otpExpireTime: DateTime.parse(item['otp']['expireTime']),
        onProcedure: onProcedure,
      ));
    }
    return historyList;
  }

  Future<void> handleReceiveOrder(History history) async {
    final token = await storage.read(key: 'token');
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final response = await httpClient
        .getUrl(Uri.parse('$endpoint/api/locker/register/shipper/confirm-order/${history.historyId}'))
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
      loadHistory();
      _showSnackBarForSuccessful("Receive order successful");
    } else {
      String errorMessage = responseData['errorMessage'];
      _showSnackBarForWarning(errorMessage);
    }
  }

  List<History> filterHistories(List<History> histories, int userIdLoggedIn) {
    // Lọc những lịch sử có onProcedure là null
    var historiesWithNullProcedure = histories
        .where((history) =>
            history.onProcedure < 0 &&
            !history.startTime.add(Duration(hours: 1)).isBefore(DateTime.now()))
        .toList();

    // var historiesWithNullProcedure = histories
    // .where((history) =>
    //     history.onProcedure < 0 )
    // .toList();

    // Lọc những lịch sử có onProcedure khác null
    var historiesWithProcedure =
        histories.where((history) => history.onProcedure > 0).toList();
    //histories[11].startTime.add(Duration(hours: 1));
    // Danh sách tạm thời để lưu trữ các lịch sử phù hợp
    List<History> temporaryHistories = [];

    // Duyệt qua các lịch sử có onProcedure khác null
    for (var history in historiesWithProcedure) {
      // Tìm lịch sử có id lớn hơn id của lịch sử hiện tại trong danh sách
      var matchingHistory = historiesWithProcedure.firstWhere(
        (h) => h.historyId == history.onProcedure,
        orElse: () => History(
            historyId: -1,
            userHistory: [],
            startTime: DateTime.now(),
            endTime: DateTime.now(),
            location: [],
            otpExpireTime: DateTime.now(),
            onProcedure:
                -1), // Trả về một lịch sử giả định nếu không tìm thấy lịch sử phù hợp
      );
      bool endTimeExpired = history.endTime.isBefore(DateTime.now());
      // Nếu tìm thấy lịch sử phù hợp và id của lịch sử đó lớn hơn id của lịch sử hiện tại
      if (matchingHistory.historyId != -1 &&
          matchingHistory.historyId < history.historyId &&
          !endTimeExpired) {
        // Thêm lịch sử phù hợp vào danh sách tạm thời
        temporaryHistories.add(matchingHistory);
      }
    }

    // Thêm các lịch sử từ danh sách tạm thời vào danh sách lịch sử chứa các lịch sử có onProcedure là null
    historiesWithNullProcedure.addAll(temporaryHistories);
    var filteredHistories = historiesWithNullProcedure.where((history) =>
        !history.userHistory.any((user) => user.role == 'SHIPPER') ||
        history.userHistory.any(
            (user) => user.role == 'SHIPPER' && user.userId == userIdLoggedIn));

    // Trả về danh sách lịch sử sau khi đã lọc và sắp xếp
    return filteredHistories.toList();
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
    return Scaffold(
      backgroundColor: Color.fromRGBO(251, 247, 239, 1),
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
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
                'List Orders',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: listHistories.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'There are no orders',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: listHistories.length,
                    padding: const EdgeInsets.symmetric(horizontal: 19.0),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            // Remove the Border
                          ),
                          child: HistoryItem(
                            history: listHistories[index],
                            authStatus: widget.authStatus,
                            onPressed: (history) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return HistoryDetailDialog(
                                    history: listHistories[index],
                                    authStatus: widget.authStatus,
                                    loadHistory: () =>
                                        loadHistory(), // Truyền một hàm callback nhận đối số void
                                  );
                                },
                              );
                            },
                            onReceiveOrderPressed: handleReceiveOrder,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
