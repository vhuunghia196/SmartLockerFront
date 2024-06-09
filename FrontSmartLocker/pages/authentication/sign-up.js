// // // import node module libraries
// // import { Row, Col, Card, Form, Button, Image } from "react-bootstrap";
// // import Link from "next/link";

// // // import authlayout to override default layout
// // import AuthLayout from "layouts/AuthLayout";
// // import { withAuthRedirect } from 'utils/withAuthRedirect';
// // import {getUserCookie} from 'utils/auth'
// // import { useRouter } from "next/router";

// // const SignUp = () => {
// //   const router = useRouter();
// //   const user = getUserCookie();

// //   return (
// //     <Row className="align-items-center justify-content-center g-0 min-vh-100">
// //       <Col xxl={4} lg={6} md={8} xs={12} className="py-8 py-xl-0">
// //         {/* Card */}
// //         <Card className="smooth-shadow-md">
// //           {/* Card body */}
// //           <Card.Body className="p-6">
// //             <div className="mb-4">
// //               <Link href="/">
// //                 <Image
// //                   src="/images/brand/logo/logo-primary.svg"
// //                   className="mb-2"
// //                   alt=""
// //                 />
// //               </Link>
// //               <p className="mb-6">Vui lòng nhập thông tin bên dưới.</p>
// //             </div>
// //             {/* Form */}
// //             <Form>
// //               {/* Username */}
// //               <Form.Group className="mb-3" controlId="username">
// //                 <Form.Label>Tài khoản</Form.Label>
// //                 <Form.Control
// //                   type="text"
// //                   name="username"
// //                   placeholder="vhuunghia"
// //                   required=""
// //                 />
// //               </Form.Group>

// //               {/* Email */}
// //               <Form.Group className="mb-3" controlId="email">
// //                 <Form.Label>Email</Form.Label>
// //                 <Form.Control
// //                   type="email"
// //                   name="email"
// //                   placeholder="vhuunghia@gmail.com"
// //                   required=""
// //                 />
// //               </Form.Group>

// //               {/* Password */}
// //               <Form.Group className="mb-3" controlId="password">
// //                 <Form.Label>Mật khẩu</Form.Label>
// //                 <Form.Control
// //                   type="password"
// //                   name="password"
// //                   placeholder="**************"
// //                   required=""
// //                 />
// //               </Form.Group>

// //               {/* Confirm Password */}
// //               <Form.Group className="mb-3" controlId="confirm-password">
// //                 <Form.Label>Xác nhận mật khẩu</Form.Label>
// //                 <Form.Control
// //                   type="password"
// //                   name="confirm-password"
// //                   placeholder="**************"
// //                   required=""
// //                 />
// //               </Form.Group>

// //               <div>
// //                 {/* Button */}
// //                 <div className="d-grid">
// //                   <Button variant="primary" type="submit">
// //                     Create Free Account
// //                   </Button>
// //                 </div>
// //                 <div className="d-md-flex justify-content-between mt-4">
// //                   <div className="mb-2 mb-md-0">
// //                     <Link href="/authentication/sign-in" className="fs-5">
// //                       Đã có tài khoản?{" "}
// //                     </Link>
// //                   </div>
// //                   <div>
// //                     <Link
// //                       href="/authentication/forget-password"
// //                       className="text-inherit fs-5"
// //                     >
// //                       Quên mật khẩu?
// //                     </Link>
// //                   </div>
// //                 </div>
// //               </div>
// //             </Form>
// //           </Card.Body>
// //         </Card>
// //       </Col>
// //     </Row>
// //   );
// // };

// // SignUp.Layout = AuthLayout;

// // export default SignUp;
// // //export default withAuthRedirect(SignUp);


// // import node module libraries
// import { Row, Col, Card, Form, Button, Image, Alert } from "react-bootstrap";
// import Link from "next/link";
// import axios from 'axios';
// import config from 'next.config';
// import { useState } from "react";

