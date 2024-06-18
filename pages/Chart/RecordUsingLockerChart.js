// import React, { useEffect, useRef } from 'react';
// import { Chart, BarElement, CategoryScale, LinearScale, Title, Tooltip, Legend, BarController } from 'chart.js';

// // Register the components
// Chart.register(BarElement, CategoryScale, LinearScale, Title, Tooltip, Legend, BarController);

// const RecordUsingLockerChart = ({ lockerData, userData }) => {
//   const lockerChartRef = useRef(null);
//   const userChartRef = useRef(null);
//   const lockerChartInstanceRef = useRef(null);
//   const userChartInstanceRef = useRef(null);

//   useEffect(() => {
//     // Destroy previous locker chart instance if it exists
//     if (lockerChartInstanceRef.current) {
//       lockerChartInstanceRef.current.destroy();
//     }

//     // Create new locker chart instance
//     if (lockerChartRef.current) {
//       const newLockerChartInstance = new Chart(lockerChartRef.current, {
//         type: 'bar',
//         data: {
//           labels: lockerData.map(item => item.lockerName),
//           datasets: [
//             {
//               label: 'Số lượt',
//               data: lockerData.map(item => item.record),
//               backgroundColor: 'rgba(75, 192, 192, 0.2)',
//               borderColor: 'rgba(75, 192, 192, 1)',
//               borderWidth: 1,
//             },
//           ],
//         },
//         options: {
//           plugins: {
//             title: {
//               display: true,
//               text: 'Số lượng mà tủ đã được sử dụng',
//               font: {
//                 size: 20
//               }
//             },
//             legend: {
//               display: true,
//               position: 'bottom'
//             },
//           },
//           scales: {
//             x: { type: 'category', beginAtZero: true },
//             y: { type: 'linear', beginAtZero: true },
//           },
//         },
//       });
//       lockerChartInstanceRef.current = newLockerChartInstance;
//     }

//     // Destroy previous user chart instance if it exists
//     if (userChartInstanceRef.current) {
//       userChartInstanceRef.current.destroy();
//     }

//     // Create new user chart instance
//     if (userChartRef.current) {
//       const newUserChartInstance = new Chart(userChartRef.current, {
//         type: 'bar',
//         data: {
//           labels: userData.map(item => item.name),
//           datasets: [
//             {
//               label: 'Số lượt',
//               data: userData.map(item => item.record),
//               backgroundColor: 'rgba(153, 102, 255, 0.2)',
//               borderColor: 'rgba(153, 102, 255, 1)',
//               borderWidth: 1,
//             },
//           ],
//         },
//         options: {
//           plugins: {
//             title: {
//               display: true,
//               text: 'Số lượng mà người dùng đã sử dụng tủ',
//               font: {
//                 size: 20
//               }
//             },
//             legend: {
//               display: true,
//               position: 'bottom'
//             },
//           },
//           scales: {
//             x: { type: 'category', beginAtZero: true },
//             y: { type: 'linear', beginAtZero: true },
//           },
//         },
//       });
//       userChartInstanceRef.current = newUserChartInstance;
//     }
//   }, [lockerData, userData]);

//   return (
//     <div>
//       <canvas ref={lockerChartRef} />
//       <canvas ref={userChartRef} />
//     </div>
//   );
// };

// export default RecordUsingLockerChart;
import React, { useEffect, useRef } from 'react';
import { Chart, BarElement, CategoryScale, LinearScale, Title, Tooltip, Legend, BarController } from 'chart.js';

// Register the components
Chart.register(BarElement, CategoryScale, LinearScale, Title, Tooltip, Legend, BarController);

const RecordUsingLockerChart = ({ lockerData, userData }) => {
  const lockerChartRef = useRef(null);
  const userChartRef = useRef(null);
  const lockerChartInstanceRef = useRef(null);
  const userChartInstanceRef = useRef(null);

  useEffect(() => {
    // Destroy previous locker chart instance if it exists
    if (lockerChartInstanceRef.current) {
      lockerChartInstanceRef.current.destroy();
    }

    // Create new locker chart instance
    if (lockerChartRef.current) {
      const newLockerChartInstance = new Chart(lockerChartRef.current, {
        type: 'bar',
        data: {
          labels: lockerData.map(item => item.lockerName),
          datasets: [
            {
              label: 'Số lượt',
              data: lockerData.map(item => item.record),
              backgroundColor: 'rgba(75, 192, 192, 0.2)',
              borderColor: 'rgba(75, 192, 192, 1)',
              borderWidth: 1,
            },
          ],
        },
        options: {
          plugins: {
            title: {
              display: true,
              text: 'Số lượng mà tủ đã được sử dụng',
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
      lockerChartInstanceRef.current = newLockerChartInstance;
    }

    // Destroy previous user chart instance if it exists
    if (userChartInstanceRef.current) {
      userChartInstanceRef.current.destroy();
    }

    // Create new user chart instance
    if (userChartRef.current) {
      const newUserChartInstance = new Chart(userChartRef.current, {
        type: 'bar',
        data: {
          labels: userData.map(item => item.name),
          datasets: [
            {
              label: 'Số lượt',
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
              text: 'Số lượng mà người dùng đã sử dụng tủ',
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
  }, [lockerData, userData]);

  return (
    <div className="chartContainer">
      <canvas ref={lockerChartRef} />

      <canvas ref={userChartRef} />

    </div>
  );
};

export default RecordUsingLockerChart;
