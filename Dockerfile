FROM python:3.9-alpine

WORKDIR /app

# Get the files from the repository
RUN wget https://github.com/chavaone/broadlink-mqtt/archive/refs/heads/master.zip -O /tmp/broadlink.zip \
    && unzip /tmp/broadlink.zip -d /tmp \
    && cp -R  /tmp/broadlink-mqtt-master/* /app  \
    && rm -rf /tmp/broalink*

#Install systema and Python dependencies
RUN    apk update \
    && apk add gcc musl-dev libffi-dev openssl-dev python3-dev \
    && CRYPTOGRAPHY_DONT_BUILD_RUST=1 pip install -r requirements.txt \
    && apk del gcc \
    && rm -rf /var/cache/apk/*

VOLUME ["/app/conf", "/app/commands", "/app/macros"]

# set conf path
ENV BROADLINKMQTTCONFIG="/app/conf/mqtt.conf"
ENV BROADLINKMQTTCONFIGCUSTOM="/app/conf/custom.conf"

# run process
CMD python mqtt.py