// // import authlayout to override default layout
// import AuthLayout from "layouts/AuthLayout";
// import { withAuthRedirect } from 'utils/withAuthRedirect';
// import { getUserCookie } from 'utils/auth';
// import { useRouter } from "next/router";

// const SignUp = () => {
//   const router = useRouter();
//   const user = getUserCookie();

//   const [fullName, setFullName] = useState('');
//   const [username, setUsername] = useState('');
//   const [email, setEmail] = useState('');
//   const [password, setPassword] = useState('');
//   const [confirmPassword, setConfirmPassword] = useState('');
//   const [phoneNumber, setPhoneNumber] = useState('');
//   const [error, setError] = useState('');

//   // Nếu người dùng đã đăng nhập, điều hướng họ ra trang chính
//   // if (user) {
//   //   router.push('/');
//   //   return null;
//   // }

//   const validatePassword = (password) => {
//     const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^a-zA-Z0-9\s]).{8,}$/;
//     return passwordPattern.test(password);
//   };

//   const validatePhoneNumber = (phoneNumber) => {
//     const phonePattern = /^0\d{9}$/;
//     return phonePattern.test(phoneNumber);
//   };

//   const handleSubmit = async (e) => {
//     e.preventDefault();

//     // Kiểm tra xem mật khẩu và xác nhận mật khẩu có khớp không
//     if (password !== confirmPassword) {
//       setError('Mật khẩu và xác nhận mật khẩu không khớp.');
//       return;
//     }

//     // Kiểm tra xem mật khẩu có đáp ứng yêu cầu không
//     if (!validatePassword(password)) {
//       setError('Mật khẩu phải chứa ít nhất một chữ hoa, một chữ thường, một ký tự đặc biệt và một số.');
//       return;
//     }

//     // Kiểm tra xem số điện thoại có hợp lệ không
//     if (!validatePhoneNumber(phoneNumber)) {
//       setError('Số điện thoại không hợp lệ. Số điện thoại phải bắt đầu bằng số 0 và có độ dài 10 chữ số.');
//       return;
//     }

//     try {
//       // Gọi API đăng ký từ máy chủ của bạn
//       const response = await axios.post(
//         `${config.baseURL}/api/user/signup`,
//         {
//           'name': fullName,
//         'password': password,
//         'username': username,
//         'email': email,
//         'phone': phone,
//         }
//       );

//       if (response.status === 200) {
//         console.log('Đăng ký thành công!');
//         router.push('/authentication/sign-in');
//       }
//     } catch (error) {
//       console.error('Đăng ký thất bại:', error);
//       setError('Đăng ký thất bại. Vui lòng thử lại.');
//     }
//   };

//   return (
//     <Row className="align-items-center justify-content-center g-0 min-vh-100">
//       <Col xxl={4} lg={6} md={8} xs={12} className="py-8 py-xl-0">
//         {/* Card */}
//         <Card className="smooth-shadow-md">
//           {/* Card body */}
//           <Card.Body className="p-6">
//             <div className="mb-4">
//               <Link href="/">
//                 <Image
//                   src="/images/brand/logo/logo-primary.svg"
//                   className="mb-2"
//                   alt=""
//                 />
//               </Link>
//               <p className="mb-6">Vui lòng nhập thông tin bên dưới.</p>
//             </div>
//             {/* Form */}
//             <Form onSubmit={handleSubmit}>
//               {error && <Alert variant="danger">{error}</Alert>}
//               {/* Full Name */}
//               <Form.Group className="mb-3" controlId="fullName">
//                 <Form.Label>Họ và tên</Form.Label>
//                 <Form.Control
//                   type="text"
//                   name="fullName"
//                   placeholder="Họ và tên"
//                   required=""
//                   value={fullName}
//                   onChange={(e) => setFullName(e.target.value)}
//                 />
//               </Form.Group>

