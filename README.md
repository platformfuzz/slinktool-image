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

# 1) Does the server answer?
docker run --rm ghcr.io/platformfuzz/slinktool-image:latest \
  -P rtserve.iris.washington.edu:18000

# 2) List stations available
docker run --rm ghcr.io/platformfuzz/slinktool-image:latest \
  -L rtserve.iris.washington.edu:18000

# 3) Stream a few seconds live (prints packet info)
docker run --rm ghcr.io/platformfuzz/slinktool-image:latest \
  -S IU_ANMO -s BHZ -nd 10 -p \
  rtserve.iris.washington.edu:18000

# 4) Pull last 15 minutes (time-window; SeedLink v3+)
docker run --rm ghcr.io/platformfuzz/slinktool-image:latest \
  -S IU_ANMO -s BHZ \
  -tw $(date -u -d '15 minutes ago' +%Y,%m,%d,%H,%M,%S):$(date -u +%Y,%m,%d,%H,%M,%S) \
  -p \
  rtserve.iris.washington.edu:18000
```

### Alternative Public Servers

If the default host is unreachable from your network, try other public servers:

- `rtserve.resif.fr:18000` (EPOS-France) - seismology.resif.fr
- `rtserver.ipgp.fr:18000` (GEOSCOPE/IPGP) - geoscope.ipgp.fr

### Troubleshooting

If you get "host not found/connection refused," it's usually DNS or outbound port 18000 blocked by a firewall. You can test reachability with:

```bash
nc -vz rtserve.iris.washington.edu 18000
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
