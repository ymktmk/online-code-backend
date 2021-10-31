FROM golang:latest

RUN mkdir /go/src/work

WORKDIR /go/src/work

COPY . /go/src/work

# RUN go run main.go

EXPOSE 10000

# CMD [ "go run main.go" ]