//               {/* Username */}
//               <Form.Group className="mb-3" controlId="username">
//                 <Form.Label>Tài khoản</Form.Label>
//                 <Form.Control
//                   type="text"
//                   name="username"
//                   placeholder="User Name"
//                   required=""
//                   value={username}
//                   onChange={(e) => setUsername(e.target.value)}
//                 />
//               </Form.Group>

//               {/* Email */}
//               <Form.Group className="mb-3" controlId="email">
//                 <Form.Label>Email</Form.Label>
//                 <Form.Control
//                   type="email"
//                   name="email"
//                   placeholder="Enter address here"
//                   required=""
//                   value={email}
//                   onChange={(e) => setEmail(e.target.value)}
//                 />
//               </Form.Group>

//               {/* Phone Number */}
//               <Form.Group className="mb-3" controlId="phoneNumber">
//                 <Form.Label>Số điện thoại</Form.Label>
//                 <Form.Control
//                   type="tel"
//                   name="phoneNumber"
//                   placeholder="Số điện thoại"
//                   required=""
//                   value={phoneNumber}
//                   onChange={(e) => setPhoneNumber(e.target.value)}
//                 />
//               </Form.Group>

//               {/* Password */}
//               <Form.Group className="mb-3" controlId="password">
//                 <Form.Label>Mật khẩu</Form.Label>
//                 <Form.Control
//                   type="password"
//                   name="password"
//                   placeholder="**************"
//                   required=""
//                   value={password}
//                   onChange={(e) => setPassword(e.target.value)}
//                 />
//               </Form.Group>

//               {/* Confirm Password */}
//               <Form.Group className="mb-3" controlId="confirm-password">
//                 <Form.Label>Xác nhận mật khẩu</Form.Label>
//                 <Form.Control
//                   type="password"
//                   name="confirm-password"
//                   placeholder="**************"
//                   required=""
//                   value={confirmPassword}
//                   onChange={(e) => setConfirmPassword(e.target.value)}
//                 />
//               </Form.Group>

//               <div>
//                 {/* Button */}
//                 <div className="d-grid">
//                   <Button variant="primary" type="submit">
//                     Create Free Account
//                   </Button>
//                 </div>
//                 <div className="d-md-flex justify-content-between mt-4">
//                   <div className="mb-2 mb-md-0">
//                     <Link href="/authentication/sign-in" className="fs-5">
//                       Đã có tài khoản?{" "}
//                     </Link>
//                   </div>
//                   <div>
//                     <Link
//                       href="/authentication/forget-password"
//                       className="text-inherit fs-5"
//                     >
//                       Quên mật khẩu?
//                     </Link>
//                   </div>
//                 </div>
//               </div>
//             </Form>
//           </Card.Body>
//         </Card>
//       </Col>
//     </Row>
//   );
// };

// SignUp.Layout = AuthLayout;

// export default SignUp;
import { Row, Col, Card, Form, Button, Image, Alert } from "react-bootstrap";
import Link from "next/link";
import { useState } from "react";

import AuthLayout from "layouts/AuthLayout";
import { getUserCookie } from 'utils/auth';
import { useRouter } from "next/router";
import axios from 'axios';
import config from 'next.config';

