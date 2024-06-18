
import { Row, Col, Card, Form, Button, Image, InputGroup, Alert } from "react-bootstrap";
import Link from "next/link";
import axios from 'axios';
import config from 'next.config';
import { useState } from "react";

// import authlayout to override default layout
import AuthLayout from "layouts/AuthLayout";
import { getTokenCookie } from 'utils/auth';
import { useRouter } from "next/router";

const ChangePassword = () => {
  const router = useRouter();
  const token = getTokenCookie();
  const [oldPassword, setOldPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [showOldPassword, setShowOldPassword] = useState(false);
  const [showNewPassword, setShowNewPassword] = useState(false);
  const [error, setError] = useState('');
  const handleSubmit = async (e) => {
    e.preventDefault();

    const passwordPattern = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[^a-zA-Z0-9\s]).{8,}$/;
    
    if (!passwordPattern.test(newPassword)) {
        setError('Mật khẩu mới phải chứa ít nhất một chữ cái, một số, một ký tự đặc biệt và không chứa chữ có dấu.');
      return;
    }

    try {
      // Gọi API thay đổi mật khẩu từ máy chủ của bạn
      const response = await axios.post(
        `${config.baseURL}/api/user/change-password`,
        {
          oldPass: oldPassword,
          newPass: newPassword
        },
        {
          headers: {
            'Authorization': `Bearer ${token}`
          }
        }
      );

      if (response.status === 200) {
        console.log('Mật khẩu đã được thay đổi thành công!');
        router.push('/');
      }
    } catch (error) {
      setError('Sai mật khẩu. Vui lòng thử lại.');
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
                Nhập mật khẩu cũ và mật khẩu mới để thay đổi mật khẩu của bạn.
              </p>
            </div>
            {/* Form */}
            <Form onSubmit={handleSubmit}>
            {error && <Alert variant="danger">{error}</Alert>}
              {/* Old Password */}
              <Form.Group className="mb-3" controlId="oldPassword">
                <Form.Label>Mật khẩu cũ</Form.Label>
                <InputGroup>
                  <Form.Control
                    type={showOldPassword ? "text" : "password"}
                    name="oldPassword"
                    placeholder="Nhập mật khẩu cũ"
                    value={oldPassword}
                    onChange={(e) => setOldPassword(e.target.value)}
                  />
                  <Button variant="outline-secondary" onClick={() => setShowOldPassword(!showOldPassword)}>
                    {showOldPassword ? "Ẩn" : "Hiện"}
                  </Button>
                </InputGroup>
              </Form.Group>
              {/* New Password */}
              <Form.Group className="mb-3" controlId="newPassword">
                <Form.Label>Mật khẩu mới</Form.Label>
                <InputGroup>
                  <Form.Control
                    type={showNewPassword ? "text" : "password"}
                    name="newPassword"
                    placeholder="Nhập mật khẩu mới"
                    value={newPassword}
                    onChange={(e) => setNewPassword(e.target.value)}
                  />
                  <Button variant="outline-secondary" onClick={() => setShowNewPassword(!showNewPassword)}>
                    {showNewPassword ? "Ẩn" : "Hiện"}
                  </Button>
                </InputGroup>
              </Form.Group>
              {/* Button */}
              <div className="mb-3 d-grid">
                <Button variant="primary" type="submit">
                  Thay đổi mật khẩu
                </Button>
              </div>
            </Form>
          </Card.Body>
        </Card>
      </Col>
    </Row>
  );
};

ChangePassword.Layout = AuthLayout;

export default ChangePassword;
//export default withAuthRedirect(ChangePassword);
