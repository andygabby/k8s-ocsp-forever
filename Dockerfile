FROM golang:1.12 as build

ADD . /go/src/github.com/letsencrypt/boulder
WORKDIR /go/src/github.com/letsencrypt/boulder

ARG GOFLAGS=""
RUN go get ${GOFLAGS} ./test/ocsp/ocsp_forever

FROM gcr.io/distroless/base

LABEL maintainer="Let's Encrypt SRE <sre@letsencrypt.org>"

COPY --from=build /go/bin/ocsp_forever /

ENTRYPOINT ["/ocsp_forever"]
