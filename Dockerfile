FROM golang:1.16-alpine AS builder

WORKDIR /go/src/github.com/scm101/restic

# Caching dependencies
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go run build.go

FROM alpine:latest AS restic

RUN apk add --update --no-cache ca-certificates fuse openssh-client tzdata

COPY --from=builder /go/src/github.com/restic/restic/restic /usr/bin

ENV RESTIC_PASSWORD="fuzzpass"

RUN /usr/bin/restic init --repo /store

ENTRYPOINT ["/usr/bin/restic"]
