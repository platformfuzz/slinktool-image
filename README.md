# slinktool-image

Docker image for slinktool, a command-line utility to query and retrieve seismic waveform data from SeedLink and FDSN data centers.

## Overview

This repository contains a containerized version of the [slinktool](https://github.com/EarthScope/slinktool) CLI tool. The image is built from source and published to GitHub Container Registry (GHCR) for easy deployment and use.

## Quick Start

### Pull and Run

```bash
docker pull ghcr.io/platformfuzz/slinktool-image:latest
docker run --rm ghcr.io/platformfuzz/slinktool-image:latest -V
```

### Example Usage

```bash
# Check version
docker run --rm ghcr.io/platformfuzz/slinktool-image:latest -V

# Query a SeedLink server
docker run --rm ghcr.io/platformfuzz/slinktool-image:latest \
  -S your-server:18000 \
  -s "NET_STA" \
  -b 2024-01-01T00:00:00 \
  -e 2024-01-01T01:00:00
```

## Build Locally

### Prerequisites

- Docker

### Build Instructions

```bash
# Clone the repository
git clone https://github.com/platformfuzz/slinktool-image.git
cd slinktool-image

# Build the image
docker build -t slinktool-image:local .

# Test the image
docker run --rm slinktool-image:local -V
```

## CI/CD

This repository includes GitHub Actions workflows that:

- **CI Workflow** (`.github/workflows/ci.yml`):
  - Runs on pull requests
  - Builds the Docker image
  - Tests that slinktool is accessible

- **Build and Release Workflow** (`.github/workflows/build-and-release.yml`):
  - Runs on pushes to `main` branch
  - Builds and pushes to `ghcr.io/platformfuzz/slinktool-image:latest`
  - On version tags (e.g., `v1.0.0`), creates a tagged release
  - Supports semantic versioning with multiple tag patterns

Images are available at: `ghcr.io/platformfuzz/slinktool-image`

## Image Details

- **Base Image:** Alpine Linux (minimal size)
- **Build Strategy:** Multi-stage build for optimal image size
- **Entrypoint:** `slinktool`
- **Source:** Built from [EarthScope/slinktool](https://github.com/EarthScope/slinktool)

## Project Structure

```text
slinktool-image/
├── Dockerfile                 # Multi-stage build definition
├── .github/
│   └── workflows/
│       ├── ci.yml             # CI workflow for PRs
│       └── build-and-release.yml  # CI/CD to build and push to GHCR
├── .dockerignore              # Files to exclude from build context
└── README.md
```

## License

MIT License - see LICENSE file for details.

## Related Projects

- [slinktool](https://github.com/EarthScope/slinktool) - Source repository for the slinktool CLI
