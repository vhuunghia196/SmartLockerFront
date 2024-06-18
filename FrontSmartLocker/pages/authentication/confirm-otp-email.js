// import node module libraries
import { Row, Col, Card, Form, Button, Image } from "react-bootstrap";
import Link from "next/link";
import axios from 'axios';

// import authlayout to override default layout
import AuthLayout from "layouts/AuthLayout";
import { getUserCookie } from 'utils/auth'
import { useRouter } from "next/router";
import config from 'next.config';

const ConfirmOTPEmail = () => {
    const router = useRouter();
    const user = getUserCookie();

    const handleSubmit = async (e) => {
        e.preventDefault();
        
        // Lấy giá trị OTP từ trường mẫu
        const otp = e.target.otp.value;
      
        try {
          // Gọi API kiểm tra mã OTP từ máy chủ của bạn
          const response = await axios.post(`${config.baseURL}/api/user/forgot-password/confirm`, { 'otp': otp });
      
          if (response.status === 200) {
            // Xử lý thành công
            console.log('Mã OTP hợp lệ!');
            router.push('/authentication/sign-in')
          }
        } catch (error) {
          console.error('Mã OTP không hợp lệ hoặc đã hết hạn:');
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
                                Gửi OTP để xác nhận email.
                            </p>
                        </div>
                        {/* Form */}
                        <Form onSubmit={handleSubmit}>
                            {/* Email */}
                            <Form.Group className="mb-3" controlId="otp">
                                <Form.Label>Mã OTP</Form.Label>
                                <Form.Control
                                    type="text"
                                    name="otp"
                                    placeholder="Nhập mã OTP"
                                />
                            </Form.Group>
                            {/* Button */}
                            <div className="mb-3 d-grid">
                                <Button variant="primary" type="submit">
                                    Gửi OTP
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

ConfirmOTPEmail.Layout = AuthLayout;

export default ConfirmOTPEmail;
