FROM --platform=${BUILDPLATFORM} golang:1.20-alpine as builder
ARG TARGETOS
ARG TARGETARCH
WORKDIR /src
# ...this has no go.sum...
COPY go.mod ./
RUN go mod download
COPY . ./
RUN --mount=target=. \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -tags osusergo,netgo -ldflags "-s -w" -o /hellorld .

FROM alpine:3.18
COPY --from=builder /hellorld /
ENV PATH /
USER 65534
CMD ["/hellorld"]
