# Use the official Golang image as a base image
FROM golang:1.24-alpine

# Enable IPv6
# Note: This attempts to enable IPv6 within the container.
# For this to work, your Docker daemon and network must also be configured to support IPv6.
# You might also need to run the container with appropriate --sysctl flags if this is not sufficient.
RUN apk add --no-cache ip6tables && \
    sysctl -w net.ipv6.conf.all.disable_ipv6=0 && \
    sysctl -w net.ipv6.conf.default.disable_ipv6=0 && \
    sysctl -w net.ipv6.conf.lo.disable_ipv6=0

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source code into the container
COPY . .

# Install gotestsum
RUN go install gotest.tools/gotestsum@latest

# Command to run the tests
# This will execute the same test command as in the 'unit' job of test.yml
CMD ["gotestsum", "-f", "testname", "--", "./...", "-race", "-count=1", "-coverprofile=coverage.txt", "-covermode=atomic", "-shuffle=on"]
