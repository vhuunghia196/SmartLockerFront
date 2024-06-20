// // import node module libraries
// import React, { useEffect, useState } from 'react';
// import { Col, Row, Card, Tab, Container, Table, Button, Modal, Form } from 'react-bootstrap';

// import axios from 'axios';
// import config from 'next.config';

// const LockerManagement = () => {
//     const [lockers, setLockers] = useState([]);
//     const [showModal, setShowModal] = useState(false);
//     const [locations, setLocations] = useState([]);
//     const [selectedLocation, setSelectedLocation] = useState('');

//     useEffect(() => {
//         // lấy địa điểm
//         fetchLocations();
//         // lấy tủ
//         fetchLockers();
//     }, []);
//     const fetchLocations = async () => {
//         try {
//             const response = await axios.get(`${config.baseURL}/api/location/all`);
//             const result = response.data;

//             if (result.status === "OK") {
//                 setLocations(result.data);
//             }
//         } catch (error) {
//             console.error('Error fetching locations:', error);
//         }
//     };
//     const fetchLockers = async () => {
//         try {
//             const response = await axios.get(`${config.baseURL}/api/locker/all`);
//             const result = response.data;

//             if (result.status === "OK") {
//                 setLockers(result.data);
//             }
//         } catch (error) {
//             console.error('Error fetching lockers:', error);
//         }
//     };
//     const openModal = () => {
//         setShowModal(true);
//     };

//     const closeModal = () => {
//         setShowModal(false);
//     };

//     const handleSaveLocker = () => {
//         // Xử lý lưu thông tin tủ mới vào cơ sở dữ liệu
//         // Sau khi lưu xong, đóng modal và làm mới danh sách tủ đồ
//         closeModal();
//         fetchLockers();
//     };
//     return (
//         <Container fluid className="p-6">
//             <Row>
//                 <Col xl={12} lg={12} md={12} sm={12}>
//                     <div className="border-bottom pb-4 mb-4 d-md-flex align-items-center justify-content-between">
//                         <div className="mb-3 mb-md-0">
//                             <h1 className="mb-1 h2 fw-bold">Quản lý tủ đồ</h1>
//                             <p className="mb-0">
//                                 Quản lý thông tin và trạng thái của tủ đồ.
//                             </p>
//                         </div>
//                     </div>
//                 </Col>
//             </Row>

//             <Row>
//                 <Col xl={12} lg={12} md={12} sm={12}>
//                     <div id="button" className="mb-4">
//                         <h3>Danh sách tủ đồ</h3>
//                     </div>
//                     <Tab.Container defaultActiveKey="all">
//                         <Card.Body className="p-0">
//                             <Tab.Content>
//                                 <Tab.Pane eventKey="all" className="pb-4 p-4">
//                                     <Table striped bordered hover className="locker-table-list">
//                                         <thead>
//                                             <tr>
//                                                 <th>STT</th>
//                                                 <th>Tên tủ</th>
//                                                 <th>Vị trí</th>
//                                                 <th>Trạng thái</th>
//                                                 <th>Hành động</th>
//                                             </tr>
//                                         </thead>
//                                         <tbody>
//                                             {lockers.map((locker, index) => (
//                                                 <tr key={locker.id}>
//                                                     <td>{index + 1}</td>
//                                                     <td>{locker.lockerName}</td>
//                                                     <td>{locker.lockerLocation.location}</td>
//                                                     <td>{locker.status ? "Đang sử dụng" : "Trống"}</td>
//                                                     <td>
//                                                         <Button variant="primary" size="sm" className="me-2">Chỉnh sửa</Button>
//                                                         <Button variant="danger" size="sm">Xóa</Button>
//                                                     </td>
//                                                 </tr>
//                                             ))}
//                                         </tbody>
//                                     </Table>
//                                     <Button variant="success" className="mt-3" onClick={openModal}>Thêm tủ đồ mới</Button>
//                                 </Tab.Pane>
//                             </Tab.Content>
//                         </Card.Body>
//                     </Tab.Container>
//                 </Col>
//             </Row>
//             <Modal show={showModal} onHide={closeModal}>
//                 <Modal.Header closeButton>
//                     <Modal.Title>Thêm tủ đồ mới</Modal.Title>
//                 </Modal.Header>
//                 <Modal.Body>
//                     <Form>
//                         <Form.Group className="mb-3" controlId="formLockerName">
//                             <Form.Label>Tên tủ</Form.Label>
//                             <Form.Control type="text" placeholder="Nhập tên tủ" />
//                         </Form.Group>
//                         <Form.Group className="mb-3" controlId="formLockerLocation">
//                             <Form.Label>Vị trí</Form.Label>
//                             <Form.Select value={selectedLocation} onChange={(e) => setSelectedLocation(e.target.value)}>
//                                 <option value="">Chọn địa điểm</option>
//                                 {locations.map((location) => (
//                                     <option key={location.locationId} value={location.locationId}>
//                                         {location.location}
//                                     </option>
//                                 ))}
//                             </Form.Select>
//                         </Form.Group>
//                         {/* Thêm các trường nhập thông tin khác nếu cần */}
//                     </Form>
//                 </Modal.Body>
//                 <Modal.Footer>
//                     <Button variant="secondary" onClick={closeModal}>
//                         Hủy
//                     </Button>
//                     <Button variant="primary" onClick={handleSaveLocker}>
//                         Lưu
//                     </Button>
//                 </Modal.Footer>
//             </Modal>
//         </Container>
//     );
// };

