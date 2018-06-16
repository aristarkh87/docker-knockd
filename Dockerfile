FROM alpine

RUN apk add --no-cache \
        iptables \
        knock

CMD ["knockd"]
