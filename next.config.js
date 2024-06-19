// /** @type {import('next').NextConfig} */
// // const nextConfig = {
// //   reactStrictMode: true,
// // };
// // const isDev = process.env.NODE_ENV !== 'production';
// // module.exports = nextConfig;


// module.exports = {
//   reactStrictMode: true,
//   baseURL: 'https://14.225.210.16:8081'
// };
/** @type {import('next').NextConfig} */
const isDev = process.env.NODE_ENV !== 'production';
const config = require('./config'); // Đường dẫn tới tệp cấu hình của bạn

module.exports = {
  reactStrictMode: true,
  env: {
    HTTPS: isDev, // Sử dụng HTTPS trong môi trường phát triển
    BASE_URL: config.BASE_URL,
  },
};
