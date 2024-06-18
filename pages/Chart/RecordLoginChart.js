import React, { useEffect, useRef } from 'react';
import { Chart, BarElement, CategoryScale, LinearScale, Title, Tooltip, Legend, BarController } from 'chart.js';

// Register the components
Chart.register(BarElement, CategoryScale, LinearScale, Title, Tooltip, Legend, BarController);

const RecordLoginChart = ({ userData }) => {
  const userChartRef = useRef(null);
  const userChartInstanceRef = useRef(null);

  useEffect(() => {
    // Destroy previous user chart instance if it exists
    if (userChartInstanceRef.current) {
      userChartInstanceRef.current.destroy();
    }

    // Create new user chart instance
    if (userChartRef.current) {
      const newUserChartInstance = new Chart(userChartRef.current, {
        type: 'bar',
        data: {
          labels: userData.map(item => item.username),
          datasets: [
            {
              label: 'Số lần đăng nhập',
              data: userData.map(item => item.record),
              backgroundColor: 'rgba(153, 102, 255, 0.2)',
              borderColor: 'rgba(153, 102, 255, 1)',
              borderWidth: 1,
            },
          ],
        },
        options: {
          plugins: {
            title: {
              display: true,
              text: 'Số lần đăng nhập của người dùng',
              font: {
                size: 20
              }
            },
            legend: {
              display: true,
              position: 'bottom'
            },
          },
          scales: {
            x: { type: 'category', beginAtZero: true },
            y: { type: 'linear', beginAtZero: true },
          },
        },
      });
      userChartInstanceRef.current = newUserChartInstance;
    }
  }, [userData]);

  return (
    <div className="chartContainer">
      <canvas ref={userChartRef} />
    </div>
  );
};

export default RecordLoginChart;
