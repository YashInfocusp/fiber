# Use the official Golang image as a base image
FROM golang:1.24-alpine

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
# Note: For Codecov to work, you might need to pass the CODECOV_TOKEN as an environment variable during docker run
# and potentially adjust the Codecov upload step if you want to integrate it with Docker runs.
# This Dockerfile primarily focuses on running the tests.
CMD ["gotestsum", "-f", "testname", "--", "./...", "-race", "-count=1", "-coverprofile=coverage.txt", "-covermode=atomic", "-shuffle=on"]
