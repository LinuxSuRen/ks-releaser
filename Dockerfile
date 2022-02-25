FROM golang:1.16 as builder

WORKDIR /var/app

COPY api api
COPY controllers controllers
COPY go.mod go.mod
COPY go.sum go.sum
COPY main.go main.go

RUN go build -o ks-releaser main.go

FROM gcr.io/distroless/static:nonroot
COPY --from=builder ks-releaser /ks-releaser

ENTRYPOINT ["/ks-releaser"]
