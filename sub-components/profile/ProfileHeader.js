// // // import node module libraries
// // import Link from "next/link";
// // import { Col, Row, Image } from "react-bootstrap";
// // import { getUserCookie } from 'utils/auth'
// // import {useEffect, useState } from 'react';

// // const ProfileHeader = () => {
// //   const [username, setUsername] = useState('');
// //   const [name, setName] = useState('');
// //   useEffect(() => {
// //     const userCookie = getUserCookie(); 
// //     if (userCookie) {
// //         setUsername(userCookie.username);
// //         setName(userCookie.name)
// //     }
// // }, []);
// //   return (
// //     <Row className="align-items-center">
// //       <Col xl={12} lg={12} md={12} xs={12}>
// //         {/* Bg */}
// //         <div
// //           className="pt-20 rounded-top"
// //           style={{
// //             background: "url(/images/background/profile-cover.jpg) no-repeat",
// //             backgroundSize: "cover",
// //           }}
// //         ></div>
// //         <div className="bg-white rounded-bottom smooth-shadow-sm ">
// //           <div className="d-flex align-items-center justify-content-between pt-4 pb-6 px-4">
// //             <div className="d-flex align-items-center">
// //               {/* avatar */}
// //               <div className="avatar-xxl avatar-indicators avatar-online me-2 position-relative d-flex justify-content-end align-items-end mt-n10">
// //                 <Image
// //                   src="/images/avatar/user.png"
// //                   className="avatar-xxl rounded-circle border border-4 border-white-color-40"
// //                   alt=""
// //                 />
// //                 <Link
// //                   href="#!"
// //                   className="position-absolute top-0 right-0 me-2"
// //                   data-bs-toggle="tooltip"
// //                   data-placement="top"
// //                   title=""
// //                   data-original-title="Verified"
// //                 >
// //                   <Image
// //                     src="/images/svg/checked-mark.svg"
// //                     alt=""
// //                     height="30"
// //                     width="30"
// //                   />
// //                 </Link>
// //               </div>
// //               {/* text */}
// //               <div className="lh-1">
// //                 <h2 className="mb-0">
// //                   {name}
// //                   <Link
// //                     href="#!"
// //                     className="text-decoration-none"
// //                     data-bs-toggle="tooltip"
// //                     data-placement="top"
// //                     title=""
// //                     data-original-title="Beginner"
// //                   ></Link>
// //                 </h2>
// //                 <p className="mb-0 d-block">@{username}</p>
// //               </div>
// //             </div>
// //             <div>
// //               <Link
// //                 href="#"
// //                 className="btn btn-outline-primary d-none d-md-block"
// //               >
// //                 Edit Profile
// //               </Link>
// //             </div>
// //           </div>
// //           {/* nav */}
// //           <ul className="nav nav-lt-tab px-4" id="pills-tab" role="tablist">
            
// //           </ul>
// //         </div>
// //       </Col>
// //     </Row>
// //   );
// // };

// // export default ProfileHeader;
// // ProfileHeader component
// import Link from "next/link";
// import { Col, Row, Image } from "react-bootstrap";

// const ProfileHeader = ({ user }) => {
//   if (!user) return null; // Return early if user data is not available

