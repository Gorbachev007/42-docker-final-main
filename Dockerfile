# Use the official Golang image as a build stage
FROM golang:1.22.0 as builder

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files to the working directory
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go application
RUN go build -o /parcel-tracker

# Use the alpine base image to reduce the final image size and ensure compatibility with glibc
FROM alpine:latest

# Install glibc compatibility for alpine
RUN apk --no-cache add libc6-compat

# Set the working directory inside the container
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /parcel-tracker /app/parcel-tracker

# Copy the SQLite database if needed
COPY tracker.db /app/tracker.db

# Expose the port on which the application runs
EXPOSE 8080

# Command to run the application
CMD ["/app/parcel-tracker"]
