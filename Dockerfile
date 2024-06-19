# Sử dụng Node.js để build ứng dụng
FROM node:18.20-buster AS builder

# Đặt thư mục làm việc thành /app
WORKDIR /app

# Sao chép các file cấu hình và package vào container
COPY jsconfig.json jsconfig.json
COPY next.config.js next.config.js
COPY package.json package.json
COPY package-lock.json package-lock.json

# Cài đặt các dependencies
RUN npm install

# Sao chép các thư mục của dự án vào container
COPY public/ public
COPY components/ components
COPY context/ context
COPY data/ data
COPY hooks/ hooks
COPY layouts/ layouts
COPY pages/ pages
COPY routes/ routes
COPY styles/ styles
COPY sub-components/ sub-components
COPY utils/ utils
COPY widgets/ widgets

# Build ứng dụng Next.js
RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]