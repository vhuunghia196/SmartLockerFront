// import React, { useEffect, useState } from 'react';
// import { Col, Row, Card, Container, Table, Button, Modal, Form, Alert } from 'react-bootstrap';
// import axios from 'axios';
// import config from 'next.config';
// import { getTokenCookie } from 'utils/auth';
// const UserManagement = () => {
//   const [users, setUsers] = useState([]);
//   const [showModal, setShowModal] = useState(false);
//   const [selectedUser, setSelectedUser] = useState(null);
//   const [selectedRole, setSelectedRole] = useState(null);
//   const [roleError, setRoleError] = useState('');
//   const token = getTokenCookie();
//   useEffect(() => {
//     const fetchUsers = async () => {
//       try {
//         const response = await axios.get(`${config.baseURL}/api/user/all`);
//         const result = response.data;

//         if (result.status === "OK") {
//           const filteredUsers = result.data.filter(user => {
//             return !user.roles.includes('ROLE_ADMIN') && (user.roles.includes('ROLE_USER') || user.roles.includes('ROLE_SHIPPER'));
//           });
//           setUsers(filteredUsers);
//         }
//       } catch (error) {
//         console.error('Error fetching users:', error);
//       }
//     };

//     fetchUsers();
//   }, [users]);

//   const handleShowModal = (user) => {
//     setShowModal(true);
//     setSelectedUser(user);
//     setSelectedRole(null); 
//     setRoleError(''); // Reset roleError when modal opens
//   };

//   const handleAddRole = async () => {
//     if (!selectedRole) {
//       setRoleError('Vui lòng chọn vai trò.');
//       return;
//     }

//     try {
//       const response = await axios.post(
//         `${config.baseURL}/api/user/admin/role/add/${selectedUser.id}/${selectedRole}`,
//         {},
//         {
//           headers: {
//             Authorization: `Bearer ${token}`, // Thêm token vào header Authorization
//           },
//         }
//       );
//       console.log('API response:', response.data);
//       setShowModal(false);
//     } catch (error) {
//       console.error('Error adding role:', error);
//     }
//   };
  
//   return (
//     <Container fluid className="p-6">
//       <Row>
//         <Col xl={12} lg={12} md={12} sm={12}>
//           <div className="border-bottom pb-4 mb-4 d-md-flex align-items-center justify-content-between">
//             <div className="mb-3 mb-md-0">
//               <h1 className="mb-1 h2 fw-bold">Quản lý người dùng</h1>
//               <p className="mb-0">
//                 Quản lý thông tin và quyền truy cập của người dùng.
//               </p>
//             </div>
//           </div>
//         </Col>
//       </Row>

//       <Row>
//         <Col xl={12} lg={12} md={12} sm={12}>
//           <div id="button" className="mb-4">
//             <h3>Danh sách người dùng</h3>
//           </div>
//           <Card.Body className="p-0">
//             <Table striped bordered hover className='user-table-list'>
//               <thead>
//                 <tr>
//                   <th>STT</th>
//                   <th>Tên</th>
//                   <th>Username</th>
//                   <th>Email</th>
//                   <th>SĐT</th>
//                   <th>Vai trò</th>
//                   <th>Hành động</th>
//                 </tr>
//               </thead>
//               <tbody>
//                 {users.map((user, index) => (
//                   <tr key={user.id}>
//                     <td>{index + 1}</td>
//                     <td>{user.name}</td>
//                     <td>{user.username}</td>
//                     <td>{user.email}</td>
//                     <td>{user.phone.replace('+84', '0')}</td>
//                     <td>{user.roles.join(', ')}</td>
//                     <td>
//                       <Button variant="primary" size="sm" className="me-2" onClick={() => handleShowModal(user)}>
//                         Thêm vai trò
//                       </Button>
//                     </td>
//                   </tr>
//                 ))}
//               </tbody>
//             </Table>
//           </Card.Body>
//         </Col>
//       </Row>

//       <Modal show={showModal} onHide={() => setShowModal(false)}>
//         <Modal.Header closeButton>
//           <Modal.Title>Chọn vai trò</Modal.Title>
//         </Modal.Header>
//         <Modal.Body>
//           <Form.Select
//             aria-label="Chọn vai trò"
//             value={selectedRole || ''}
//             onChange={(e) => setSelectedRole(e.target.value)}
//           >
//             <option value="">Chọn vai trò</option>
//             <option value="1">ROLE_ADMIN</option>
//             <option value="3">ROLE_SHIPPER</option>
//           </Form.Select>
//           {roleError && <Alert variant="danger" className="mt-2">{roleError}</Alert>}
//         </Modal.Body>
//         <Modal.Footer>
//           <Button variant="secondary" onClick={() => setShowModal(false)}>
//             Đóng
//           </Button>
//           <Button variant="primary" onClick={handleAddRole}>
//             Lưu thay đổi
//           </Button>
//         </Modal.Footer>
//       </Modal>
//     </Container>
//   );
// };

// export default UserManagement;


import React, { useEffect, useState } from 'react';
import { Col, Row, Card, Container, Table, Button, Modal, Form, Alert } from 'react-bootstrap';
import axios from 'axios';
import config from 'next.config';
import { getTokenCookie } from 'utils/auth';

const UserManagement = () => {
  const [users, setUsers] = useState([]);
  const [showModal, setShowModal] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);
  const [selectedRole, setSelectedRole] = useState(null);
  const [roleError, setRoleError] = useState('');
  const [reloadUsers, setReloadUsers] = useState(false); // State để trigger khi cần reload danh sách người dùng
  const token = getTokenCookie();
  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const response = await axios.get(`${process.env.BASE_URL}/api/user/all`);
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
  }, [reloadUsers]); // Thêm reloadUsers vào dependency array để khi state này thay đổi, useEffect sẽ được gọi lại

  const handleShowModal = (user) => {
    setShowModal(true);
    setSelectedUser(user);
    setSelectedRole(null); 
    setRoleError('');
  };

  const handleAddRole = async () => {
    if (!selectedRole) {
      setRoleError('Vui lòng chọn vai trò.');
      return;
    }

    try {
      const response = await axios.post(
        `${process.env.BASE_URL}/api/user/admin/role/add/${selectedUser.id}/${selectedRole}`,
        {},
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      console.log('API response:', response.data);
      setShowModal(false);
      setReloadUsers(!reloadUsers); // Khi thêm vai trò thành công, trigger để reload lại danh sách người dùng
    } catch (error) {
      console.error('Error adding role:', error);
    }
  };
  
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
          <Card.Body className="p-0">
            <Table striped bordered hover className='user-table-list'>
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
                      <Button variant="primary" size="sm" className="me-2" onClick={() => handleShowModal(user)}>
                        Thêm vai trò
                      </Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </Table>
          </Card.Body>
        </Col>
      </Row>

      <Modal show={showModal} onHide={() => setShowModal(false)}>
        <Modal.Header closeButton>
          <Modal.Title>Chọn vai trò</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form.Select
            aria-label="Chọn vai trò"
            value={selectedRole || ''}
            onChange={(e) => setSelectedRole(e.target.value)}
          >
            <option value="">Chọn vai trò</option>
            <option value="1">ROLE_ADMIN</option>
            <option value="3">ROLE_SHIPPER</option>
          </Form.Select>
          {roleError && <Alert variant="danger" className="mt-2">{roleError}</Alert>}
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={() => setShowModal(false)}>
            Đóng
          </Button>
          <Button variant="primary" onClick={handleAddRole}>
            Lưu thay đổi
          </Button>
        </Modal.Footer>
      </Modal>
    </Container>
  );
};

export default UserManagement;
