// import node module libraries
import { Row, Col, Card, Form, Button, Image } from "react-bootstrap";
import Link from "next/link";
import axios from 'axios';
import config from 'next.config';

// import authlayout to override default layout
import AuthLayout from "layouts/AuthLayout";
import { withAuthRedirect } from 'utils/withAuthRedirect';
import {getUserCookie} from 'utils/auth'
import { useRouter } from "next/router";
const ForgetPassword = () => {
  const router = useRouter();
  const user = getUserCookie();

  const handleSubmit = async (e) => {
    e.preventDefault();
  
    // Lấy giá trị email từ trường mẫu
    const email = e.target.email.value;
  
    try {
      // Gọi API gửi email từ máy chủ của bạn
      const response = await axios.post(`${config.baseURL}/api/user/forgot-password`, { 'mail': email, });
  
      if (response.status === 200) {
        
        console.log('Email gửi thành công!');
        router.push('/authentication/confirm-otp-email')
      }
    } catch (error) {
      console.error('Gửi email thất bại:', error);
      // Có thể hiển thị thông báo lỗi cho người dùng ở đây
    }
  };
  
  return (
    <Row className="align-items-center justify-content-center g-0 min-vh-100">
      <Col xxl={4} lg={6} md={8} xs={12} className="py-8 py-xl-0">
        {/* Card */}
        <Card className="smooth-shadow-md">
          {/* Card body */}
          <Card.Body className="p-6">
            <div className="mb-4">
              <Link href="/">
                <Image
                  src="/images/brand/logo/logo-primary.svg"
                  className="mb-2"
                  alt=""
                />
              </Link>
              <p className="mb-6">
                Đừng lo, chúng tôi sẽ gửi email của bạn để lấy lại mật khẩu.
              </p>
            </div>
            {/* Form */}
            <Form onSubmit={handleSubmit}>
              {/* Email */}
              <Form.Group className="mb-3" controlId="email">
                <Form.Label>Email</Form.Label>
                <Form.Control
                  type="email"
                  name="email"
                  placeholder="vhuunghia@gmail.com"
                />
              </Form.Group>
              {/* Button */}
              <div className="mb-3 d-grid">
                <Button variant="primary" type="submit">
                  Lấy lại mật khẩu
                </Button>
              </div>
              <span>
                Bạn đã có tài khoản?{" "}
                <Link href="/authentication/sign-in">Đăng nhập</Link>
              </span>
            </Form>
          </Card.Body>
        </Card>
      </Col>
    </Row>
  );
};

ForgetPassword.Layout = AuthLayout;

export default ForgetPassword;
//export default withAuthRedirect(ForgetPassword);