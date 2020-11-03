FROM ubuntu

LABEL maintainer="Ben Green <ben@bcgdesign.com>" \
    org.label-schema.name="Dropbox" \
    org.label-schema.version="latest" \
    org.label-schema.vendor="Ben Green" \
    org.label-schema.schema-version="1.0"

ENV GID=1000
ENV UID=1000
ARG S6_VERSION=2.1.0.2

VOLUME [ "/files" ]

RUN apt update && \
    apt install -y curl wget python3 \
    libc6 libglib2.0-0 libglapi-mesa libxext6 libxdamage1 libxfixes3 libxcb-glx0 libxcb-dri2-0 libxcb-dri3-0 libxcb-present0 libxcb-sync1 libxshmfence1 libxxf86vm1 && \
    wget https://www.dropbox.com/download?dl=packages/dropbox.py -O /usr/local/bin/dropbox-cli  && \
    chmod +x /usr/local/bin/dropbox-cli

COPY ./install /tmp/install
RUN chmod +x /tmp/install && \
    /tmp/install && \
    rm /tmp/install

COPY ./overlay .

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "/usr/bin/healthcheck" ]

ENTRYPOINT [ "/init" ]