// export default LockerManagement;

// import React, { useEffect, useState } from 'react';
// import { Col, Row, Card, Tab, Container, Table, Button, Modal, Form } from 'react-bootstrap';
// import axios from 'axios';
// import config from 'next.config';
// import { getTokenCookie } from 'utils/auth';
// import Notification from 'utils/alert';
// const LockerManagement = () => {
//     const [lockers, setLockers] = useState([]);
//     const [showModal, setShowModal] = useState(false);
//     const [locations, setLocations] = useState([]);
//     const [selectedLocation, setSelectedLocation] = useState('');
//     const [currentLocker, setCurrentLocker] = useState(null);
//     const [lockerToDelete, setLockerToDelete] = useState(null);
//     const [lockerAdd, setLockerAdd] = useState(null);
//     const [showDeleteModal, setShowDeleteModal] = useState(false);
//     const [showAddModal, setShowAddModal] = useState(false);
//     const [notificationMessage, setNotificationMessage] = useState('');
//     const token = getTokenCookie();

//     useEffect(() => {
//         // Lấy địa điểm
//         fetchLocations();
//         // Lấy tủ
//         fetchLockers();
//     }, []);

//     const fetchLocations = async () => {
//         try {
//             const response = await axios.get(`${process.env.BASE_URL}/api/location/all`);
//             const result = response.data;

//             if (result.status === "OK") {
//                 setLocations(result.data);
//             }
//         } catch (error) {
//             console.error('Error fetching locations:', error);
//         }
//     };

//     const fetchLockers = async () => {
//         try {
//             const response = await axios.get(`${process.env.BASE_URL}/api/locker/all`);
//             const result = response.data;

//             if (result.status === "OK") {
//                 setLockers(result.data);
//             }
//         } catch (error) {
//             console.error('Error fetching lockers:', error);
//         }
//     };

//     const openAddModal = () => {
//         setShowAddModal(true);
//     };

//     const closeAddModal = () => {
//         setShowAddModal(false);
//         setSelectedLocation('');
//     };

//     const handleSaveLocker = async () => {
//         try {
//             const response = await axios.post(`${process.env.BASE_URL}/api/locker/add`, {
//                 "lockerName": lockerAdd.lockerName,
//                 "isOccupied": false,
//                 "lockerLocation": {
//                     "locationId": lockerAdd.lockerLocation.locationId,
//                     "location": lockerAdd.lockerLocation.location
//                 }
//             }, {
//                 headers: {
//                     Authorization: `Bearer ${token}`
//                 }
//             });
//             const result = response.data;

//             if (result.status === "OK") {
//                 setLockers([...lockers, lockerAdd]);
//             }
//         } catch (error) {
//             console.error('Error adding locker:', error);
//         }
//         closeAddModal();
//     };

//     const handleEdit = (locker) => {
//         setCurrentLocker(locker);
//         setSelectedLocation(locker.lockerLocation.locationId);
//         setShowModal(true);
//     };

//     const handleDelete = (locker) => {
//         setLockerToDelete(locker);
//         setShowDeleteModal(true);
//     };

