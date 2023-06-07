FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.20-alpine as builder
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

ARG WSDISKPATHS
ARG MOD1=./
ARG MOD2=./
ARG MOD3=./
ARG MOD4=./
ARG MOD5=./
ARG MOD6=./
ARG MOD7=./
ARG MOD8=./
ARG MOD9=./

RUN go build std

WORKDIR /ws

COPY --from=bctx1 . ${MOD1}
COPY --from=bctx2 . ${MOD2}
COPY --from=bctx3 . ${MOD3}
COPY --from=bctx4 . ${MOD4}
COPY --from=bctx5 . ${MOD5}
COPY --from=bctx6 . ${MOD6}
COPY --from=bctx7 . ${MOD7}
COPY --from=bctx8 . ${MOD8}
COPY --from=bctx9 . ${MOD9}

# Make sure we have the main module containing a main package to be build...
# ...this has no go.sum...
COPY go.mod ./hellorld/

# Establish the (kinda fake) Go workspace
RUN go work init ${WSDISKPATHS}

WORKDIR /ws/hellorld
RUN go mod download -x
COPY *.go ./
RUN --mount=target=. \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build -v -tags osusergo,netgo -ldflags "-s -w" \
    -o /hellorld .

FROM alpine:3.18
COPY --from=builder /hellorld /
ENV PATH /
USER 65534
CMD ["/hellorld"]
