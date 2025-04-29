# This is the builder stage
FROM golang:1.22.5 AS base

# Set the working directory
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod ./
# (If you have go.sum, better to copy it too for dependency caching)

# Download dependencies
RUN go mod download

# Copy the entire source code
COPY . .

# Build the Go application
RUN go build -o main .

#######################################################
# This is the final runtime stage
FROM gcr.io/distroless/base

# Set working directory
WORKDIR /

# Copy the binary from the builder stage
COPY --from=base /app/main .

# Copy the static files directory (if it exists)
COPY --from=base /app/static ./static

# Expose the port
EXPOSE 8080

# Command to run
CMD ["./main"]

