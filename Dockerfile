FROM arm64v8/alpine
MAINTAINER alturismo alturismo@gmail.com

ENV TZ=Europe/Istanbul

ADD cronjob.sh /
ADD entrypoint.sh /
ADD sample_cron.txt /
ADD sample_xteve.txt /

RUN apk update && \
    apk upgrade && \
    apk add --no-cache ca-certificates && \

    # Extras
    apk add --no-cache curl && \

    # Timezone (TZ)
    apk update && apk add --no-cache tzdata && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \

    # Add Bash shell & dependancies
    apk add --no-cache bash busybox-suid su-exec && \

    # Add ffmpeg and vlc
    apk add ffmpeg && \
    apk add vlc && \
    sed -i 's/geteuid/getppid/' /usr/bin/vlc && \

    # Set executable permissions
    chmod +x /entrypoint.sh && \
    chmod +x /cronjob.sh

    # Add xTeve and guide2go
RUN wget https://github.com/xteve-project/xTeVe-Downloads/raw/master/xteve_linux_arm64.zip -O temp.zip && \
    unzip temp.zip -d /usr/bin/ && \
    rm temp.zip && \
    chmod +x /usr/bin/xteve


# Volumes
VOLUME /config
VOLUME /root/.xteve
VOLUME /tmp/xteve

# Expose Port
EXPOSE 34400

# Entrypoint
ENTRYPOINT ["./entrypoint.sh"]