//     const confirmDelete = async () => {
//         if (!lockerToDelete) return;
//         console.log(lockerToDelete)
//         try {
//             const response = await axios.delete(`${process.env.BASE_URL}/api/locker/${lockerToDelete.lockerId}`, {
//                 headers: {
//                     Authorization: `Bearer ${token}`
//                 }
//             });
//             const result = response.data;

//             if (result.status === "OK") {
//                 setLockers(lockers.filter(locker => locker.lockerId !== lockerToDelete.lockerId));
//             }
//         } catch (error) {
//             console.error('Error deleting locker:', error);
//         }
//         setShowDeleteModal(false);
//         setLockerToDelete(null);
//     };

//     const handleSaveEdit = async () => {
//         if (!currentLocker || !currentLocker.lockerName || !currentLocker.lockerLocation?.locationId) {
//             setNotificationMessage('Vui lòng điền đầy đủ thông tin tên tủ và chọn vị trí.');
//             return;
//         }
//         console.log(currentLocker)
//         try {
//             const response = await axios.put(`${process.env.BASE_URL}/api/locker/${currentLocker.lockerId}`, {
//                 "lockerName": currentLocker.lockerName,
//                 "isOccupied": currentLocker.isOccupied,
//                 "lockerLocation": {
//                     "locationId": currentLocker.lockerLocation.locationId,
//                     "location": currentLocker.lockerLocation.location
//                 }
//             }, {
//                 headers: {
//                     Authorization: `Bearer ${token}`
//                 }
//             });
//             const result = response.data;

//             if (result.status === "OK") {
//                 // Tìm index của currentLocker trong lockers
//                 const index = lockers.findIndex(locker => locker.lockerId === currentLocker.lockerId);
//                 if (index !== -1) {
//                     const updatedLockers = [...lockers];
//                     updatedLockers[index] = currentLocker;
//                     setLockers(updatedLockers);
//                 }
//             }
//         } catch (error) {

//             console.error('Error updating locker:', error);
//         }
//         setShowModal(false);
//     };


//     const handleClose = () => setShowModal(false);
//     const handleCloseDeleteModal = () => setShowDeleteModal(false);

//     return (
//         <Container fluid className="p-6">
//             <Row>
//                 <Col xl={12} lg={12} md={12} sm={12}>
//                     <div className="border-bottom pb-4 mb-4 d-md-flex align-items-center justify-content-between">
//                         <div className="mb-3 mb-md-0">
//                             <h1 className="mb-1 h2 fw-bold">Quản lý tủ đồ</h1>
//                             <p className="mb-0">
//                                 Quản lý thông tin và trạng thái của tủ đồ.
//                             </p>
//                         </div>
//                     </div>
//                 </Col>
//             </Row>

