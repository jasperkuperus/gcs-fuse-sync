FROM golang:1.14-alpine3.11 as gcsfuse-builder

RUN apk add --update --no-cache git && \
    go get -v github.com/googlecloudplatform/gcsfuse

FROM alpine:3.11

RUN apk add --update --no-cache fuse ca-certificates && rm -rf /tmp/* && apk add unison
RUN mkdir /gcs-mount && mkdir /bucket-share

COPY --from=gcsfuse-builder /go/bin/gcsfuse /usr/local/bin/

WORKDIR /app
COPY run.sh /app

CMD ["./run.sh"]