//   return (
//     <Row className="align-items-center">
//       <Col xl={12} lg={12} md={12} xs={12}>
//         {/* Bg */}
//         <div
//           className="pt-20 rounded-top"
//           style={{
//             background: "url(/images/background/profile-cover.jpg) no-repeat",
//             backgroundSize: "cover",
//           }}
//         ></div>
//         <div className="bg-white rounded-bottom smooth-shadow-sm">
//           <div className="d-flex align-items-center justify-content-between pt-4 pb-6 px-4">
//             <div className="d-flex align-items-center">
//               {/* avatar */}
//               <div className="avatar-xxl avatar-indicators avatar-online me-2 position-relative d-flex justify-content-end align-items-end mt-n10">
//                 <Image
//                   src="/images/avatar/user.png"
//                   className="avatar-xxl rounded-circle border border-4 border-white-color-40"
//                   alt=""
//                 />
//                 <Link
//                   href="#!"
//                   className="position-absolute top-0 right-0 me-2"
//                   data-bs-toggle="tooltip"
//                   data-placement="top"
//                   title=""
//                   data-original-title="Verified"
//                 >
//                   <Image
//                     src="/images/svg/checked-mark.svg"
//                     alt=""
//                     height="30"
//                     width="30"
//                   />
//                 </Link>
//               </div>
//               {/* text */}
//               <div className="lh-1">
//                 <h2 className="mb-0">
//                   {user.name} {/* Ensure user.name is defined */}
//                   <Link
//                     href="#!"
//                     className="text-decoration-none"
//                     data-bs-toggle="tooltip"
//                     data-placement="top"
//                     title=""
//                     data-original-title="Beginner"
//                   ></Link>
//                 </h2>
//                 <p className="mb-0 d-block">@{user.username}</p>
//               </div>
//             </div>
//             <div>
//               <Link
//                 href="#"
//                 className="btn btn-outline-primary d-none d-md-block"
//               >
//                 Edit Profile
//               </Link>
//             </div>
//           </div>
//           {/* nav */}
//           <ul className="nav nav-lt-tab px-4" id="pills-tab" role="tablist">
//             {/* Add navigation items here if needed */}
//           </ul>
//         </div>
//       </Col>
//     </Row>
//   );
// };

// export default ProfileHeader;
// sub-components/ProfileHeader.js

// import Link from "next/link";
// import { Col, Row, Image } from "react-bootstrap";

// const ProfileHeader = ({ user }) => {
//   if (!user) return null; // Return early if user data is not available

//   return (
//     <Row className="align-items-center">
//       <Col xl={12} lg={12} md={12} xs={12}>
//         {/* Bg */}
//         <div
//           className="pt-20 rounded-top"
//           style={{
//             background: "url(/images/background/profile-cover.jpg) no-repeat",
//             backgroundSize: "cover",
//           }}
//         ></div>
//         <div className="bg-white rounded-bottom smooth-shadow-sm">
//           <div className="d-flex align-items-center justify-content-between pt-4 pb-6 px-4">
//             <div className="d-flex align-items-center">
//               {/* avatar */}
//               <div className="avatar-xxl avatar-indicators avatar-online me-2 position-relative d-flex justify-content-end align-items-end mt-n10">
//                 <Image
//                   src="/images/avatar/user.png"
//                   className="avatar-xxl rounded-circle border border-4 border-white-color-40"
//                   alt=""
//                 />
//                 <Link
//                   href="#!"
//                   className="position-absolute top-0 right-0 me-2"
//                   data-bs-toggle="tooltip"
//                   data-placement="top"
//                   title=""
//                   data-original-title="Verified"
//                 >
//                   <Image
//                     src="/images/svg/checked-mark.svg"
//                     alt=""
//                     height="30"
//                     width="30"
//                   />
//                 </Link>
//               </div>
//               {/* text */}
//               <div className="lh-1">
//                 <h2 className="mb-0">
//                   {user.name} {/* Ensure user.name is defined */}
//                   <Link
//                     href="#!"
//                     className="text-decoration-none"
//                     data-bs-toggle="tooltip"
//                     data-placement="top"
//                     title=""
//                     data-original-title="Beginner"
//                   ></Link>
//                 </h2>
//                 <p className="mb-0 d-block">@{user.username}</p>
//               </div>
//             </div>
//             <div>
//               <Link
//                 href="#"
//                 className="btn btn-outline-primary d-none d-md-block"
//               >
//                 Sửa thông tin
//               </Link>
//             </div>
//           </div>
//           {/* nav */}
//           <ul className="nav nav-lt-tab px-4" id="pills-tab" role="tablist">
//             {/* Add navigation items here if needed */}
//           </ul>
//         </div>
//       </Col>
//     </Row>
//   );
// };

// export default ProfileHeader;

