FROM sunbird/openjdk-java11-alpine:latest
RUN apk update \
    && apk add  unzip \
    && apk add curl \
    && adduser -u 1001 -h /home/analytics/ -D analytics \
    && mkdir -p /home/analytics
RUN chown -R analytics:analytics /home/analytics
USER analytics
COPY analytics-api/target/analytics-api-2.0-dist.zip /home/analytics/
RUN unzip /home/analytics/analytics-api-2.0-dist.zip -d /home/analytics/
RUN rm /home/analytics/analytics-api-2.0-dist.zip
WORKDIR /home/analytics/
CMD java -XX:+PrintFlagsFinal $JAVA_OPTIONS -cp '/home/analytics/analytics-api-2.0/lib/*' -Dconfig.file=/home/analytics/{{ env }}.conf -Xms1g -Xmx2g -XX:+UseG1GC -XX:+UseStringDeduplication play.core.server.ProdServerStart /home/analytics/analytics-api-2.0