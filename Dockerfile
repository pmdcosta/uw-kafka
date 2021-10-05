FROM adoptopenjdk/openjdk16:alpine-slim

ENV LANG=C.UTF-8 \
    JAVA_HOME=/opt/java/openjdk \
    PATH=${PATH}:/opt/java/openjdk/bin \
    LANG=C.UTF-8 \
    KAFKA_VERSION="2.8.0" \
    SCALA_VERSION="2.13"

RUN sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=10/ $JAVA_HOME/conf/security/java.security

RUN mkdir -p /opt/kafka
WORKDIR /opt/kafka

RUN apk add --no-cache ca-certificates bash \
  && mkdir -p /opt/kafka \
# https://kafka.apache.org/downloads - uses different mirrors for different
# versions
# To be used for 3.0.0 version
#  && wget -O - https://dlcdn.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
   && wget -O - https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
       | tar xz -C /opt/kafka/ --strip 1

RUN ["/bin/bash", "-c", "echo \"export LANG=C.UTF-8\" > /etc/profile.d/locale.sh"]
WORKDIR /opt/kafka/bin

CMD ["./kafka-server-start.sh", "../config/server.properties"]
