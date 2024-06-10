import React, { useEffect, useState } from 'react';
import axios from 'axios';
import config from 'next.config';
import { Col, Row, Card, Breadcrumb, Nav, Tab, Container, Table, Button } from 'react-bootstrap';
const OrdersList = () => {
  const [orders, setOrders] = useState([]);
  useEffect(() => {
    const fetchOrders = async () => {
      try {
        const response = await axios.get(`${config.baseURL}/api/locker/history/all`);
        const data = response.data.data;
        const groupedOrders = groupOrders(data);

        console.log(groupedOrders)
        setOrders(groupedOrders);
      } catch (error) {
        console.error('Error fetching orders:', error);
      }
    };

    fetchOrders();
  }, []);

  const hasMatchingOnProcedure = (order, otherOrders) => {
    return otherOrders.some(otherOrder => otherOrder.onProcedure === order.historyId);
  };

  // Hàm gom nhóm các đơn hàng và loại bỏ các phần tử trùng lặp
  const groupOrders = (data) => {
    const groupedOrders = {};

    data.forEach(order => {
      const { historyId } = order;

      // Kiểm tra xem có phần tử nào trong groupedOrders có onProcedure bằng historyId không
      const matchingOrders = Object.values(groupedOrders).find(otherOrders =>
        hasMatchingOnProcedure(order, otherOrders)
      );

      if (matchingOrders) {
        // Nếu có, thêm vào mảng đó
        matchingOrders.push(order);
      } else {
        // Nếu không, tạo một mảng mới và thêm vào groupedOrders
        groupedOrders[historyId] = [order];
      }
    });

    return groupedOrders;
  };


  return (
    <Container fluid className="p-6">
      <Row>
        <Col xl={12} lg={12} md={12} sm={12}>
          <div className="border-bottom pb-4 mb-4 d-md-flex align-items-center justify-content-between">
            <div className="mb-3 mb-md-0">
              <h1 className="mb-1 h2 fw-bold">Quản lý đơn hàng</h1>
              <p className="mb-0">
                Quản lý thông tin và trạng thái của các đơn hàng.
              </p>
            </div>
          </div>
        </Col>
      </Row>

      <Row>
        <Col xl={12} lg={12} md={12} sm={12}>
          <div id="button" className="mb-4">
            <h3>Danh sách đơn hàng: CHỈ XEM</h3>
          </div>
          <Tab.Container defaultActiveKey="all">
            <Card.Body className="p-0">
              <Tab.Content>
                <Tab.Pane eventKey="all" className="pb-4 p-4">
                  <Table striped bordered hover className="order-table-list">
                    <thead>
                      <tr>
                        <th>STT</th>
                        <th>ID</th>
                        <th>Thời gian bắt đầu</th>
                        <th>Thời gian kết thúc</th>
                        <th>Tủ</th>
                        <th>Địa điểm</th>
                        <th>Mã OTP</th>
                        <th>Người gửi</th>
                        <th>Người nhận</th>
                        <th>Người vận chuyển</th>
                        <th>Hoàn thành</th>
                      </tr>
                    </thead>
                    <tbody>
                      {Object.entries(orders).map(([orderId, orderList], index) => (
                        <React.Fragment key={orderId}>
                          {orderList.map((order, orderIndex) => (
                            <tr key={order.historyId}>
                              {orderIndex === 0 && (
                                <td rowSpan={orderList.length} className="text-center">{index + 1}</td>
                              )}
                              <td className="text-center">{order.historyId}</td>
                              <td className="text-center">{order.startTime}</td>
                              <td className="text-center">{order.endTime}</td>
                              <td className="text-center">{order.locker.lockerName}</td>
                              <td className="text-center">{order.locker.lockerLocation.location}</td>
                              <td className="text-center">{order.otp.otpNumber}</td>
                              {orderIndex === 0 && (
                                <>
                                  <td rowSpan={orderList.length} className="text-center">
                                    {order.users.map(user => (
                                      user.role === "SENDER" && `${user.user.name} - ${user.user.phone.replace('+84', '0')}`
                                    ))}
                                  </td>
                                  <td rowSpan={orderList.length} className="text-center">
                                    {order.users.map(user => (
                                      user.role === "RECEIVER" && `${user.user.name} - ${user.user.phone.replace('+84', '0')}`
                                    ))}
                                  </td>
                                  <td rowSpan={orderList.length} className="text-center">
                                    {order.users.map(user => (
                                      user.role === "SHIPPER" && `${user.user.name} - ${user.user.phone.replace('+84', '0')}`
                                    ))}
                                  </td>
                                </>
                              )}
                              {orderIndex === 0 && orderList.length === 2 && (
                                <td rowSpan={orderList.length} className="text-center">Đã hoàn thành</td>
                              )}
                              {orderIndex === 0 && orderList.length === 1 && (
                                <td rowSpan={orderList.length} className="text-center">Chưa hoàn thành</td>
                              )}
                            </tr>
                          ))}
                        </React.Fragment>
                      ))}
                    </tbody>
                  </Table>
                </Tab.Pane>
              </Tab.Content>
            </Card.Body>
          </Tab.Container>
        </Col>
      </Row>
    </Container>
  );

};

export default OrdersList;