const SignUp = () => {
  const router = useRouter();
  const user = getUserCookie();

  const [fullName, setFullName] = useState('');
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [phoneNumber, setPhoneNumber] = useState('');
  const [error, setError] = useState('');

  const validatePassword = (password) => {
    const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^a-zA-Z0-9\s]).{8,}$/;
    return passwordPattern.test(password);
  };

  const validatePhoneNumber = (phoneNumber) => {
    const phonePattern = /^0\d{9}$/;
    return phonePattern.test(phoneNumber);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (password !== confirmPassword) {
      setError('Mật khẩu và xác nhận mật khẩu không khớp.');
      return;
    }

    if (!validatePassword(password)) {
      setError('Mật khẩu phải chứa ít nhất một chữ hoa, một chữ thường, một ký tự đặc biệt và một số.');
      return;
    }

    if (!validatePhoneNumber(phoneNumber)) {
      setError('Số điện thoại không hợp lệ. Số điện thoại phải bắt đầu bằng số 0 và có độ dài 10 chữ số.');
      return;
    }

    try {
      const response = await axios.post(
        `${config.baseURL}/api/auth/signup`,
        {
          'name': fullName,
          'password': password,
          'username': username,
          'email': email,
          'phone': phoneNumber,
        }
      );
      var message = response.errorMessage;
      if (response.status === 200) {
        console.log('Đăng ký thành công!');
        router.push('/authentication/sign-in');
      }
    } catch (error) {
      console.log(message);
      console.error('Đăng ký thất bại:', error);
      setError('Đăng ký thất bại. Vui lòng thử lại.');
    }
  };

  return (
    <Row className="align-items-center justify-content-center g-0 min-vh-100">
      <Col xxl={4} lg={6} md={8} xs={12} className="py-8 py-xl-0">
        <Card className="smooth-shadow-md">
          <Card.Body className="p-6">
            <div className="mb-4">
              <Link href="/">
                <Image
                  src="/images/brand/logo/logo-primary.svg"
                  className="mb-2"
                  alt=""
                />
              </Link>
              <p className="mb-6">Vui lòng nhập thông tin bên dưới.</p>
            </div>
            <Form onSubmit={handleSubmit}>
              {error && <Alert variant="danger">{error}</Alert>}
              <Form.Group className="mb-3" controlId="fullName">
                <Form.Label>Họ và tên</Form.Label>
                <Form.Control
                  type="text"
                  name="fullName"
                  placeholder="Họ và tên"
                  required=""
                  value={fullName}
                  onChange={(e) => setFullName(e.target.value)}
                />
              </Form.Group>
              <Form.Group className="mb-3" controlId="username">
                <Form.Label>Tài khoản</Form.Label>
                <Form.Control
                  type="text"
                  name="username"
                  placeholder="User Name"
                  required=""
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                />
              </Form.Group>
              <Form.Group className="mb-3" controlId="email">
                <Form.Label>Email</Form.Label>
                <Form.Control
                  type="email"
                  name="email"
                  placeholder="Enter address here"
                  required=""
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                />
              </Form.Group>
              <Form.Group className="mb-3" controlId="phoneNumber">
                <Form.Label>Số điện thoại</Form.Label>
                <Form.Control
                  type="tel"
                  name="phoneNumber"
                  placeholder="Số điện thoại"
                  required=""
                  value={phoneNumber}
                  onChange={(e) => setPhoneNumber(e.target.value)}
                />
              </Form.Group>
              <Form.Group className="mb-3" controlId="password">
                <Form.Label>Mật khẩu</Form.Label>
                <Form.Control
                  type="password"
                  name="password"
                  placeholder="**************"
                  required=""
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                />
              </Form.Group>
              <Form.Group className="mb-3" controlId="confirm-password">
                <Form.Label>Xác nhận mật khẩu</Form.Label>
                <Form.Control
                  type="password"
                  name="confirm-password"
                  placeholder="**************"
                  required=""
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                />
              </Form.Group>
              <div className="d-grid">
                <Button variant="primary" type="submit">
                  Tạo tài khoản miễn phí
                </Button>
              </div>
              <div className="d-md-flex justify-content-between mt-4">
                <div className="mb-2 mb-md-0">
                  <Link href="/authentication/sign-in" className="fs-5">
                    Đã có tài khoản?{" "}
                  </Link>
                </div>
                <div>
                  <Link
                    href="/authentication/forget-password"
                    className="text-inherit fs-5"
                  >
                    Quên mật khẩu?
                  </Link>
                </div>
              </div>
            </Form>
          </Card.Body>
        </Card>
      </Col>
      </Row>
  );
};

SignUp.Layout = AuthLayout;

export default SignUp;
