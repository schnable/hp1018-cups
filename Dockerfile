FROM arm32v6/alpine:3.8

# install dependencies
RUN apk add --no-cache cups cups-filters ghostscript eudev grep

# install foo2zjs drivers for HP LaserJet 1000
RUN apk add --no-cache cups-dev build-base groff vim && \
    wget -O foo2zjs.tar.gz http://foo2zjs.rkkda.com/foo2zjs.tar.gz && \
    tar xzf foo2zjs.tar.gz && \
    cd /foo2zjs && \
    make && \
    ./getweb 1000 && \
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

# add HP LaserJet 1000 printer
RUN cupsd -f -C /etc/cups/cupsd.conf -s /etc/cups/cups-files.conf & \
    sleep 1 && \
    lpadmin \
        -m lsb/usr/foo2zjs/HP-LaserJet_1000.ppd.gz \
        -p hp-laserjet-1000 \
        -v usb://HP/LaserJet%201000 -E \
        -D "HP LaserJet 1000" \
        -L "Home" && \
    sleep 1 && \
    kill %1 && \
    sleep 1

COPY run.sh /

CMD ["/run.sh"]
