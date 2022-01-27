FROM alpine:3.10

# install dependencies
RUN apk add --no-cache cups cups-filters ghostscript eudev grep

# https://web.archive.org/web/20150917015611/http://foo2zjs.rkkda.com/foo2zjs.tar.gz
# install foo2zjs drivers for HP LaserJet 1018
RUN apk add --no-cache cups-dev build-base groff vim && \
    wget -O foo2zjs.tar.gz https://web.archive.org/web/20150917015611/http://foo2zjs.rkkda.com/foo2zjs.tar.gz && \
    tar xzf foo2zjs.tar.gz && \
    cd /foo2zjs && \
    make && \
    ./getweb 1018 && \
    make install && \
    make install-hotplug && \
    apk del --no-cache cups-dev build-base groff vim && \
    rm -Rf /foo2zjs /foo2zjs.tar.gz

# setup listen port
RUN cupsd -f -C /etc/cups/cupsd.conf -s /etc/cups/cups-files.conf & \
    sleep 1 && \
    cupsctl --remote-admin --remote-any && \
    sleep 1 && \
    kill %1 && \
    sleep 1

# add HP LaserJet 1018 printer
RUN cupsd -f -C /etc/cups/cupsd.conf -s /etc/cups/cups-files.conf & \
    sleep 1 && \
    lpadmin \
        -m lsb/usr/foo2zjs/HP-LaserJet_1018.ppd.gz \
        -p hp-laserjet-1018 \
        -v usb://HP/LaserJet%201000 -E \
        -D "HP LaserJet 1018" \
        -L "Home" && \
    sleep 1 && \
    kill %1 && \
    sleep 1

COPY run.sh /

CMD ["/run.sh"]