import React, { useState } from "react";
import Link from "next/link";
import { Col, Row, Image, Button, Modal, Form } from "react-bootstrap";
import axios from 'axios';
import { getTokenCookie } from 'utils/auth';

const ProfileHeader = ({ user }) => {
  const [showModal, setShowModal] = useState(false);
  const [name, setName] = useState(user?.name || '');
  const [phone, setPhone] = useState(user?.phone || '');
  const [email, setEmail] = useState(user?.email || '');

  const handleShowModal = () => setShowModal(true);
  const handleCloseModal = () => setShowModal(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    const token = getTokenCookie();

    try {
      await axios.post(
        `${process.env.BASE_URL}/api/user/user-info/role`,
        {
          name,
          phone,
          email,
        },
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      // Optionally update user state or notify user of success
      handleCloseModal();
    } catch (error) {
      console.error('Error updating user info:', error);
    }
  };

  if (!user) return null;

  return (
    <>
      <Row className="align-items-center">
        <Col xl={12} lg={12} md={12} xs={12}>
          {/* Bg */}
          <div
            className="pt-20 rounded-top"
            style={{
              background: "url(/images/background/profile-cover.jpg) no-repeat",
              backgroundSize: "cover",
            }}
          ></div>
          <div className="bg-white rounded-bottom smooth-shadow-sm">
            <div className="d-flex align-items-center justify-content-between pt-4 pb-6 px-4">
              <div className="d-flex align-items-center">
                {/* avatar */}
                <div className="avatar-xxl avatar-indicators avatar-online me-2 position-relative d-flex justify-content-end align-items-end mt-n10">
                  <Image
                    src="/images/avatar/user.png"
                    className="avatar-xxl rounded-circle border border-4 border-white-color-40"
                    alt=""
                  />
                  <Link
                    href="#!"
                    className="position-absolute top-0 right-0 me-2"
                    data-bs-toggle="tooltip"
                    data-placement="top"
                    title=""
                    data-original-title="Verified"
                  >
                    <Image
                      src="/images/svg/checked-mark.svg"
                      alt=""
                      height="30"
                      width="30"
                    />
                  </Link>
                </div>
                {/* text */}
                <div className="lh-1">
                  <h2 className="mb-0">
                    {user.name}
                    <Link
                      href="#!"
                      className="text-decoration-none"
                      data-bs-toggle="tooltip"
                      data-placement="top"
                      title=""
                      data-original-title="Beginner"
                    ></Link>
                  </h2>
                  <p className="mb-0 d-block">@{user.username}</p>
                </div>
              </div>
              <div>
                <Button
                  variant="outline-primary"
                  className="d-none d-md-block"
                  onClick={handleShowModal}
                >
                  Sửa thông tin
                </Button>
              </div>
            </div>
            {/* nav */}
            <ul className="nav nav-lt-tab px-4" id="pills-tab" role="tablist">
              {/* Add navigation items here if needed */}
            </ul>
          </div>
        </Col>
      </Row>

      <Modal show={showModal} onHide={handleCloseModal}>
        <Modal.Header closeButton>
          <Modal.Title>Sửa thông tin</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form onSubmit={handleSubmit}>
            <Form.Group className="mb-3" controlId="formName">
              <Form.Label>Tên</Form.Label>
              <Form.Control
                type="text"
                placeholder="Enter your name"
                value={name}
                onChange={(e) => setName(e.target.value)}
              />
            </Form.Group>
            <Form.Group className="mb-3" controlId="formPhone">
              <Form.Label>Điện thoại</Form.Label>
              <Form.Control
                type="text"
                placeholder="Enter your phone"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
              />
            </Form.Group>
            <Form.Group className="mb-3" controlId="formEmail">
              <Form.Label>Email</Form.Label>
              <Form.Control
                type="email"
                placeholder="Enter your email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </Form.Group>
            <Button variant="primary" type="submit">
              Lưu thay đổi
            </Button>
          </Form>
        </Modal.Body>
      </Modal>
    </>
  );
};

export default ProfileHeader;
