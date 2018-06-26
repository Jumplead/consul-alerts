FROM golang:1.10 as build

WORKDIR /go/src/github.com/AcalephStorage/consul-alerts

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go get -v github.com/hashicorp/consul

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w"

FROM alpine:latest

RUN apk add --no-cache ca-certificates

EXPOSE 9000

COPY --from=build /go/src/github.com/AcalephStorage/consul-alerts/consul-alerts /bin
COPY --from=build /go/bin/consul /bin

ENTRYPOINT ["consul-alerts"]
CMD ["--alert-addr=0.0.0.0:9000"]
