// import 'package:flutter/material.dart';

// import 'login_screen.dart';

// import 'sign_up.dart';
// class StartScreen extends StatelessWidget {
//   final VoidCallback onLoginPressed;
//   final VoidCallback onSignUpPressed;

//   StartScreen({required this.onLoginPressed, required this.onSignUpPressed});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(
//                 'lib/images/start.jpg'), // Thay đổi đường dẫn hình ảnh theo đúng vị trí tệp của bạn
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: 200.0),
//               Padding(
//                 padding: EdgeInsets.only(
//                     left: 100.0,
//                     top: 0.0,
//                     right: 100.0,
//                     bottom: 0.0), // Đặt giá trị padding cho mỗi hướng
//                 child: Text(
//                   'Welcome to Smart Locker App',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 35.0,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.5,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(height: 150.0),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             SignUpScreen()), // Thay SignUpScreen bằng tên trang bạn muốn chuyển đến
//                   );
//                 },
//                 child: Padding(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 120.0, vertical: 10.0),
//                   child: Text('Start',
//                       style: TextStyle(
//                           fontSize: 18.0, fontWeight: FontWeight.bold)),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.zero,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                   ),
//                   primary: Color.fromRGBO(58, 57, 103, 1),
//                 ),
//               ),

//               SizedBox(height: 20.0),
//               Text('Already have an account?'),
//               ElevatedButton(
//                 onPressed: () {
//                   // Sử dụng PageRouteBuilder để tạo hiệu ứng lướt sang trái
//                   Navigator.push(
//                     context,
//                     PageRouteBuilder(
//                       pageBuilder: (context, animation, secondaryAnimation) =>
//                           LoginScreen(),
//                       transitionsBuilder:
//                           (context, animation, secondaryAnimation, child) {
//                         const begin =
//                             Offset(1.0, 0.0); // Thay đổi từ -1.0 sang 1.0
//                         const end = Offset.zero;
//                         const curve = Curves.easeInOutQuart;

//                         var tween = Tween(begin: begin, end: end)
//                             .chain(CurveTween(curve: curve));
//                         var offsetAnimation = animation.drive(tween);

//                         return SlideTransition(
//                           position: offsetAnimation,
//                           child: child,
//                         );
//                       },
//                       // Độ trễ cho hiệu ứng lướt sang trái
//                       transitionDuration: Duration(milliseconds: 200),
//                     ),
//                   );
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
//                   child: Text(
//                     'Log In',
//                     style: TextStyle(
//                       fontSize: 15.0,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white, // Đặt màu chữ nếu cần
//                     ),
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.zero,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   backgroundColor: Color.fromRGBO(
//                       58, 57, 103, 1), // Đặt màu background của nút
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'sign_up.dart';

class StartScreen extends StatelessWidget {
  final VoidCallback onLoginPressed;
  final VoidCallback onSignUpPressed;

  StartScreen({required this.onLoginPressed, required this.onSignUpPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/start.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Welcome to Smart Locker App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },

                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.25,
                      vertical: 10.0),
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  primary: Color.fromRGBO(58, 57, 103, 1),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Text('Already have an account?'),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          LoginScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
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
                      horizontal: MediaQuery.of(context).size.width * 0.02,
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Color.fromRGBO(58, 57, 103, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
