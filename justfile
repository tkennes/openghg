commonenv := "CGO_ENABLED=0"

version := "dev"
commit := `git rev-parse --short HEAD`

default:
    just --list

# Run unit tests
test:
    {{commonenv}} go test ./...

# Compile a local binary
build-local:
    cd ./cmd/ghgmodel && \
        {{commonenv}} go build \
        -ldflags \
          "-X github.com/tkennes/openghg/pkg/version.Version={{version}} \
           -X github.com/tkennes/openghg/pkg/version.GitCommit={{commit}}" \
        -o ./ghgmodel

# Build multiarch binaries
build-binary VERSION=version:
    cd ./cmd/ghgmodel && \
        {{commonenv}} GOOS=linux GOARCH=amd64 go build \
        -ldflags \
          "-X github.com/tkennes/openghg/pkg/version.Version={{VERSION}} \
           -X github.com/tkennes/openghg/pkg/version.GitCommit={{commit}}" \
        -o ./ghgmodel-amd64

    cd ./cmd/ghgmodel && \
        {{commonenv}} GOOS=linux GOARCH=arm64 go build \
        -ldflags \
          "-X github.com/tkennes/openghg/pkg/version.Version={{VERSION}} \
           -X github.com/tkennes/openghg/pkg/version.GitCommit={{commit}}" \
        -o ./ghgmodel-arm64

# Build and push a multi-arch Docker image
build IMAGETAG VERSION=version: test (build-binary VERSION)
    docker buildx build \
        --rm \
        --platform "linux/amd64" \
        -f 'Dockerfile.cross' \
        --build-arg binarypath=./cmd/ghgmodel/ghgmodel-amd64 \
        --provenance=false \
        -t {{IMAGETAG}}-amd64 \
        --push \
        .

    docker buildx build \
        --rm \
        --platform "linux/arm64" \
        -f 'Dockerfile.cross' \
        --build-arg binarypath=./cmd/ghgmodel/ghgmodel-arm64 \
        --provenance=false \
        -t {{IMAGETAG}}-arm64 \
        --push \
        .

    manifest-tool push from-args \
        --platforms "linux/amd64,linux/arm64" \
        --template {{IMAGETAG}}-ARCH \
        --target {{IMAGETAG}}
