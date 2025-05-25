# Stage 1: Build environment
FROM openjdk:11-jre-slim AS builder

WORKDIR /opt

# Install tools and download Kafka and your repo
RUN apt-get update && \
    apt-get install -y wget curl bash git && \
    wget https://archive.apache.org/dist/kafka/2.8.0/kafka_2.13-2.8.0.tgz && \
    tar -xzf kafka_2.13-2.8.0.tgz && \
    git clone https://github.com/KALA2501/kafka.git kafka-src && \
    cp kafka-src/config/server.properties kafka_2.13-2.8.0/config/server.properties && \
    chmod +x kafka-src/start-kafka-zk.sh

# Stage 2: Final runtime image
FROM openjdk:11-jre-slim

WORKDIR /opt/kafka

# Install runtime dependencies only
RUN apt-get update && \
    apt-get install -y bash curl dnsutils net-tools && \
    rm -rf /var/lib/apt/lists/*

# Copy built Kafka and scripts from builder
COPY --from=builder /opt/kafka_2.13-2.8.0 /opt/kafka
COPY --from=builder /opt/kafka-src/start-kafka-zk.sh /opt/kafka-src/start-kafka-zk.sh

RUN chmod +x /opt/kafka-src/start-kafka-zk.sh

EXPOSE 8088 8089 2181

ENTRYPOINT ["/opt/kafka-src/start-kafka-zk.sh"]
