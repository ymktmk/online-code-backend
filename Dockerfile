FROM golang:latest AS builder

RUN mkdir /go/src/work

WORKDIR /go/src/work

COPY main.go .
COPY go.mod .
COPY go.sum .

RUN CGO_ENABLED=0 GOOS=linux go build main.go

FROM docker:latest

COPY --from=builder /go/src/work/main ./

EXPOSE 10000

