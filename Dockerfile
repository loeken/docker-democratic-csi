FROM node:current-alpine3.17 AS build
ENV DEBIAN_FRONTEND=noninteractive

ENV MUSL_LOCALE_DEPS cmake make musl-dev gcc gettext-dev libintl 
ENV MUSL_LOCPATH /usr/share/i18n/locales/musl

ENV LANG=en_US.utf8
ENV NODE_ENV=production

RUN adduser -D csi \
    && mkdir /home/csi/app \
    && chown -R csi: /home/csi/app

WORKDIR /home/csi/app

# install wrappers
RUN ls /usr/bin
ADD docker/iscsiadm /usr/bin
RUN chmod +x /usr/bin/iscsiadm

ADD docker/multipath /usr/bin
RUN chmod +x /usr/bin/multipath

## USE_HOST_MOUNT_TOOLS=1
ADD docker/mount /usr/local/bin/mount
RUN chmod +x /usr/local/bin/mount

## USE_HOST_MOUNT_TOOLS=1
ADD docker/umount /usr/local/bin/umount
RUN chmod +x /usr/local/bin/umount

ADD docker/zfs /usr/local/bin/zfs
RUN chmod +x /usr/local/bin/zfs
ADD docker/zpool /usr/local/bin/zpool
RUN chmod +x /usr/local/bin/zpool
ADD docker/oneclient /usr/local/bin/oneclient
RUN chmod +x /usr/local/bin/oneclient


WORKDIR /home/csi/app

EXPOSE 50051
ENTRYPOINT [ "bin/democratic-csi" ]
