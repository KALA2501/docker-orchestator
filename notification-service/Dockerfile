# Use Node.js base image
FROM node:18-slim

# Set working directory
WORKDIR /app

# Install git
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean

# Clone the repo
RUN git clone https://github.com/KALA2501/notification-service.git

# Set working directory to the cloned project
WORKDIR /app/notification-service

# Install production dependencies
RUN npm install --production

# Expose port
EXPOSE 9090

# Run the service
CMD ["node", "email-consumer.js"]
