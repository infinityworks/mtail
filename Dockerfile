FROM alpine:edge
LABEL maintainer "Infinity Works"

ENV GOPATH /go

RUN apk add --update -t .build-deps go git make libc-dev \
    && mkdir /logs \
    && git clone https://github.com/google/mtail.git $GOPATH/src/github.com/google/mtail \
    && cd $GOPATH/src/github.com/google/mtail \
    && make \
    && cp $GOPATH/bin/mtail /bin/mtail \
    && cp -r $GOPATH/src/github.com/google/mtail/examples /progs \
    && addgroup exporter \
    && adduser -S -G exporter exporter \
    && apk del --purge .build-deps \
    && rm -rf /go /var/cache/apk/*

COPY progs/* /progs/

USER exporter

EXPOSE 3903

ENTRYPOINT [ "/bin/mtail", "-logtostderr" ]
