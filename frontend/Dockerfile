# Stage 1: Build
FROM node:18 AS build

WORKDIR /app

# Clone the frontend repo
RUN git clone https://github.com/KALA2501/kala-frontend.git .

# Install dependencies and build
RUN npm install
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy the built files to Nginx public dir
COPY --from=build /app/build /usr/share/nginx/html

# Expose default Nginx port (80)
EXPOSE 80

# Run Nginx
CMD ["nginx", "-g", "daemon off;"]
