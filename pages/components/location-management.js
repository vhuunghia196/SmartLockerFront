// import node module libraries
import React, { useEffect, useState } from 'react';
import { Col, Row, Card, Tab, Container, Table, Button, Modal, Form } from 'react-bootstrap';
import axios from 'axios';
import config from 'next.config';
import { getTokenCookie } from 'utils/auth';
const LocationManagement = () => {
  const [locations, setLocations] = useState([]);
  const [showModal, setShowModal] = useState(false);
  const [currentLocation, setCurrentLocation] = useState(null);
  const [locationToDelete, setLocationToDelete] = useState(null);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [showAddModal, setShowAddModal] = useState(false);
  const [newLocation, setNewLocation] = useState('');
  const token = getTokenCookie();
  useEffect(() => {
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

    fetchLocations();
  }, [locations]);
  const handleEdit = (location) => {
    setCurrentLocation(location);
    setShowModal(true);
  };

  const handleDelete = (location) => {
    setLocationToDelete(location);
    setShowDeleteModal(true);
  };
  const confirmDelete = async (locationToDelete) => {
    if (!locationToDelete) return;

    try {
      const response = await axios.delete(`${config.baseURL}/api/location/${locationToDelete.locationId}`, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      });
      const result = response.data;

      if (result.status === "OK") {
        setLocations(locations.filter(location => location.locationId !== locationToDelete.locationId));
      }
    } catch (error) {
      console.error('Error deleting location:', error);
    }
    setShowDeleteModal(false);
    setLocationToDelete(null);
  };
  const handleClose = () => setShowModal(false);
  const handleCloseDeleteModal = () => setShowDeleteModal(false);
  const handleSave = async (location) => {
    try {
      const response = await axios.put(`${config.baseURL}/api/location/${location.locationId}`, {
        locationId: location.locationId,
        location: location.location
      },
        {
          headers: {
            Authorization: `Bearer ${token}`
          }
        });
      const result = response.data;

      if (result.status === "OK") {
        setLocations(locations.map(loc => loc.locationId === location.locationId ? location : loc));
      }
    } catch (error) {
      console.error('Error updating location:', error);
    }
    setShowModal(false);
  };

  // xóa 
  const handleShowAddModal = () => setShowAddModal(true);
  const handleCloseAddModal = () => setShowAddModal(false);
  const handleAddLocation = async () => {
    try {
      const response = await axios.post(`${config.baseURL}/api/location/add`, {
        location: newLocation
      }, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      });
      const result = response.data;

      if (result.status === "OK") {
        setLocations([...locations, result.data]);
      }
    } catch (error) {
      console.error('Error adding location:', error);
    }
    setShowAddModal(false);
    setNewLocation('');
  };

  return (
    <Container fluid className="p-6">
      <Row>
        <Col xl={12} lg={12} md={12} sm={12}>
          <div className="border-bottom pb-4 mb-4 d-md-flex align-items-center justify-content-between">
            <div className="mb-3 mb-md-0">
              <h1 className="mb-1 h2 fw-bold">Quản lý địa điểm</h1>
              <p className="mb-0">
                Quản lý thông tin và trạng thái của địa điểm.
              </p>
            </div>
          </div>
        </Col>
      </Row>

      <Row>
        <Col xl={12} lg={12} md={12} sm={12}>
          <div id="button" className="mb-4">
            <h3>Danh sách địa điểm</h3>
          </div>
          <Tab.Container defaultActiveKey="all">
            <Card.Body className="p-0">
              <Tab.Content>
                <Tab.Pane eventKey="all" className="pb-4 p-4">
                  <Table striped bordered hover className="location-table-list">
                    <thead>
                      <tr>
                        <th>STT</th>
                        <th>Tên địa điểm</th>
                        <th>Hành động</th>
                      </tr>
                    </thead>
                    <tbody>
                      {locations.map((location, index) => (
                        <tr key={location.id}>
                          <td>{index + 1}</td>
                          <td>{location.location}</td>
                          <td>
                            <Button variant="primary" size="sm" className="me-2" onClick={() => handleEdit(location)}>Chỉnh sửa</Button>
                            <Button variant="danger" size="sm" onClick={() => handleDelete(location)}>Xóa</Button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </Table>
                  <Button variant="success" className="mt-3" onClick={handleShowAddModal}>Thêm địa điểm mới</Button>

                </Tab.Pane>
              </Tab.Content>
            </Card.Body>
          </Tab.Container>
        </Col>
      </Row>

      {currentLocation && (
        <Modal show={showModal} onHide={handleClose}>
          <Modal.Header closeButton>
            <Modal.Title>Chỉnh sửa địa điểm</Modal.Title>
          </Modal.Header>
          <Modal.Body>
            <Form>
              <Form.Group controlId="formLocationName">
                <Form.Label>Tên địa điểm</Form.Label>
                <Form.Control
                  type="text"
                  value={currentLocation.location}
                  onChange={(e) => setCurrentLocation({ ...currentLocation, location: e.target.value })}
                />
              </Form.Group>
            </Form>
          </Modal.Body>
          <Modal.Footer>
            <Button variant="secondary" onClick={handleClose}>
              Đóng
            </Button>
            <Button variant="primary" onClick={() => handleSave(currentLocation)}>
              Lưu thay đổi
            </Button>
          </Modal.Footer>
        </Modal>


      )}
      {locationToDelete && (
        <Modal show={showDeleteModal} onHide={handleCloseDeleteModal}>
          <Modal.Header closeButton>
            <Modal.Title>Xác nhận xóa</Modal.Title>
          </Modal.Header>
          <Modal.Body>
            Bạn có chắc chắn muốn xóa địa điểm này không?
          </Modal.Body>
          <Modal.Footer>
            <Button variant="secondary" onClick={handleCloseDeleteModal}>
              Không
            </Button>
            <Button variant="danger" onClick={() => confirmDelete(locationToDelete)}>
              Có
            </Button>
          </Modal.Footer>
        </Modal>
      )}
      <Modal show={showAddModal} onHide={handleCloseAddModal}>
        <Modal.Header closeButton>
          <Modal.Title>Thêm địa điểm mới</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form>
            <Form.Group controlId="formNewLocationName">
              <Form.Label>Tên địa điểm</Form.Label>
              <Form.Control
                type="text"
                value={newLocation}
                onChange={(e) => setNewLocation(e.target.value)}
              />
            </Form.Group>
          </Form>
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={handleCloseAddModal}>
            Đóng
          </Button>
          <Button variant="primary" onClick={handleAddLocation}>
            Thêm
          </Button>
        </Modal.Footer>
      </Modal>

    </Container>
  );
};

export default LocationManagement;
