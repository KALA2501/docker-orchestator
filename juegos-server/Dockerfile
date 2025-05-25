FROM node:16-slim

# Install git
RUN apt-get update && apt-get install -y git

# Set working directory
WORKDIR /usr/src/app

# Clone only the backend repo (without games)
RUN git clone https://github.com/KALA2501/JuegosServer.git .

# Install dependencies
RUN npm install

# Copy local games folder into the image
COPY ./games ./games

# Expose game server port
EXPOSE 9094

# Start the server
CMD ["node", "server.js"]
