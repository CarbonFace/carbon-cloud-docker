FROM openjdk:8-jdk-alpine
MAINTAINER CarbonFace<553127022@qq.com>
ENV SERVICE_NAME                "carbon-cloud-app"
#ARG DEFAULT_VERSION=0.0.1-SNAPSHOT.jar
#ARG WORK_DIR=/$SERVICE_NAME
#ARG JAR_NAME="$SERVICE_NAME-$DEFAULT_VERSION"
#ENV SERVICE_JAR=$WORK_DIR/$JAR_NAME

ENV TZ                          Asia/Shanghai
ENV DEBUG                       false
ENV SPRING_PROFILES_ACTIVE      dev

RUN apk update \
    && apk add tzdata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY carbon-cloud-docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/carbon-cloud-docker-entrypoint.sh /entrypoint.sh # backwards compat
RUN chmod +x /usr/local/bin/carbon-cloud-docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]