//             <Row>
//                 <Col xl={12} lg={12} md={12} sm={12}>
//                     <div id="button" className="mb-4">
//                         <h3>Danh sách tủ đồ</h3>
//                     </div>
//                     <Tab.Container defaultActiveKey="all">
//                         <Card.Body className="p-0">
//                             <Tab.Content>
//                                 <Tab.Pane eventKey="all" className="pb-4 p-4">
//                                     <Table striped bordered hover className="locker-table-list">
//                                         <thead>
//                                             <tr>
//                                                 <th>STT</th>
//                                                 <th>Tên tủ</th>
//                                                 <th>Vị trí</th>
//                                                 <th>Trạng thái</th>
//                                                 <th>Hành động</th>
//                                             </tr>
//                                         </thead>
//                                         <tbody>
//                                             {lockers.map((locker, index) => (
//                                                 <tr key={locker.lockerId}>
//                                                     <td>{index + 1}</td>
//                                                     <td>{locker.lockerName}</td>
//                                                     <td>{locker.lockerLocation.location}</td>
//                                                     <td>{locker.isOccupied ? "Đang sử dụng" : "Trống"}</td>
//                                                     <td>
//                                                         <Button variant="primary" size="sm" className="me-2" onClick={() => handleEdit(locker)}>Chỉnh sửa</Button>
//                                                         <Button variant="danger" size="sm" onClick={() => handleDelete(locker)}>Xóa</Button>
//                                                     </td>
//                                                 </tr>
//                                             ))}
//                                         </tbody>
//                                     </Table>
//                                     <Button variant="success" className="mt-3" onClick={openAddModal}>Thêm tủ đồ mới</Button>
//                                 </Tab.Pane>
//                             </Tab.Content>
//                         </Card.Body>
//                     </Tab.Container>
//                 </Col>
//             </Row>
//             {currentLocker && (
//                 <Modal show={showModal} onHide={handleClose}>
//                     <Modal.Header closeButton>
//                         <Modal.Title>Chỉnh sửa tủ đồ</Modal.Title>
//                     </Modal.Header>
//                     <Modal.Body>
//                         <Form>
//                             <Form.Group className="mb-3" controlId="formEditLockerName">
//                                 <Form.Label>Tên tủ</Form.Label>
//                                 <Form.Control
//                                     type="text"
//                                     value={currentLocker?.lockerName || ''}
//                                     onChange={(e) => setCurrentLocker({ ...currentLocker, lockerName: e.target.value })}
//                                 />
//                             </Form.Group>
//                             <Form.Select
//                                 value={selectedLocation}
//                                 onChange={(e) => {
//                                     const locationId = e.target.value;
//                                     const selectedLocationObj = locations.find(location => String(location.locationId) === String(locationId));
//                                     setCurrentLocker({
//                                         ...currentLocker,
//                                         lockerLocation: {
//                                             locationId: locationId,
//                                             location: selectedLocationObj ? selectedLocationObj.location : ''
//                                         }
//                                     });
//                                     setSelectedLocation(locationId);
//                                 }}
//                             >
//                                 <option value="">Chọn địa điểm</option>
//                                 {locations.map((location) => (
//                                     <option key={location.locationId} value={location.locationId}>
//                                         {location.location}
//                                     </option>
//                                 ))}
//                             </Form.Select>
//                             <Form.Group className="mb-3" controlId="formEditLockerStatus">
//                                 <Form.Check
//                                     type="checkbox"
//                                     label="Đang sử dụng"
//                                     checked={currentLocker?.isOccupied || false}
//                                     onChange={(e) => setCurrentLocker({ ...currentLocker, isOccupied: e.target.checked })}
//                                 />
//                             </Form.Group>
//                         </Form>
//                         {notificationMessage && <Notification message={notificationMessage} />}
//                     </Modal.Body>
//                     <Modal.Footer>
//                         <Button variant="secondary" onClick={handleClose}>
//                             Hủy
//                         </Button>
//                         <Button variant="primary" onClick={handleSaveEdit}>
//                             Lưu thay đổi
//                         </Button>
//                     </Modal.Footer>
//                 </Modal>
//             )}

//             <Modal show={showAddModal} onHide={closeAddModal}>
//                 <Modal.Header closeButton>
//                     <Modal.Title>Thêm tủ đồ mới</Modal.Title>
//                 </Modal.Header>
//                 <Modal.Body>
//                     <Form>
//                         <Form.Group className="mb-3" controlId="formNewLockerName">
//                             <Form.Label>Tên tủ</Form.Label>
//                             <Form.Control
//                                 type="text"
//                                 value={lockerAdd?.lockerName || ''}
//                                 onChange={(e) => setLockerAdd({ ...lockerAdd, lockerName: e.target.value })}
//                                 placeholder="Nhập tên tủ"
//                             />

//                         </Form.Group>
//                         <Form.Group className="mb-3" controlId="formNewLockerLocation">
//                             <Form.Label>Vị trí</Form.Label>
//                             <Form.Select value={selectedLocation} onChange={(e) => {
//                                 const locationId = e.target.value;
//                                 const selectedLocationObj = locations.find(location => String(location.locationId) === String(locationId));
//                                 console.log(selectedLocationObj)
//                                 setLockerAdd({
//                                     ...lockerAdd,
//                                     lockerLocation: {
//                                         locationId: locationId,
//                                         location: selectedLocationObj ? selectedLocationObj.location : ''
//                                     }
//                                 })
//                                 setSelectedLocation(locationId);
//                             }}
//                             >
//                                 <option value="">Chọn địa điểm</option>
//                                 {locations.map((location) => (
//                                     <option key={location.locationId} value={location.locationId}>
//                                         {location.location}
//                                     </option>
//                                 ))}
//                             </Form.Select>
//                         </Form.Group>
//                     </Form>
//                 </Modal.Body>
//                 <Modal.Footer>
//                     <Button variant="secondary" onClick={closeAddModal}>
//                         Hủy
//                     </Button>
//                     <Button variant="primary" onClick={handleSaveLocker}>
//                         Lưu
//                     </Button>
//                 </Modal.Footer>
//             </Modal>
//             {lockerToDelete && (
//                 <Modal show={showDeleteModal} onHide={handleCloseDeleteModal}>
//                     <Modal.Header closeButton>
//                         <Modal.Title>Xóa tủ đồ</Modal.Title>
//                     </Modal.Header>
//                     <Modal.Body>
//                         Bạn có chắc chắn muốn xóa tủ đồ này không?
//                     </Modal.Body>
//                     <Modal.Footer>
//                         <Button variant="secondary" onClick={handleCloseDeleteModal}>
//                             Hủy
//                         </Button>
//                         <Button variant="danger" onClick={confirmDelete}>
//                             Xóa
//                         </Button>
//                     </Modal.Footer>
//                 </Modal>
//             )}
//         </Container>
//     );
// };

