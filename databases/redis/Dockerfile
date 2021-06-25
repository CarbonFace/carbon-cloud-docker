##Dockerfile for carbon-cloud redis server
##any redis.conf file can be used in building custom redis server image
##attention should be paid for parameter [daemonize = no] in the config file
#FROM redis:6-alpine AS build
#MAINTAINER CarbonFace<553127022@qq.com>
#
#FROM gcr.io/distroless/base
#ENV TZ      Asia/Shanghai
#
#RUN apk update && apk add tzdata
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
#
#RUN mkdir /data/conf /data/db
#VOLUME /data/config /data/db
#COPY redis.conf /data/conf/
#ENTRYPOINT ["redis-server","/data/conf/redis.conf"]

FROM redis:6-alpine
MAINTAINER CarbonFace<553127022@qq.com>
ENV REDIS_REQUIREPASS   root
RUN mkdir /data/conf /data/db
COPY redis.conf /data/conf/
RUN sed -i '/^requirepass/requirepass '$REDIS_REQUIREPASS'/' /data/conf/redis.conf
CMD ["redis-server","/data/conf/redis.conf"]