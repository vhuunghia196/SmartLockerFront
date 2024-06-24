

import React, { useState, useEffect } from 'react';
import axios from 'axios';
import RecordLoginChart from '../Chart/RecordLoginChart';
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';
import { Button } from 'react-bootstrap';
import { getTokenCookie } from 'utils/auth';

const ChartLogin = () => {
  const [statisticsData, setStatisticsData] = useState(null);
  const [startDate, setStartDate] = useState(null);
  const [endDate, setEndDate] = useState(null);
  const token = getTokenCookie();

  // Function to get the first day of the current month
  const getFirstDayOfCurrentMonth = () => {
    const today = new Date();
    return new Date(today.getFullYear(), today.getMonth(), 1);
  };

  // Function to get the last day of the current month
  const getLastDayOfCurrentMonth = () => {
    const today = new Date();
    return new Date(today.getFullYear(), today.getMonth() + 1, 0);
  };

  useEffect(() => {
    // Set default startDate and endDate to current month
    const firstDay = getFirstDayOfCurrentMonth();
    const lastDay = getLastDayOfCurrentMonth();
    setStartDate(firstDay);
    setEndDate(lastDay);
    
    // Call chartUsingLockerData function to fetch statistics data
    chartUsingLockerData(firstDay, lastDay);
  }, []); // Empty dependency array ensures this runs only once on component mount

  const chartUsingLockerData = async (start, end) => {
    const startFormatted = formatDateForAPI(start);
    const endFormatted = formatDateForAPI(end);
    
    try {
      const response = await axios.get(`${process.env.BASE_URL}/api/user/record`, {
        params: {
          startDate: startFormatted,
          endDate: endFormatted,
        },
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });

      setStatisticsData(response.data.data);
    } catch (error) {
      console.error('Error fetching statistics data:', error);
    }
  };

  const handleStatistics = () => {
    chartUsingLockerData(startDate, endDate);
  };

  const formatDateForAPI = (date) => {
    if (!date) return ''; // Handle case where no date is selected
    const dateFormat = new Date(date);
    dateFormat.setDate(dateFormat.getDate() + 1);
    const day = String(dateFormat.getDate()).padStart(2, '0');
    const month = String(dateFormat.getMonth() + 1).padStart(2, '0'); // Months are zero indexed
    const year = dateFormat.getFullYear();
    return `${day}-${month}-${year}`;
  };

  return (
    <div className="chartContainer">
      <h1 className="chartHeader">Biểu đồ thống kê số lượng đăng nhập của người dùng</h1>

      <div className="datePickerContainer" style={{ display: "flex" }}>
        <div style={{marginRight: 20, }}>
          <label>Ngày bắt đầu: </label>
          <DatePicker
            selected={startDate}
            onChange={(date) => setStartDate(date)}
            dateFormat="dd-MM-yyyy"
            isClearable
            placeholderText="Chọn ngày bắt đầu"
          />
        </div>

        <div style={{marginRight: 20}}>
          <label>Ngày kết thúc: </label>
          <DatePicker
            selected={endDate}
            onChange={(date) => setEndDate(date)}
            dateFormat="dd-MM-yyyy"
            isClearable
            placeholderText="Chọn ngày kết thúc"
          />
        </div>
        <div className="buttonContainer">
          <Button variant="primary" onClick={handleStatistics}>
            Thống kê
          </Button>
        </div>
      </div>

      {statisticsData && (
        <RecordLoginChart
          userData={statisticsData.loginRecordUserDtos}
        />
      )}
    </div>
  );
};

export default ChartLogin;
