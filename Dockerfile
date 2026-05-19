FROM alpine:latest
RUN apk add --no-cache bash curl jq grep

WORKDIR /app
COPY . .

RUN chmod +x /app/log_shield.sh
RUN chmod +x /app/src/init.sh

ENTRYPOINT ["/app/src/init.sh"]
