/** @type {import('next').NextConfig} */
// const nextConfig = {
//   reactStrictMode: true,
// };
// const isDev = process.env.NODE_ENV !== 'production';
// module.exports = nextConfig;

const isDev = process.env.NODE_ENV !== 'production';

module.exports = {
  reactStrictMode: true,
  env: {
    HTTPS: isDev, // Sử dụng HTTPS trong môi trường phát triển
  },
  baseURL: 'https://14.225.210.16:8081'
};