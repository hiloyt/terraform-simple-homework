FROM golang:1.20-bullseye

WORKDIR /app

COPY app/ /app
RUN go mod download
COPY app/cmd/ops-test-app/main.go /app

RUN CGO_ENABLED=0 GOOS=linux go build -o /faceit-app

FROM alpine:latest

WORKDIR /app

RUN apk --no-cache add ca-certificates
COPY --from=0 /faceit-app ./
CMD ["./faceit-app"]