import 'package:flutter/material.dart';
import 'package:smart_locker/ChangePassWord.dart';
import 'package:smart_locker/EditProfileScreen.dart';
import 'package:smart_locker/models.dart';
import 'package:smart_locker/order_user_receive.dart';
import 'login_screen.dart';
import 'order-locker.dart';
import 'order.dart';
import 'start.dart';

void main() => runApp(MyApp(authStatus: null));

class MyApp extends StatelessWidget {
  final AuthStatus? authStatus; // Sử dụng '?' để cho phép giá trị null

  MyApp({this.authStatus});

  @override
  Widget build(BuildContext context) {
    final effectiveAuthStatus = authStatus ??
        AuthStatus(
          false,
          User.defaultUser(),
        );

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Rubik', // Sử dụng tên gia đình font chữ ở đây
      ),
      home: StartScreen(
        onLoginPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(authStatus: effectiveAuthStatus),
            ),
          );
        },
        onSignUpPressed: () {
          // Xử lý khi người dùng nhấn nút "Đăng ký"
          // (Bạn có thể thêm mã để điều hướng đến trang đăng ký ở đây)
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final AuthStatus authStatus; // Thêm tham số authStatus

  HomeScreen(
      {required this.authStatus}); // Sử dụng {} để đặt tham số là optional

  @override
  _HomeScreenState createState() => _HomeScreenState(authStatus: authStatus);
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Sử dụng để theo dõi mục đang được chọn trong menu
  bool _showBackButton = false; // Để ẩn/hiện nút quay về
  final AuthStatus authStatus; // Thêm tham số authStatus
  final List<Widget> _children;
  bool isReserveButtonEnabled = true;
  final List<String> _labels = ['Home', 'Register', 'Confirm', 'Account'];

  double _selectedIconSize = 28.0;
  double _unselectedIconSize = 20.0;
  _HomeScreenState({required this.authStatus})
      : _children = [
          Home(authStatus: authStatus), // Trang chủ
          Reserve(
              authStatus:
                  authStatus), // Đặt tủ và truyền authStatus vào đây nếu roleId khác 3
          Order(authStatus: authStatus),
          AccountPage(authStatus: authStatus)
        ];

  void onTabTapped(int index) {
    setState(() {
      if (index == 3) {
        // Nếu người dùng chọn tab "Account"
        if (widget.authStatus.isLoggedIn) {
          // Nếu người dùng đã đăng nhập, chuyển đến trang tài khoản
          _currentIndex = index;
          _showBackButton = false;
        } else {
          // Nếu người dùng chưa đăng nhập, chuyển đến màn hình đăng nhập
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        }
      } else {
        // Nếu người dùng chọn các tab khác
        _currentIndex = index;
        _showBackButton = false;
      }
    });
  }

  void onLogout() {
    // Xử lý khi đăng xuất
    widget.authStatus.logout(); // Đăng xuất người dùng
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyApp(authStatus: widget.authStatus),
      ),
    );
    setState(() {
      _showBackButton = false; // Ẩn nút quay về sau khi đăng xuất
    });
  }

  void onLoginSuccess() {
    // Xử lý khi đăng nhập thành công
    setState(() {
      _showBackButton =
          true; // Hiển thị nút quay về sau khi đăng nhập thành công
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Locker'),
        backgroundColor: Color.fromARGB(255, 46, 46, 78),

        automaticallyImplyLeading: _showBackButton, // Ẩn/hiện nút quay về
      ),
      //body: _children[_currentIndex],
      // body: Container(
      //   color: Color.fromRGBO(251, 247, 239, 1.0), // Đặt màu nền cho body
      //   child: _children[_currentIndex],
      // ),
      body: Container(
        color: Color.fromRGBO(251, 247, 239, 1.0), // Đặt màu nền cho body
        child: WillPopScope(
          onWillPop: () async {
            if (widget.authStatus.isLoggedIn) {
              // Nếu người dùng đã đăng nhập, không cho phép quay lại
              return false;
            }
            return true;
          },
          child: _children[_currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  size: _currentIndex == 0
                      ? _selectedIconSize
                      : _unselectedIconSize),
              label: _labels[0],
              backgroundColor: Color.fromRGBO(251, 247, 239, 1.0)),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart,
                  size: _currentIndex == 1
                      ? _selectedIconSize
                      : _unselectedIconSize),
              label: _labels[1],
              backgroundColor: Color.fromRGBO(251, 247, 239, 1.0)),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag,
                size: _currentIndex == 2
                    ? _selectedIconSize
                    : _unselectedIconSize),
            label: _labels[2],
            backgroundColor: Color.fromRGBO(251, 247, 239, 1.0),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  size: _currentIndex == 3
                      ? _selectedIconSize
                      : _unselectedIconSize),
              label: _labels[3],
              backgroundColor: Color.fromRGBO(251, 247, 239, 1.0)),
        ],
        selectedFontSize: 15.0,

        unselectedFontSize: 12.0,
        selectedItemColor: Color.fromARGB(255, 46, 46, 78),
        unselectedItemColor: Color.fromARGB(255, 193, 193, 193),
        //iconSize: 28,
        showUnselectedLabels: true,
        showSelectedLabels: true,
      ),
    );
  }
}

class Home extends StatelessWidget {
  final AuthStatus authStatus; // Thêm thuộc tính authStatus

