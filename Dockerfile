FROM --platform=linux/x86_64 golang:latest AS builder

RUN mkdir /go/src/work

WORKDIR /go/src/work

COPY main.go .
COPY go.mod .
COPY go.sum .

RUN CGO_ENABLED=0 GOOS=linux go build main.go

FROM --platform=linux/x86_64 docker:latest

COPY --from=builder /go/src/work/main ./