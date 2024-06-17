import { useState } from "react";
import { Row, Col, Card, Form, Button, Image, Alert } from "react-bootstrap";
import Link from "next/link";
import AuthLayout from "layouts/AuthLayout";
import { useRouter } from "next/router";
import axios from 'axios';
import config from 'next.config';
import { useAuth } from 'context/AuthContext'
import {setAllAuthCookies} from 'utils/auth'



const SignIn = () => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const router = useRouter();
  const { login, isLoggedIn } = useAuth();
  const [showPassword, setShowPassword] = useState(false);
  const handleUsernameChange = (e) => {
    const value = e.target.value;
    const regex = /^[a-zA-Z0-9]*$/; // only alphanumeric characters
    if (regex.test(value)) {
      setUsername(value);
    } else {
      setError('Tài khoản chỉ được phép chứa chữ cái không dấu và chữ số.');
    }
  };

  const handlePasswordChange = (e) => {
    const value = e.target.value;
    const regex = /^[a-zA-Z0-9!@#$%^&*()_+{}\[\]:;<>,.?~`|=-]*$/; // chấp nhận chữ, số và kí tự đặc biệt
    if (regex.test(value)) {
      setPassword(value);
      setError(''); // Xóa thông báo lỗi nếu người dùng nhập mật khẩu hợp lệ
    } else {
      setError('Mật khẩu chỉ được phép chứa chữ cái, chữ số và kí tự đặc biệt.');
    }
};

  const handleSubmit = async (e) => {
    console.log(isLoggedIn);
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      const response = await axios.post(`${config.baseURL}/api/auth/login`, {
        usernameOrEmail: username,
        password: password,
      });
      const message = response.errorMessage;
      if (response.status === 200) {
        var roles = response.data.data.user.roles;
        var user = response.data.data.user;
        var expirationDuration = response.data.data.expirationDuration;
        var token = response.data.data.accessToken;
        console.log(roles);  
        if (roles.includes('ROLE_ADMIN')) {
          login(user);
          setAllAuthCookies(user, token, expirationDuration);
          router.push('/');
        } else {
          setError('Bạn không có quyền truy cập.');
          setLoading(false);
          return;
        }
      } else {
        // Xử lý lỗi
        setError(response.data.message || 'Đăng nhập không thành công.');
      }
    } catch (error) {
      setError('Sai tài khoản hoặc mật khẩu');
    }
  
    setLoading(false);
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
            </div>
            <Form onSubmit={handleSubmit}>
              {error && <Alert variant="danger">{error}</Alert>}
              <Form.Group className="mb-3" controlId="username">
                <Form.Label>Tài khoản</Form.Label>
                <Form.Control
                  type="text"
                  name="username"
                  placeholder="vhuunghia123"
                  value={username}
                  onChange={handleUsernameChange}
                  required
                />
              </Form.Group>
              {/* <Form.Group className="mb-3" controlId="password">
                <Form.Label>Mật khẩu</Form.Label>
                <Form.Control
                  type="password"
                  name="password"
                  placeholder="**************"
                  value={password}
                  onChange={handlePasswordChange}
                  required
                />
              </Form.Group> */}
              <Form.Group className="mb-3" controlId="password">
                <Form.Label>Mật khẩu</Form.Label>
                <div className="position-relative">
                  <Form.Control
                    type={showPassword ? "text" : "password"} // Kiểm tra trạng thái showPassword để quyết định hiển thị hoặc ẩn mật khẩu
                    name="password"
                    placeholder="**************"
                    value={password}
                    onChange={handlePasswordChange}
                    required
                  />
                  <Button
                    variant="light"
                    className="position-absolute top-50 end-0 translate-middle-y p-0"
                    onClick={() => setShowPassword(!showPassword)} // Khi nút toggle được bấm, cập nhật trạng thái showPassword
                  >
                    {showPassword ? "Ẩn" : "Hiện"}
                  </Button>
                </div>
              </Form.Group>
              <div className="d-grid">
                <Button variant="primary" type="submit" disabled={loading}>
                  {loading ? 'Đang đăng nhập...' : 'Đăng nhập'}
                </Button>
              </div>
              <div className="d-md-flex justify-content-between mt-4">
                <div className="mb-2 mb-md-0">
                  <Link href="/authentication/sign-up" className="fs-5">
                    Đăng ký
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

SignIn.Layout = AuthLayout;

export default SignIn;

//export default withAuthRedirect(SignIn);