// export default LockerManagement;


import React, { useEffect, useState } from 'react';
import { Col, Row, Card, Tab, Container, Table, Button, Modal, Form, Alert } from 'react-bootstrap';
import axios from 'axios';
import config from 'next.config';
import { getTokenCookie } from 'utils/auth';
import Notification from 'utils/alert';

const LockerManagement = () => {
    const [lockers, setLockers] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [locations, setLocations] = useState([]);
    const [selectedLocation, setSelectedLocation] = useState('');
    const [currentLocker, setCurrentLocker] = useState(null);
    const [lockerToDelete, setLockerToDelete] = useState(null);
    const [lockerAdd, setLockerAdd] = useState(null);
    const [showDeleteModal, setShowDeleteModal] = useState(false);
    const [showAddModal, setShowAddModal] = useState(false);
    const [notificationMessage, setNotificationMessage] = useState('');
    const [error, setError] = useState('');
    const token = getTokenCookie();

    useEffect(() => {
        fetchLocations();
        fetchLockers();
    }, [lockers]);

    const fetchLocations = async () => {
        try {
            const response = await axios.get(`${process.env.BASE_URL}/api/location/all`);
            const result = response.data;
            if (result.status === "OK") {
                setLocations(result.data);
            }
        } catch (error) {
            console.error('Error fetching locations:', error);
        }
    };

    const fetchLockers = async () => {
        try {
            const response = await axios.get(`${process.env.BASE_URL}/api/locker/all`);
            const result = response.data;
            if (result.status === "OK") {
                setLockers(result.data);
            }
        } catch (error) {
            console.error('Error fetching lockers:', error);
        }
    };

    const openAddModal = () => {
        setShowAddModal(true);
    };

    const closeAddModal = () => {
        setShowAddModal(false);
        setSelectedLocation('');
        setLockerAdd(null);
    };

    const handleSaveLocker = async () => {
        if (!lockerAdd || !lockerAdd.lockerName || !lockerAdd.lockerLocation || !lockerAdd.lockerLocation.locationId) {
            setError('Vui lòng điền đầy đủ thông tin tên tủ và chọn vị trí.');
            return;
        }
        try {
            const response = await axios.post(`${process.env.BASE_URL}/api/locker/add`, {
                "lockerName": lockerAdd.lockerName,
                "isOccupied": false,
                "lockerLocation": {
                    "locationId": lockerAdd.lockerLocation.locationId,
                    "location": lockerAdd.lockerLocation.location
                }
            }, {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });
            const result = response.data;
            console.log(result)
            if (result.status === "OK") {
                fetchLockers();
            } else {
                setError('Failed to add locker');
            }
        } catch (error) {
            setError('Error adding locker: ' + error.message);
            console.error('Error adding locker:', error);
        }
        closeAddModal();
    };

    const handleEdit = (locker) => {
        setCurrentLocker(locker);
        setSelectedLocation(locker.lockerLocation.locationId);
        setShowModal(true);
    };

    const handleDelete = (locker) => {
        setLockerToDelete(locker);
        setShowDeleteModal(true);
    };

    const confirmDelete = async () => {
        if (!lockerToDelete) return;
        try {
            const response = await axios.delete(`${process.env.BASE_URL}/api/locker/${lockerToDelete.lockerId}`, {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });
            const result = response.data;
            console.log(result)
            if (result.message === "Success") {
                fetchLockers();
                setError('');
            } else {
                setError('Failed to delete locker');
            }
        } catch (error) {
            setError('Error deleting locker: ' + error.message);
            console.error('Error deleting locker:', error);
        }
        setShowDeleteModal(false);
        setLockerToDelete(null);
    };

    const handleSaveEdit = async () => {
        if (!currentLocker || !currentLocker.lockerName || !currentLocker.lockerLocation?.locationId) {
            setNotificationMessage('Vui lòng điền đầy đủ thông tin tên tủ và chọn vị trí.');
            return;
        }
        try {
            const response = await axios.put(`${process.env.BASE_URL}/api/locker/${currentLocker.lockerId}`, {
                "lockerName": currentLocker.lockerName,
                "isOccupied": currentLocker.isOccupied,
                "lockerLocation": {
                    "locationId": currentLocker.lockerLocation.locationId,
                    "location": currentLocker.lockerLocation.location
                }
            }, {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });
            
            const result = response.data;
            console.log(result)
            if (result.status === "OK") {
                const index = lockers.findIndex(locker => locker.lockerId === currentLocker.lockerId);
                if (index !== -1) {
                    const updatedLockers = [...lockers];
                    updatedLockers[index] = currentLocker;
                    setLockers(updatedLockers);
                    setError('');
                }
            } else {
                setError('');
            }
        } catch (error) {
            setError('Error updating locker: ' + error.message);
            console.error('Error updating locker:', error);
        }
        setShowModal(false);
    };

    const handleClose = () => setShowModal(false);
    const handleCloseDeleteModal = () => setShowDeleteModal(false);

    return (
        <Container fluid className="p-6">
            <Row>
                <Col xl={12} lg={12} md={12} sm={12}>
                    <div className="border-bottom pb-4 mb-4 d-md-flex align-items-center justify-content-between">
                        <div className="mb-3 mb-md-0">
                            <h1 className="mb-1 h2 fw-bold">Quản lý tủ đồ</h1>
                            <p className="mb-0">
                                Quản lý thông tin và trạng thái của tủ đồ.
                            </p>
                        </div>
                    </div>
                </Col>
            </Row>
            <Row>
                <Col xl={12} lg={12} md={12} sm={12}>
                    <div id="button" className="mb-4">
                        <h3>Danh sách tủ đồ</h3>
                    </div>
                    <Tab.Container defaultActiveKey="all">
                        <Card.Body className="p-0">
                            <Tab.Content>
                                <Tab.Pane eventKey="all" className="pb-4 p-4">
                                    <Table striped bordered hover className="locker-table-list">
                                        <thead>
                                            <tr>
                                                <th>STT</th>
                                                <th>Tên tủ</th>
                                                <th>Vị trí</th>
                                                <th>Trạng thái</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {lockers.map((locker, index) => (
                                                <tr key={locker.lockerId}>
                                                    <td>{index + 1}</td>
                                                    <td>{locker.lockerName}</td>
                                                    <td>{locker.lockerLocation.location}</td>
                                                    <td>{locker.isOccupied ? "Đang sử dụng" : "Trống"}</td>
                                                    <td>
                                                        <Button variant="primary" size="sm" className="me-2" onClick={() => handleEdit(locker)}>Chỉnh sửa</Button>
                                                        <Button variant="danger" size="sm" onClick={() => handleDelete(locker)}>Xóa</Button>
                                                    </td>
                                                </tr>
                                            ))}
                                        </tbody>
                                    </Table>
                                    <Button variant="success" className="mt-3" onClick={openAddModal}>Thêm tủ đồ mới</Button>
                                </Tab.Pane>
                            </Tab.Content>
                        </Card.Body>
                    </Tab.Container>
                </Col>
            </Row>
            {currentLocker && (
                <Modal show={showModal} onHide={handleClose}>
                    <Modal.Header closeButton>
                        <Modal.Title>Chỉnh sửa tủ đồ</Modal.Title>
                    </Modal.Header>
                    <Modal.Body>
                        <Form>
                            <Form.Group className="mb-3" controlId="formEditLockerName">
                                <Form.Label>Tên tủ</Form.Label>
                                <Form.Control
                                    type="text"
                                    value={currentLocker?.lockerName || ''}
                                    onChange={(e) => setCurrentLocker({ ...currentLocker, lockerName: e.target.value })}
                                />
                            </Form.Group>
                            <Form.Select
                                value={selectedLocation}
                                onChange={(e) => {
                                    const locationId = e.target.value;
                                    const selectedLocationObj = locations.find(location => String(location.locationId) === String(locationId));
                                    setCurrentLocker({
                                        ...currentLocker,
                                        lockerLocation: {
                                            locationId: locationId,
                                            location: selectedLocationObj ? selectedLocationObj.location : ''
                                        }
                                    });
                                    setSelectedLocation(locationId);
                                }}
                            >
                                <option value="">Chọn vị trí</option>
                                {locations.map(location => (
                                    <option key={location.locationId} value={location.locationId}>{location.location}</option>
                                ))}
                            </Form.Select>
                            <Form.Group className="mb-3" controlId="formEditLockerStatus">
                                <Form.Check
                                    type="checkbox"
                                    label="Đang sử dụng"
                                    checked={currentLocker?.isOccupied || false}
                                    onChange={(e) => setCurrentLocker({ ...currentLocker, isOccupied: e.target.checked })}
                                />
                            </Form.Group>
                            {notificationMessage && (
                                <Notification message={notificationMessage} />
                            )}
                            {error && (
                                <Alert variant="danger" className="mt-3">
                                    {error}
                                </Alert>
                            )}
                        </Form>
                    </Modal.Body>
                    <Modal.Footer>
                        <Button variant="secondary" onClick={handleClose}>
                            Hủy
                        </Button>
                        <Button variant="primary" onClick={handleSaveEdit}>
                            Lưu
                        </Button>
                    </Modal.Footer>
                </Modal>
            )}
            {showAddModal && (
                <Modal show={showAddModal} onHide={closeAddModal}>
                    <Modal.Header closeButton>
                        <Modal.Title>Thêm tủ đồ</Modal.Title>
                    </Modal.Header>
                    <Modal.Body>
                        <Form>
                            <Form.Group className="mb-3" controlId="formAddLockerName">
                                <Form.Label>Tên tủ</Form.Label>
                                <Form.Control
                                    type="text"
                                    value={lockerAdd?.lockerName || ''}
                                    onChange={(e) => setLockerAdd({ ...lockerAdd, lockerName: e.target.value })}
                                />
                            </Form.Group>
                            <Form.Select
                                value={selectedLocation}
                                onChange={(e) => {
                                    const locationId = e.target.value;
                                    const selectedLocationObj = locations.find(location => String(location.locationId) === String(locationId));
                                    setLockerAdd({
                                        ...lockerAdd,
                                        lockerLocation: {
                                            locationId: locationId,
                                            location: selectedLocationObj ? selectedLocationObj.location : ''
                                        }
                                    });
                                    setSelectedLocation(locationId);
                                }}
                            >
                                <option value="">Chọn vị trí</option>
                                {locations.map(location => (
                                    <option key={location.locationId} value={location.locationId}>{location.location}</option>
                                ))}
                            </Form.Select>
                            {notificationMessage && (
                                <Notification message={notificationMessage} />
                            )}
                            {error && (
                                <Alert variant="danger" className="mt-3">
                                    {error}
                                </Alert>
                            )}
                        </Form>
                    </Modal.Body>
                    <Modal.Footer>
                        <Button variant="secondary" onClick={closeAddModal}>
                            Hủy
                        </Button>
                        <Button variant="primary" onClick={handleSaveLocker}>
                            Lưu
                        </Button>
                    </Modal.Footer>
                </Modal>
            )}
            <Modal show={showDeleteModal} onHide={handleCloseDeleteModal}>
                <Modal.Header closeButton>
                    <Modal.Title>Xóa tủ đồ</Modal.Title>
                </Modal.Header>
                <Modal.Body>Bạn có chắc chắn muốn xóa tủ đồ này không?</Modal.Body>
                {error && (
                    <Alert variant="danger" className="mt-3">
                        {error}
                    </Alert>
                )}
                <Modal.Footer>
                    <Button variant="secondary" onClick={handleCloseDeleteModal}>
                        Hủy
                    </Button>
                    <Button variant="danger" onClick={confirmDelete}>
                        Xóa
                    </Button>
                </Modal.Footer>
            </Modal>
        </Container>
    );
};

export default LockerManagement;