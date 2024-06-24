
import React, { useState, useEffect } from 'react';
import axios from 'axios';
import RecordUsingLockerChart from '../Chart/RecordUsingLockerChart';
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';
import { Button } from 'react-bootstrap';
import config from 'next.config';
import { getTokenCookie } from 'utils/auth';

const ChartUsingLocker = () => {
  const [statisticsData, setStatisticsData] = useState(null);
  const [startDate, setStartDate] = useState(null);
  const [endDate, setEndDate] = useState(null);
  const token = getTokenCookie();

  const chartUsingLockerData = async (start, end) => {
    const startDate = formatDateForAPI(start);
    const endDate = formatDateForAPI(end);

    try {
      const response = await axios.get(`${process.env.BASE_URL}/api/history/record`, {
        params: {
          startDate: startDate,
          endDate: endDate,
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
    if (!date) return ''; // Trường hợp không có ngày được chọn
    var dateFormat = new Date(date);
    dateFormat.setDate(dateFormat.getDate() + 1);
    const day = String(dateFormat.getDate()).padStart(2, '0');
    const month = String(dateFormat.getMonth() + 1).padStart(2, '0'); // Tháng bắt đầu từ 0
    const year = dateFormat.getFullYear();
    return `${day}-${month}-${year}`;
  };

  const getDefaultDateRange = () => {
    const today = new Date();
    const firstDayOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
    const lastDayOfMonth = new Date(today.getFullYear(), today.getMonth() + 1, 0);

    return { start: firstDayOfMonth, end: lastDayOfMonth };
  };

  useEffect(() => {
    const { start, end } = getDefaultDateRange();
    setStartDate(start);
    setEndDate(end);
    chartUsingLockerData(start, end);
  }, []);

  return (
    <div className="chartContainer">
      <h1 className="chartHeader">Biểu đồ thống kê số lượng sử dụng tủ</h1>

      <div className="datePickerContainer" style={{ display: "flex" }}>
        <div style={{marginRight: 20}}>
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
        <RecordUsingLockerChart
          lockerData={statisticsData.lockerUsingDtos}
          userData={statisticsData.userUsingDtos}
        />
      )}
    </div>
  );
};

export default ChartUsingLocker;
