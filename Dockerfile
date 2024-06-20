FROM node:18.20-buster AS builder

WORKDIR /app

COPY jsconfig.json jsconfig.json
COPY next.config.js next.config.js
COPY package.json package.json
COPY package-lock.json package-lock.json
COPY config.js config.js 
RUN npm install

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
RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]