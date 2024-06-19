# Stage 1: Build the Next.js application
FROM node:18.20-buster AS builder

WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY jsconfig.json jsconfig.json
COPY next.config.js next.config.js
COPY config.js config.js
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

# Build the Next.js application
RUN npm run build

# Stage 2: Serve the built application with nginx
FROM nginx:alpine

# Copy static files (public)
COPY --from=builder /app/build /usr/share/nginx/html/public


# Expose port 80
EXPOSE 80

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]


