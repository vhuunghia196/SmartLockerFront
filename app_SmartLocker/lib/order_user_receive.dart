import 'dart:convert';
import 'dart:io';
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
  final Function(History)? onPressed;
  final Function(History)? onReceiveOrderPressed;
  const HistoryItem({
    Key? key,
    required this.history,
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

    bool otpExpired = history.otpExpireTime.isBefore(DateTime.now());
    bool endTimeExpired = history.endTime.isBefore(DateTime.now());

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
                      Text(
                        'Number order: ${history.historyId}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (userSend != null)
                        Text(
                          'Ordered: ${userSend.name}',
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
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(58, 57, 103, 1),
                        onPrimary: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 43, vertical: 5),
                      ),
                      onPressed: !(otpExpired && !endTimeExpired)
                          ? null // Trường hợp 1 và 3: expireTimeOTP hết hạn hoặc endTime hết hạn
                          : () => onPressed?.call(history),
                      child: Text(
                        'Get OTP',
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(58, 57, 103, 1),
                        onPrimary: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      ),
                      onPressed: !(!otpExpired && !endTimeExpired)
                          ? null // Trường hợp 2 và 3: expireTimeOTP hết hạn hoặc endTime hết hạn
                          : () => onReceiveOrderPressed?.call(history),
                      child: Text(
                        'Confirm Took Order',
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
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

// Widget hiển thị danh sách đơn hàng
class OrderUserReceive extends StatefulWidget {
  final AuthStatus authStatus;
  final BuildContext context;

  OrderUserReceive({required this.authStatus, required this.context});

  @override
  _OrderUserReceiveState createState() => _OrderUserReceiveState();
}

class _OrderUserReceiveState extends State<OrderUserReceive> {
  final storage = FlutterSecureStorage();
  List<History> listHistories = [];
  bool isConfirming = false;
  bool isGettingOTP = false;
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

  Future<void> _getOTP(History history) async {
    setState(() {
      isGettingOTP = true; // Đặt trạng thái là đang xử lý
    });
    final token = await storage.read(key: 'token');
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final response = await httpClient
        .postUrl(Uri.parse('$endpoint/api/locker/register/receiver/get'))
        .then((HttpClientRequest request) {
      request.headers.set('Content-Type', 'application/json');
      request.headers.add('Authorization', 'Bearer $token');

      request.write(
          jsonEncode({"historyId": history.historyId}));
      return request.close();
    }).then((HttpClientResponse response) async {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    });
    final responseData = json.decode(response);

    if (responseData['status'] == 'OK') {
      _showSnackBarForSuccessful("Receive order successful");
      setState(() {
        isGettingOTP = false; // Đặt trạng thái lại là false khi xử lý hoàn tất
      });
      loadHistory();
    } else {
      String errorMessage = responseData['errorMessage'];
      _showSnackBarForWarning(errorMessage);
    }
    setState(() {
      isGettingOTP = false; // Đặt trạng thái lại là false khi xử lý hoàn tất
    });
  }

  Future<void> confirmTookOrder(History history) async {
    setState(() {
      isConfirming = true; // Đặt trạng thái là đang xử lý
    });
    final token = await storage.read(key: 'token');
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final response = await httpClient
        .getUrl(Uri.parse('$endpoint/api/locker/register/receiver/get/confirm/${history.historyId}'))
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
      _showSnackBarForSuccessful("Confirm took order successful");
      loadHistory();
    } else {
      String errorMessage = responseData['errorMessage'];
      _showSnackBarForWarning(errorMessage);
    }
    setState(() {
      isConfirming = false; // Đặt trạng thái lại là false khi xử lý hoàn tất
    });
  }

  List<History> filterHistories(List<History> histories, int userIdLoggedIn) {

    // Lọc những lịch sử có onProcedure khác null
    var historiesWithProcedure =
        histories.where((history) => history.onProcedure > 0).toList();

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
      bool endTimeExpired = matchingHistory.endTime.isBefore(DateTime.now());
      // Nếu tìm thấy lịch sử phù hợp và id của lịch sử đó lớn hơn id của lịch sử hiện tại
      if (matchingHistory.historyId != -1 &&
          matchingHistory.historyId > history.historyId &&
          !endTimeExpired) {
        // Thêm lịch sử phù hợp vào danh sách tạm thời
        temporaryHistories.add(matchingHistory);
      }
    }

    // Thêm các lịch sử từ danh sách tạm thời vào danh sách lịch sử chứa các lịch sử có onProcedure là null

    var filteredHistories = temporaryHistories.where((history) =>
        history.userHistory.any((user) =>
            user.role == 'RECEIVER' && user.userId == userIdLoggedIn) &&
        (history.onProcedure > 0));

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

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5), // Màu nền mờ
      child: Center(
        child: CircularProgressIndicator(), // Hình tròn loading
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
                'List Orders Of User Receive',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          isGettingOTP || isConfirming
              ? _buildLoadingOverlay()
              : Positioned(
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  // Remove the Border
                                ),
                                child: HistoryItem(
                                  history: listHistories[index],
                                  onPressed: isGettingOTP
                                      ? null
                                      : (history) => _getOTP(history),
                                  onReceiveOrderPressed: isConfirming
                                      ? null
                                      : (history) => confirmTookOrder(history),
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
