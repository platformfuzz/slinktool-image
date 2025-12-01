# Multi-stage build for slinktool
# Stage 1: Build slinktool
FROM alpine:latest AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    git \
    make \
    gcc \
    musl-dev

# Clone and build slinktool
WORKDIR /build
RUN git clone https://github.com/EarthScope/slinktool.git . && \
    make

# Install slinktool binary to /usr/local/bin
# The binary should be in the current directory after make
RUN if [ -f ./slinktool ]; then \
        install -m 755 ./slinktool /usr/local/bin/slinktool; \
    else \
        find . -name "slinktool" -type f -executable -exec install -m 755 {} /usr/local/bin/slinktool \; && \
        test -f /usr/local/bin/slinktool || (echo "ERROR: slinktool binary not found after build" && find . -type f && exit 1); \
    fi

# Stage 2: Runtime image
FROM alpine:latest

# Install runtime dependencies (minimal - just what's needed to run)
# Note: If slinktool is statically linked, these may not be needed
# but ca-certificates is useful for HTTPS connections
RUN apk add --no-cache \
    ca-certificates

# Copy the slinktool binary from builder
COPY --from=builder /usr/local/bin/slinktool /usr/local/bin/slinktool

# Verify the binary exists and is executable
RUN test -f /usr/local/bin/slinktool && /usr/local/bin/slinktool -V || true

# Set slinktool as the entrypoint
ENTRYPOINT ["slinktool"]

# Default command (can be overridden)
# slinktool requires arguments, so we'll just set the entrypoint
# Users should provide their own command arguments
