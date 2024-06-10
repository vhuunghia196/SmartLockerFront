// import node module libraries
import React, { useEffect, useState } from 'react';
import { Col, Row, Card, Breadcrumb, Nav, Tab, Container, Table, Button } from 'react-bootstrap';

import axios from 'axios';
import config from 'next.config';
const UserManagement = () => {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const response = await axios.get(`${config.baseURL}/api/user/all`); 
        const result = response.data;

        if (result.status === "OK") {
          const filteredUsers = result.data.filter(user => {
            return !user.roles.includes('ROLE_ADMIN') && (user.roles.includes('ROLE_USER') || user.roles.includes('ROLE_SHIPPER'));
          });
          setUsers(filteredUsers);
        }
      } catch (error) {
        console.error('Error fetching users:', error);
      }
    };

    fetchUsers();
  }, []);

  return (
    <Container fluid className="p-6">
      <Row>
        <Col xl={12} lg={12} md={12} sm={12}>
          <div className="border-bottom pb-4 mb-4 d-md-flex align-items-center justify-content-between">
            <div className="mb-3 mb-md-0">
              <h1 className="mb-1 h2 fw-bold">Quản lý người dùng</h1>
              <p className="mb-0">
                Quản lý thông tin và quyền truy cập của người dùng.
              </p>
            </div>
          </div>
        </Col>
      </Row>

      <Row>
        <Col xl={12} lg={12} md={12} sm={12}>
          <div id="button" className="mb-4">
            <h3>Danh sách người dùng</h3>
          </div>
          <Tab.Container defaultActiveKey="all">
           
              <Card.Body className="p-0">
                <Tab.Content>
                  <Tab.Pane eventKey="all" className="pb-4 p-4">
                    <Table striped bordered hover>
                      <thead>
                        <tr>
                          <th>STT</th>
                          <th>Tên</th>
						  <th>Username</th>
                          <th>Email</th>
						  <th>SĐT</th>
                          <th>Vai trò</th>
                          <th>Hành động</th>
                        </tr>
                      </thead>
                      <tbody>
                        {users.map((user, index) => (
                          <tr key={user.id}>
                            <td>{index + 1}</td>
                            <td>{user.name}</td>
							<td>{user.username}</td>
                            <td>{user.email}</td>
							<td>{user.phone.replace('+84', '0')}</td>
                            <td>{user.roles.join(', ')}</td>
                            <td>
                              <Button variant="primary" size="sm" className="me-2">Chỉnh sửa</Button>
                              <Button variant="danger" size="sm">Xóa</Button>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </Table>
                    <Button variant="success" className="mt-3">Thêm người dùng mới</Button>
                  </Tab.Pane>
                </Tab.Content>
              </Card.Body>
          </Tab.Container>
        </Col>
      </Row>
    </Container>
  );
};

export default UserManagement;
