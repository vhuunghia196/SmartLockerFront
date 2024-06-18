import React from 'react';
import { Alert } from 'react-bootstrap'; // Sử dụng Alert từ react-bootstrap hoặc thư viện UI khác

const Notification = ({ message }) => {
  return (
    <Alert variant="danger">
      {message}
    </Alert>
  );
};

export default Notification;