  Home({required this.authStatus}); // Sử dụng constructor để nhận authStatus

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(251, 247, 239, 1.0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Welcome to Smart Locker App!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(58, 57, 103, 1)
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Image.network(
              'https://channel.mediacdn.vn/2021/12/3/photo-1-16385250090851358667729.jpg',
              height: 200, // Set the height as per your requirement
              fit: BoxFit.cover, // Adjust the image's fit
            ),
            SizedBox(height: 20), // Add some space between text and image
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Welcome to our locker storage system, where organization meets security, offering a seamless solution for keeping your belongings safe and accessible.',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.justify,
              ),
            ),
            // Add more widgets as needed
          ],
        ),
      ),
    );
  }
}

class Reserve extends StatelessWidget {
  final AuthStatus authStatus; // Thêm tham số authStatus

  Reserve({required this.authStatus}); // Sử dụng {} để đặt tham số là optional

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(
                  255, 46, 46, 78), // Đặt màu nền của nút là màu đỏ
              onPrimary: Colors.white, // Đặt màu chữ trên nút là màu trắng
            ),
            onPressed: !authStatus.user.roles.contains("ROLE_SHIPPER")
                ? () {
                    // Xử lý khi người dùng bấm nút (điều này chỉ xảy ra khi role không phải là 3)
                    if (authStatus.isLoggedIn) {
                      // Đã đăng nhập, chuyển đến OrderLocker
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderLocker(authStatus: authStatus),
                        ),
                      );
                    } else {
                      // Chưa đăng nhập, chuyển đến LoginScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    }
                  }
                : null, // Đặt onPressed thành null khi role là 3
            child: Text(
              'Register Locker',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15, // You can adjust the font size as needed
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(
                  255, 46, 46, 78), // Đặt màu nền của nút là màu đỏ
              onPrimary: Colors.white, // Đặt màu chữ trên nút là màu trắng
            ),
            onPressed: () {
              // Điều hướng đến màn hình đăng nhập khi nút được nhấn
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            child: Text('Bắt đầu đăng nhập'),
          ),
        ],
      ),
    );
  }
}

class Order extends StatelessWidget {
  final AuthStatus authStatus;
  Order({required this.authStatus});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(
                  255, 46, 46, 78), // Đặt màu nền của nút là màu đỏ
              onPrimary: Colors.white, // Đặt màu chữ trên nút là màu trắng
            ),
            onPressed: () {
              if (authStatus.isLoggedIn &&
                  authStatus.user.roles.contains("ROLE_SHIPPER")) {
                // Đã đăng nhập, chuyển đến OrderLocker
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OrderList(authStatus: authStatus, context: context),
                  ),
                );
              } else {
                // Chưa đăng nhập, chuyển đến LoginScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderUserReceive(
                        authStatus: authStatus, context: context),
                  ),
                );
              }
            },
            child: Text(
              'All Orders',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15, // You can adjust the font size as needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  final AuthStatus authStatus;

  AccountPage({required this.authStatus});

  // @override
  // Widget build(BuildContext context) {
  //   // Lấy kích thước màn hình
  //   double screenWidth = MediaQuery.of(context).size.width;

  //   // Tính toán margin cho widget thứ hai
  //   double secondWidgetMargin = (screenWidth - 220.0) /
  //       2; // 220 là tổng kích thước của widget trước đó và margin cần thêm vào

  //   return Scaffold(
  //     body: Container(
  //       padding: EdgeInsets.all(20.0),
  //       color: Color.fromRGBO(251, 247, 239, 1),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _buildUserInfo('Name', authStatus.user.name),
  //           _buildDivider(),
  //           _buildUserInfo('Email', authStatus.user.email),
  //           _buildDivider(),
  //           _buildUserInfo('Phone', authStatus.user.phone),
  //           _buildDivider(),
  //           Container(
  //             margin: EdgeInsets.only(
  //                 left: 110.0,
  //                 right: secondWidgetMargin), // Thêm margin bên phải
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 _buildLogoutButton(context),
  //                 SizedBox(width: 50.0),
  //                 _buildChangePasswordButton(context),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        color: Color.fromRGBO(251, 247, 239, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo('Name', authStatus.user.name),
            _buildDivider(),
            _buildUserInfo('Email', authStatus.user.email),
            _buildDivider(),
            _buildUserInfo('Phone', authStatus.user.phone),
            _buildDivider(),
            Center(
              // Center align the buttons
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLogoutButton(context),
                  SizedBox(height: 0.0),
                  _buildChangePasswordButton(context),
                  SizedBox(height: 0.0),
                  _buildChangeInfo(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 0.0), // Khoảng cách bên phải
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 46, 46, 78),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 46, 46, 78),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 2,
      color: Color.fromRGBO(244, 238, 226, 1),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    void onLogout() {
      // Xử lý khi đăng xuất
      authStatus.logout(); // Đăng xuất người dùng
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyApp(authStatus: authStatus),
        ),
      );
    }

    return ElevatedButton(
      onPressed: () {
        // Điều hướng đến màn hình đăng nhập khi nút đăng xuất được nhấn
        onLogout();
      },
      style: ElevatedButton.styleFrom(
        primary: Color.fromARGB(255, 46, 46, 78),
      ),
      child: Text(
        'Logout',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Điều hướng đến màn hình đổi mật khẩu khi nút đổi mật khẩu được nhấn
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePasswordScreen(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Color.fromARGB(255, 46, 46, 78),
      ),
      child: Text(
        'Change Password',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildChangeInfo(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Điều hướng đến màn hình đổi mật khẩu khi nút đổi mật khẩu được nhấn
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfileScreen(authStatus: authStatus),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Color.fromARGB(255, 46, 46, 78),
      ),
      child: Text(
        'Change Infomations',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
