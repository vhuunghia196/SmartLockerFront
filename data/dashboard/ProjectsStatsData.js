// import {
// 	Briefcase,
//     ListTask,
//     People,
//     Bullseye
// } from 'react-bootstrap-icons';

// export const ProjectsStats = [
//     {
//        id:1,
//        title : "Đơn hàng",
//        value : 18,
//        icon: <Briefcase size={18}/>,
//     },
//     {
//         id:2,
//         title : "Người dùng",
//         value : 132,
//         icon: <ListTask size={18}/>,
//      },
//      {
//         id:3,
//         title : "Tủ",
//         value : 12,
//         icon: <People size={18}/>,
//      },
//      {
//         id:4,
//         title : "Địa điểm",
//         value : '76%',
//         icon: <Bullseye size={18}/>,
//      }
// ];
// export default ProjectsStats;

import React, { useState, useEffect } from 'react';
import { Container, Col, Row } from 'react-bootstrap';
import { StatRightTopIcon } from "widgets";
import Link from 'next/link';
import axios from 'axios';
import {
  Briefcase,
  ListTask,
  People,
  Bullseye
} from 'react-bootstrap-icons';
import { getTokenCookie } from 'utils/auth';

const ProjectsStats = () => {
  const [statsData, setStatsData] = useState([]);
  const token = getTokenCookie();

  useEffect(() => {
    const fetchData = async () => {
      try {
        // Gọi các API để lấy dữ liệu số lượng từng mục
        const [ordersResponse, usersResponse, lockersResponse, locationsResponse] = await Promise.all([
          axios.get(`${process.env.BASE_URL}/api/history/count`, {
            headers: {
              Authorization: `Bearer ${token}`
            }
          }),
          axios.get(`${process.env.BASE_URL}/api/user/count`, {
            headers: {
              Authorization: `Bearer ${token}`
            }
          }),
          axios.get(`${process.env.BASE_URL}/api/locker/count`, {
            headers: {
              Authorization: `Bearer ${token}`
            }
          }),
          axios.get(`${process.env.BASE_URL}/api/location/count`, {
            headers: {
              Authorization: `Bearer ${token}`
            }
          })
        ]);

        // Lấy dữ liệu từ các response
        const ordersCount = ordersResponse.data.data;
        const usersCount = usersResponse.data.data;
        const lockersCount = lockersResponse.data.data;
        const locationsCount = locationsResponse.data.data;

        // Ánh xạ id với icon tương ứng
        const iconMapping = {
          1: <Briefcase size={18} />,
          2: <People size={18} />,
          3: <ListTask size={18} />,
          4: <Bullseye size={18} />,
        };

        // Cập nhật dữ liệu vào state
        const updatedStats = [
          { id: 1, title: "Đơn hàng", value: ordersCount, icon: iconMapping[1], linkTo: '/components/order-list' },
          { id: 2, title: "Người dùng", value: usersCount, icon: iconMapping[2], linkTo: '/components/user-management' },
          { id: 3, title: "Tủ", value: lockersCount, icon: iconMapping[3], linkTo: '/components/locker-management' },
          { id: 4, title: "Địa điểm", value: locationsCount, icon: iconMapping[4], linkTo: '/components/location-management' },
        ];
        setStatsData(updatedStats);
      } catch (error) {
        console.error('Error fetching statistics data:', error);
      }
    };

    fetchData();
  }, []); // Chỉ gọi fetchData khi component mount

  return (
    <Container fluid>
      <Row>
        {statsData.map((item) => (
          <Col xl={3} lg={6} md={12} xs={12} className="mt-6" key={item.id}>
            <Link href={item.linkTo}>
              <StatRightTopIcon info={item} />
            </Link>
          </Col>
        ))}
      </Row>
    </Container>
  );
};

export default ProjectsStats;

